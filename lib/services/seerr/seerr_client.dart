import 'dart:developer' as developer;

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
        return const ServiceIdentity(instanceName: 'Seerr', version: '1.0');
      },
    );
  }

  Future<Result<List<SeerrResult>>> _discovery(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dioCall(
      () => _dio.get(path, queryParameters: queryParameters),
      map: (data) {
        try {
          return SeerrDiscoveryResponse.fromJson(data as Map<String, dynamic>)
              .results;
        } catch (e, st) {
          developer.log(
            'Seerr discovery ($path) parse error: $e',
            name: 'arrstack.seerr',
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
      },
    );
  }

  Future<Result<List<SeerrResult>>> getDiscoverMovies() =>
      _discovery('api/v1/discover/movies');

  Future<Result<List<SeerrResult>>> getDiscoverTv() =>
      _discovery('api/v1/discover/tv');

  Future<Result<List<SeerrResult>>> getTrending() =>
      _discovery('api/v1/discover/trending');

  Future<Result<List<SeerrResult>>> getUpcomingMovies() =>
      _discovery('api/v1/discover/movies/upcoming');

  Future<Result<List<SeerrResult>>> getUpcomingTv() =>
      _discovery('api/v1/discover/tv/upcoming');

  Future<Result<List<SeerrResult>>> getMoviesByGenre(int genreId) =>
      _discovery('api/v1/discover/movies/genre/$genreId');

  Future<Result<List<SeerrResult>>> getTvByGenre(int genreId) =>
      _discovery('api/v1/discover/tv/genre/$genreId');

  Future<Result<List<SeerrGenre>>> _genreSlider(String path) {
    return dioCall(
      () => _dio.get(path),
      map: (data) {
        try {
          return (data as List)
              .map((e) => SeerrGenre.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (e, st) {
          developer.log(
            'Seerr genre slider ($path) parse error: $e',
            name: 'arrstack.seerr',
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
      },
    );
  }

  Future<Result<List<SeerrGenre>>> getMovieGenres() =>
      _genreSlider('api/v1/discover/genreslider/movie');

  Future<Result<List<SeerrGenre>>> getTvGenres() =>
      _genreSlider('api/v1/discover/genreslider/tv');

  Future<Result<List<SeerrResult>>> search(String query) {
    return dioCall(
      () => _dio.get('api/v1/search', queryParameters: {'query': query}),
      map: (data) {
        try {
          return SeerrDiscoveryResponse.fromJson(data as Map<String, dynamic>)
              .results;
        } catch (e, st) {
          developer.log(
            'Seerr search parse error: $e',
            name: 'arrstack.seerr',
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
      },
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

  Future<Result<SeerrRequest>> request(
    int tmdbId,
    String mediaType, {
    List<int>? seasons,
  }) {
    return dioCall(
      () => _dio.post(
        'api/v1/request',
        data: {'mediaType': mediaType, 'mediaId': tmdbId, 'seasons': ?seasons},
      ),
      map: (data) => SeerrRequest.fromJson(data as Map<String, dynamic>),
    );
  }

  /// `filter`: pending | approved | declined | all (default 'all').
  /// `sort`: added | modified (default 'added').
  Future<Result<SeerrRequestsResponse>> getRequests({
    String filter = 'all',
    String sort = 'added',
    int take = 20,
    int skip = 0,
  }) {
    return dioCall(
      () => _dio.get(
        'api/v1/request',
        queryParameters: {
          'filter': filter,
          'sort': sort,
          'take': take,
          'skip': skip,
        },
      ),
      map: (data) {
        try {
          return SeerrRequestsResponse.fromJson(data as Map<String, dynamic>);
        } catch (e, st) {
          developer.log(
            'Seerr getRequests parse error: $e',
            name: 'arrstack.seerr',
            error: e,
            stackTrace: st,
          );
          rethrow;
        }
      },
    );
  }

  Future<Result<void>> deleteRequest(int requestId) {
    return dioCall(
      () => _dio.delete('api/v1/request/$requestId'),
      map: (data) {},
    );
  }
}
