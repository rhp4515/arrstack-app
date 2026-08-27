import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:dio/dio.dart';

class SeerrClient implements ConnectionTestClient {
  const SeerrClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/v1/status'),
      map: (data) {
        return const ServiceIdentity(
          instanceName: 'Seerr',
          version: '1.0',
        );
      },
    );
  }

  Future<Result<List<SeerrResult>>> getDiscoverMovies() {
    return dioCall(
      () => _dio.get('api/v1/discover/movies'),
      map: (data) => SeerrDiscoveryResponse.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<Result<List<SeerrResult>>> getDiscoverTv() {
    return dioCall(
      () => _dio.get('api/v1/discover/tv'),
      map: (data) => SeerrDiscoveryResponse.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<Result<List<SeerrResult>>> search(String query) {
    return dioCall(
      () => _dio.get('api/v1/search', queryParameters: {'query': query}),
      map: (data) => SeerrDiscoveryResponse.fromJson(data as Map<String, dynamic>).results,
    );
  }

  Future<Result<SeerrResult>> getMovieDetail(int id) {
    return dioCall(
      () => _dio.get('api/v1/movie/$id'),
      map: (data) => SeerrResult.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<SeerrResult>> getTvDetail(int id) {
    return dioCall(
      () => _dio.get('api/v1/tv/$id'),
      map: (data) => SeerrResult.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<SeerrRequest>> request(int tmdbId, String mediaType, {List<int>? seasons}) {
    return dioCall(
      () => _dio.post(
        'api/v1/request',
        data: {
          'mediaType': mediaType,
          'mediaId': tmdbId,
          'seasons': ?seasons,
        },
      ),
      map: (data) => SeerrRequest.fromJson(data as Map<String, dynamic>),
    );
  }
}
