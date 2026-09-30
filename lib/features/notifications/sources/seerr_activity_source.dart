/// Seerr activity: new media requests and newly reported issues.
///
/// Checkpoint: `r:<newest request id>;i:<newest issue id>`. Seerr ids only
/// grow, so "id greater than the checkpoint" means "created since".
library;

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
  }) : id = 'seerr.$instanceId';

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
    final items = <SourceItem>[
      for (final request in newRequests)
        SourceItem(
          key: 'request.${request.id}',
          title: await _title(request.media, 'Request #${request.id}'),
          detail: _by('Requested', request.requestedBy),
        ),
      for (final issue in newIssues)
        SourceItem(
          key: 'issue.${issue.id}',
          title: await _title(issue.media, 'Issue #${issue.id}'),
          detail: _by(
            '${SeerrIssueType.label(issue.issueType)} issue reported',
            issue.createdBy,
          ),
        ),
    ];
    return Ok(SourceCheck(items: items, checkpoint: next.toString()));
  }

  /// Requests and issues only carry a TMDB id; the title needs a lookup.
  /// Best-effort — a failed lookup falls back to "Request #12".
  Future<String> _title(SeerrRequestMedia? media, String fallback) async {
    final tmdbId = media?.tmdbId;
    if (media == null || tmdbId == null) return fallback;
    final detail = media.mediaType == 'tv'
        ? await _repository.getTvDetail(tmdbId)
        : await _repository.getMovieDetail(tmdbId);
    return switch (detail) {
      Ok(:final value) => _withYear(value) ?? fallback,
      Err() => fallback,
    };
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
