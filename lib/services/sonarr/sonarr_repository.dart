/// Repository for Sonarr service logic.
///
/// Orchestrates API calls via [SonarrClient] and handles data mapping and
/// error management (spec §5, §11).
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';

class SonarrRepository {
  const SonarrRepository(this._client);

  final SonarrClient _client;

  Future<Result<List<SonarrSeries>>> listSeries() => _client.getSeries();

  Future<Result<SonarrSeries>> getSeries(int id) => _client.getSeriesById(id);

  Future<Result<List<SonarrSeries>>> searchLookup(String term) =>
      _client.lookupSeries(term);

  Future<Result<SonarrSeries>> addSeries(SonarrSeries series) =>
      _client.addSeries(series);

  Future<Result<void>> updateSeries(SonarrSeries series) =>
      _client.updateSeries(series);

  Future<Result<void>> deleteSeries(int id, {bool deleteFiles = false}) =>
      _client.deleteSeries(id, deleteFiles: deleteFiles);

  Future<Result<List<SonarrEpisode>>> listEpisodes(int seriesId) =>
      _client.getEpisodes(seriesId);

  Future<Result<List<SonarrRelease>>> searchEpisodeReleases(int episodeId) =>
      _client.searchEpisodeReleases(episodeId);

  Future<Result<void>> grabRelease({
    required String guid,
    required int indexerId,
  }) => _client.grabRelease(guid: guid, indexerId: indexerId);

  Future<Result<List<SonarrCalendarEpisode>>> listCalendar(
    DateTime start,
    DateTime end,
  ) => _client.getCalendar(start, end);

  Future<Result<List<SonarrQualityProfile>>> listQualityProfiles() =>
      _client.getQualityProfiles();

  Future<Result<List<SonarrRootFolder>>> listRootFolders() =>
      _client.getRootFolders();

  Future<Result<List<SonarrQueueItem>>> listQueue() => _client.getQueue();
}
