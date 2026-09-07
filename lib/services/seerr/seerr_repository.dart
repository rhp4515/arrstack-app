import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';

class SeerrRepository {
  const SeerrRepository(this._client);

  final SeerrClient _client;

  Future<Result<List<SeerrResult>>> discoverMovies() =>
      _client.getDiscoverMovies();

  Future<Result<List<SeerrResult>>> discoverTv() => _client.getDiscoverTv();

  Future<Result<List<SeerrResult>>> trending() => _client.getTrending();

  Future<Result<List<SeerrResult>>> upcomingMovies() =>
      _client.getUpcomingMovies();

  Future<Result<List<SeerrResult>>> upcomingTv() => _client.getUpcomingTv();

  Future<Result<List<SeerrResult>>> moviesByGenre(int genreId) =>
      _client.getMoviesByGenre(genreId);

  Future<Result<List<SeerrResult>>> tvByGenre(int genreId) =>
      _client.getTvByGenre(genreId);

  Future<Result<List<SeerrGenre>>> movieGenres() => _client.getMovieGenres();

  Future<Result<List<SeerrGenre>>> tvGenres() => _client.getTvGenres();

  Future<Result<List<SeerrResult>>> search(String query) =>
      _client.search(query);

  Future<Result<SeerrResult>> getMovieDetail(int id) =>
      _client.getMovieDetail(id);

  Future<Result<SeerrResult>> getTvDetail(int id) => _client.getTvDetail(id);

  Future<Result<SeerrRequest>> request(
    int tmdbId,
    String mediaType, {
    List<int>? seasons,
  }) => _client.request(tmdbId, mediaType, seasons: seasons);

  Future<Result<SeerrRequestsResponse>> getRequests({
    String filter = 'all',
    String sort = 'added',
    int take = 20,
    int skip = 0,
  }) => _client.getRequests(filter: filter, sort: sort, take: take, skip: skip);

  Future<Result<void>> deleteRequest(int requestId) =>
      _client.deleteRequest(requestId);
}
