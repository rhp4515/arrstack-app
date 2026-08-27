import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';

class SeerrRepository {
  const SeerrRepository(this._client);

  final SeerrClient _client;

  Future<Result<List<SeerrResult>>> discoverMovies() => _client.getDiscoverMovies();

  Future<Result<List<SeerrResult>>> discoverTv() => _client.getDiscoverTv();

  Future<Result<List<SeerrResult>>> search(String query) => _client.search(query);

  Future<Result<SeerrResult>> getMovieDetail(int id) => _client.getMovieDetail(id);

  Future<Result<SeerrResult>> getTvDetail(int id) => _client.getTvDetail(id);

  Future<Result<SeerrRequest>> request(int tmdbId, String mediaType, {List<int>? seasons}) =>
      _client.request(tmdbId, mediaType, seasons: seasons);
}
