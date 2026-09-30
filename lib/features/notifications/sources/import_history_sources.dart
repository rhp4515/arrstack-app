/// "Media ready" sources: movies Radarr imported and episodes Sonarr
/// imported, read from each instance's history.
///
/// Checkpoint: the ISO-8601 date of the newest history record already
/// seen. It's taken from the server's own records rather than this
/// device's clock, so a phone whose clock runs fast can't skip an import.
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/models/sonarr_history.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';

/// The history event *arr records when a download finishes importing.
const String importedEventType = 'downloadFolderImported';

/// Shared checkpoint logic; subclasses supply the history calls and how a
/// record reads in a notification.
abstract class _ImportHistorySource<R> implements NotificationSource {
  _ImportHistorySource({required this.id, required this.instanceName});

  @override
  final String id;

  @override
  final String instanceName;

  DateTime Function() clock = DateTime.now;

  @override
  NotificationChannel get channel => NotificationChannel.mediaReady;

  Future<Result<List<R>>> latest();
  Future<Result<List<R>>> since(DateTime since);
  DateTime recordDate(R record);
  String recordEvent(R record);
  SourceItem toItem(R record);

  @override
  Future<Result<SourceCheck>> check(String? checkpoint) async {
    final previous = checkpoint == null ? null : DateTime.tryParse(checkpoint);
    if (previous == null) {
      // Start from the newest record on the server (or now, for an empty
      // history), so turning notifications on doesn't replay old imports.
      return switch (await latest()) {
        Ok(:final value) => Ok(
          SourceCheck(
            items: const [],
            checkpoint:
                (value.isEmpty
                        ? clock().toUtc()
                        : _newest(value, recordDate(value.first)))
                    .toIso8601String(),
          ),
        ),
        Err(:final error) => Err(error),
      };
    }

    switch (await since(previous)) {
      case Err(:final error):
        return Err(error);
      case Ok(:final value):
        // `since` is inclusive on the server; drop the record the previous
        // checkpoint came from.
        final fresh = value.where((r) => recordDate(r).isAfter(previous));
        final imports =
            fresh.where((r) => recordEvent(r) == importedEventType).toList()
              ..sort((a, b) => recordDate(b).compareTo(recordDate(a)));
        // A multi-file import can log the same item more than once.
        final seen = <String>{};
        final items = [
          for (final record in imports)
            if (seen.add(toItem(record).title)) toItem(record),
        ];
        return Ok(
          SourceCheck(
            items: items,
            checkpoint: _newest(value, previous).toIso8601String(),
          ),
        );
    }
  }

  DateTime _newest(List<R> records, DateTime floor) => records
      .map((r) => recordDate(r).toUtc())
      .fold(floor.toUtc(), (a, b) => b.isAfter(a) ? b : a);
}

class RadarrImportSource extends _ImportHistorySource<RadarrHistoryRecord> {
  RadarrImportSource({
    required String instanceId,
    required super.instanceName,
    required this._repository,
  }) : super(id: 'radarr.$instanceId');

  final RadarrRepository _repository;

  @override
  String singleTitle(SourceItem item) => 'Movie ready';

  @override
  String groupTitle(int count) => '$count movies ready';

  @override
  Future<Result<List<RadarrHistoryRecord>>> latest() =>
      _repository.getHistory(pageSize: 10);

  @override
  Future<Result<List<RadarrHistoryRecord>>> since(DateTime since) =>
      _repository.getHistorySince(since);

  @override
  DateTime recordDate(RadarrHistoryRecord record) => record.date;

  @override
  String recordEvent(RadarrHistoryRecord record) => record.eventType;

  @override
  SourceItem toItem(RadarrHistoryRecord record) => SourceItem(
    key: '${record.id}',
    title: record.displayTitle,
    detail: record.qualityName,
  );
}

class SonarrImportSource extends _ImportHistorySource<SonarrHistoryRecord> {
  SonarrImportSource({
    required String instanceId,
    required super.instanceName,
    required this._repository,
  }) : super(id: 'sonarr.$instanceId');

  final SonarrRepository _repository;

  @override
  String singleTitle(SourceItem item) => 'Episode ready';

  @override
  String groupTitle(int count) => '$count episodes ready';

  @override
  Future<Result<List<SonarrHistoryRecord>>> latest() =>
      _repository.getHistory(pageSize: 10);

  @override
  Future<Result<List<SonarrHistoryRecord>>> since(DateTime since) =>
      _repository.getHistorySince(since);

  @override
  DateTime recordDate(SonarrHistoryRecord record) => record.date;

  @override
  String recordEvent(SonarrHistoryRecord record) => record.eventType;

  @override
  SourceItem toItem(SonarrHistoryRecord record) {
    final details = [?record.episodeTitle, ?record.qualityName];
    return SourceItem(
      key: '${record.id}',
      title: record.displayTitle,
      detail: details.isEmpty ? null : details.join(' · '),
    );
  }
}
