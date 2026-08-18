/// Repository for Radarr service logic.
///
/// Orchestrates API calls via [RadarrClient] and handles data mapping and
/// error management (spec §5, §11).
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';

class RadarrRepository {
  const RadarrRepository(this._client);

  final RadarrClient _client;

  Future<Result<List<RadarrMovie>>> listMovies() => _client.getMovies();

  Future<Result<RadarrMovie>> getMovie(int id) => _client.getMovie(id);

  Future<Result<List<RadarrMovie>>> searchLookup(String term) =>
      _client.lookupMovie(term);

  Future<Result<RadarrMovie>> addMovie(RadarrMovie movie) =>
      _client.addMovie(movie);

  Future<Result<void>> updateMovie(RadarrMovie movie) =>
      _client.updateMovie(movie);

  Future<Result<void>> deleteMovie(int id, {bool deleteFiles = false}) =>
      _client.deleteMovie(id, deleteFiles: deleteFiles);

  Future<Result<List<RadarrMovie>>> listCalendar(
    DateTime start,
    DateTime end,
  ) => _client.getCalendar(start, end);

  Future<Result<List<RadarrQualityProfile>>> listQualityProfiles() =>
      _client.getQualityProfiles();

  Future<Result<List<RadarrRootFolder>>> listRootFolders() =>
      _client.getRootFolders();

  Future<Result<List<RadarrQueueItem>>> listQueue() => _client.getQueue();
}
