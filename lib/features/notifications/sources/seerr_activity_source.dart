/// Seerr activity: new media requests and newly reported issues.
///
/// Checkpoint: `r:<newest request id>;i:<newest issue id>`. Seerr ids only
/// grow, so "id greater than the checkpoint" means "created since".
library;

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';

class SeerrActivitySource implements NotificationSource {
  SeerrActivitySource({
    required String instanceId,
    required this.instanceName,
    required this._repository,
    this.titleLookupTimeout = const Duration(seconds: 5),
  }) : id = 'seerr.$instanceId';

  /// How long one title lookup may take before its fallback is used. A
  /// single slow TMDB proxy must not be able to spend the whole source's
  /// time budget (see [NotificationChecker]'s `sourceTimeout`).
  final Duration titleLookupTimeout;

  @override
  final String id;

  @override
  final String instanceName;

  final SeerrRepository _repository;

  @override
  NotificationChannel get channel => NotificationChannel.seerrActivity;

  @override
  String singleTitle(SourceItem item) =>
      item.key.startsWith('issue.') ? 'New issue reported' : 'New request';

  @override
  String groupTitle(int count) => '$count new requests and issues';

  @override
  Future<Result<SourceCheck>> check(String? checkpoint) async {
    final requestsResult = await _repository.getRequests(take: 20);
    final List<SeerrRequest> requests;
    switch (requestsResult) {
      case Ok(:final value):
        requests = value.results;
      case Err(:final error):
        return Err(error);
    }
    final issuesResult = await _repository.getIssues(take: 20);
    final List<SeerrIssue> issues;
    switch (issuesResult) {
      case Ok(:final value):
        issues = value.results;
      case Err(:final error):
        return Err(error);
    }

    final previous = _Checkpoint.parse(checkpoint);
    final next = _Checkpoint(
      requestId: requests.fold(previous?.requestId ?? 0, _max),
      issueId: issues.fold(previous?.issueId ?? 0, _maxIssue),
    );
    if (previous == null) {
      return Ok(SourceCheck(items: const [], checkpoint: next.toString()));
    }

    final newRequests = requests.where((r) => r.id > previous.requestId);
    final newIssues = issues.where((i) => i.id > previous.issueId);
    // Built with fallback titles first: which titles are worth a lookup
    // depends on how many items there are.
    final pending = <({SourceItem item, SeerrRequestMedia? media})>[
      for (final request in newRequests)
        (
          item: SourceItem(
            key: 'request.${request.id}',
            title: 'Request #${request.id}',
            detail: _by('Requested', request.requestedBy),
          ),
          media: request.media,
        ),
      for (final issue in newIssues)
        (
          item: SourceItem(
            key: 'issue.${issue.id}',
            title: 'Issue #${issue.id}',
            detail: _by(
              '${SeerrIssueType.label(issue.issueType)} issue reported',
              issue.createdBy,
            ),
          ),
          media: issue.media,
        ),
    ];
    return Ok(
      SourceCheck(items: await _named(pending), checkpoint: next.toString()),
    );
  }

  /// Looks up titles for only the items that will be displayed, all at
  /// once.
  ///
  /// Each title costs a TMDB lookup, and up to forty used to run one after
  /// another inside the checker's per-source timeout. On a slow proxy that
  /// ran out, and a timed-out check never advances its checkpoint — so the
  /// next run met the same forty items and timed out again, and Seerr
  /// notifications stopped for good. But no more than
  /// [maxIndividualNotifications] titles are ever shown: that many as
  /// separate notifications, or that many named in one summary once there
  /// are more. The rest of the lookups bought nothing.
  Future<List<SourceItem>> _named(
    List<({SourceItem item, SeerrRequestMedia? media})> pending,
  ) async {
    final shown = pending.take(maxIndividualNotifications).toList();
    final titles = await Future.wait([
      for (final entry in shown) _title(entry.media, entry.item.title),
    ]);
    return [
      for (var i = 0; i < pending.length; i++)
        i < titles.length
            ? SourceItem(
                key: pending[i].item.key,
                title: titles[i],
                detail: pending[i].item.detail,
              )
            : pending[i].item,
    ];
  }

  /// Requests and issues only carry a TMDB id; the title needs a lookup.
  /// Best-effort — a failed or slow lookup falls back to "Request #12".
  Future<String> _title(SeerrRequestMedia? media, String fallback) async {
    final tmdbId = media?.tmdbId;
    if (media == null || tmdbId == null) return fallback;
    try {
      final detail =
          await (media.mediaType == 'tv'
                  ? _repository.getTvDetail(tmdbId)
                  : _repository.getMovieDetail(tmdbId))
              .timeout(titleLookupTimeout);
      return switch (detail) {
        Ok(:final value) => _withYear(value) ?? fallback,
        Err() => fallback,
      };
    } on TimeoutException {
      return fallback;
    }
  }

  static String? _withYear(SeerrResult result) {
    final title = result.displayTitle;
    if (title == null) return null;
    final year = result.displayYear;
    return year == null ? title : '$title ($year)';
  }

  static String _by(String what, SeerrRequestUser? user) {
    final name = user?.displayName ?? user?.email;
    return name == null ? what : '$what by $name';
  }

  static int _max(int current, SeerrRequest r) =>
      r.id > current ? r.id : current;

  static int _maxIssue(int current, SeerrIssue i) =>
      i.id > current ? i.id : current;
}

class _Checkpoint {
  const _Checkpoint({required this.requestId, required this.issueId});

  final int requestId;
  final int issueId;

  static _Checkpoint? parse(String? raw) {
    if (raw == null) return null;
    final match = RegExp(r'^r:(\d+);i:(\d+)$').firstMatch(raw);
    if (match == null) return null;
    return _Checkpoint(
      requestId: int.parse(match[1]!),
      issueId: int.parse(match[2]!),
    );
  }

  @override
  String toString() => 'r:$requestId;i:$issueId';
}
