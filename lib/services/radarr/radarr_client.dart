/// API client for Radarr (v3).
///
/// Implements the endpoints needed for library management and lookup.
library;

import 'dart:developer' as developer;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:dio/dio.dart';

class RadarrClient implements ConnectionTestClient {
  const RadarrClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/v3/system/status'),
      map: (data) {
        final map = data as Map<String, dynamic>;
        return ServiceIdentity(
          instanceName: map['instanceName'] as String? ?? 'Radarr',
          version: map['version'] as String?,
        );
      },
    );
  }

  Future<Result<List<RadarrMovie>>> getMovies() {
    return dioCall(
      () => _dio.get('api/v3/movie'),
      map: (data) {
        return jsonList(data, what: 'movies')
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'RadarrMovie parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  Future<Result<RadarrMovie>> getMovie(int id) {
    return dioCall(
      () => _dio.get('api/v3/movie/$id'),
      map: (data) => RadarrMovie.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<List<RadarrMovie>>> lookupMovie(String term) {
    return dioCall(
      () => _dio.get('api/v3/movie/lookup', queryParameters: {'term': term}),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'RadarrMovie lookup parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  /// Interactive search: query every indexer for releases matching
  /// [movieId]. Slow — uses a 90s receive timeout instead of the default.
  Future<Result<List<RadarrRelease>>> searchMovieReleases(int movieId) {
    return dioCall(
      () => _dio.get(
        'api/v3/release',
        queryParameters: {'movieId': movieId},
        options: Options(receiveTimeout: const Duration(seconds: 90)),
      ),
      map: (data) {
        if (data is! List) return <RadarrRelease>[];
        return data
            .map((json) {
              try {
                return RadarrRelease.fromJson(json as Map<String, dynamic>);
              } catch (e, st) {
                developer.log(
                  'RadarrRelease parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrRelease>()
            .toList();
      },
    );
  }

  /// Send a chosen release to the download client.
  Future<Result<void>> grabRelease({
    required String guid,
    required int indexerId,
  }) {
    return dioCall(
      () => _dio.post(
        'api/v3/release',
        data: {'guid': guid, 'indexerId': indexerId},
      ),
      map: (_) {},
    );
  }

  Future<Result<RadarrMovie>> addMovie(RadarrMovie movie) {
    final payload = movie.toJson();
    // Radarr v3 often fails if 'id' is present (even as null/0) during POST
    payload.remove('id');

    return dioCall(
      () => _dio.post('api/v3/movie', data: payload),
      map: (data) => RadarrMovie.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> updateMovie(RadarrMovie movie) {
    return dioCall(
      () => _dio.put('api/v3/movie/${movie.id}', data: movie.toJson()),
      map: (_) {},
    );
  }

  Future<Result<void>> deleteMovie(int id, {bool deleteFiles = false}) {
    return dioCall(
      () => _dio.delete(
        'api/v3/movie/$id',
        queryParameters: {'deleteFiles': deleteFiles},
      ),
      map: (_) {},
    );
  }

  /// Movies with a release date between [start] and [end]. Radarr returns full
  /// movie objects, so the calendar reuses [RadarrMovie] (with its release-date
  /// and studio fields) directly.
  Future<Result<List<RadarrMovie>>> getCalendar(DateTime start, DateTime end) {
    return dioCall(
      () => _dio.get(
        'api/v3/calendar',
        queryParameters: {
          'start': start.toUtc().toIso8601String(),
          'end': end.toUtc().toIso8601String(),
        },
      ),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'RadarrMovie calendar parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  Future<Result<List<RadarrQualityProfile>>> getQualityProfiles() {
    return dioCall(
      () => _dio.get('api/v3/qualityProfile'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(RadarrQualityProfile.fromJson)
          .toList(),
    );
  }

  Future<Result<List<RadarrRootFolder>>> getRootFolders() {
    return dioCall(
      () => _dio.get('api/v3/rootFolder'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(RadarrRootFolder.fromJson)
          .toList(),
    );
  }

  Future<Result<List<RadarrQueueItem>>> getQueue() {
    return dioCall(
      // The endpoint pages at 10 by default; a queue past that would hide
      // items from both the Library queue and torrent matching.
      () => _dio.get('api/v3/queue', queryParameters: {'pageSize': 1000}),
      map: (data) {
        if (data is! Map) return [];
        final records = data['records'];
        if (records is! List) return [];
        return records
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrQueueItem.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'RadarrQueueItem parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrQueueItem>()
            .toList();
      },
    );
  }

  /// Removes one queue item. [blocklist] adds its release to the blocklist
  /// so Radarr never grabs it again; [removeFromClient] also removes the
  /// download (and its files) from the download client. Radarr searches for a
  /// replacement unless `skipRedownload` is set, which it isn't here.
  Future<Result<void>> deleteQueueItem(
    int id, {
    bool removeFromClient = false,
    bool blocklist = false,
  }) {
    return dioCall(
      () => _dio.delete(
        'api/v3/queue/$id',
        queryParameters: {
          'removeFromClient': removeFromClient,
          'blocklist': blocklist,
        },
      ),
      map: (_) {},
    );
  }

  /// Triggers an automatic search for the given movies (spec 2d "Search
  /// all" on the Missing section).
  Future<Result<void>> searchMovies(List<int> movieIds) {
    return dioCall(
      () => _dio.post(
        'api/v3/command',
        data: {'name': 'MoviesSearch', 'movieIds': movieIds},
      ),
      map: (_) {},
    );
  }

  /// One page of Radarr's history, newest first. `includeMovie` embeds the
  /// movie so a row can show its title without a second round-trip.
  Future<Result<List<RadarrHistoryRecord>>> getHistory({
    int page = 1,
    int pageSize = 50,
  }) async => (await getHistoryPage(
    page: page,
    pageSize: pageSize,
  )).map((history) => history.records);

  /// [getHistory] with the page's paging facts. Page with this: a page's
  /// parsed records can be fewer than it held, so their count can't say
  /// whether another page exists.
  Future<Result<HistoryPage<RadarrHistoryRecord>>> getHistoryPage({
    int page = 1,
    int pageSize = 50,
  }) {
    return dioCall(
      () => _dio.get(
        'api/v3/history',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      ),
      map: _parseHistoryPage,
    );
  }

  /// Every history event after [since] (unpaged, a plain list). Used by
  /// background polling to find what's new since the last check.
  Future<Result<List<RadarrHistoryRecord>>> getHistorySince(DateTime since) {
    return dioCall(
      () => _dio.get(
        'api/v3/history/since',
        queryParameters: {
          'date': since.toUtc().toIso8601String(),
          'includeMovie': true,
        },
      ),
      map: _parseHistory,
    );
  }

  /// A paged `records` envelope or a plain list; bad records are skipped.
  HistoryPage<RadarrHistoryRecord> _parseHistoryPage(dynamic data) {
    final records = jsonList(data, what: 'history', envelopeKey: 'records');
    final total = data is Map ? data['totalRecords'] : null;
    return HistoryPage(
      records: _parseRecords(records),
      received: records.length,
      totalRecords: total is int ? total : null,
    );
  }

  List<RadarrHistoryRecord> _parseHistory(dynamic data) =>
      _parseRecords(jsonList(data, what: 'history', envelopeKey: 'records'));

  /// Drops a record that doesn't parse rather than failing its page.
  List<RadarrHistoryRecord> _parseRecords(List<Map<String, dynamic>> records) {
    final parsed = <RadarrHistoryRecord>[];
    for (final json in records) {
      try {
        parsed.add(RadarrHistoryRecord.fromJson(json));
      } catch (e, st) {
        developer.log(
          'RadarrHistoryRecord parse error: $e',
          name: 'arrstack.radarr',
          error: e,
          stackTrace: st,
        );
      }
    }
    return parsed;
  }
}
