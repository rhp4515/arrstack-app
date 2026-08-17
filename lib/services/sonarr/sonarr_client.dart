/// API client for Sonarr (v3).
///
/// Implements the endpoints needed for series management and lookup.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:dio/dio.dart';

class SonarrClient implements ConnectionTestClient {
  const SonarrClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/v3/system/status'),
      map: (data) {
        final map = data as Map<String, dynamic>;
        return ServiceIdentity(
          instanceName: map['instanceName'] as String? ?? 'Sonarr',
          version: map['version'] as String?,
        );
      },
    );
  }

  Future<Result<List<SonarrSeries>>> getSeries() {
    return dioCall(
      () => _dio.get('api/v3/series'),
      map: (data) {
        if (data is! List) {
          // ignore: avoid_print
          print('Sonarr getSeries: expected List but got ${data.runtimeType}');
          return [];
        }
        // ignore: avoid_print
        print('Sonarr getSeries: received ${data.length} items');
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return SonarrSeries.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('SonarrSeries parse error for "${json['title']}": $e');
                return null;
              }
            })
            .whereType<SonarrSeries>()
            .toList();
      },
    );
  }

  Future<Result<SonarrSeries>> getSeriesById(int id) {
    return dioCall(
      () => _dio.get('api/v3/series/$id'),
      map: (data) => SonarrSeries.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<List<SonarrSeries>>> lookupSeries(String term) {
    return dioCall(
      () => _dio.get('api/v3/series/lookup', queryParameters: {'term': term}),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return SonarrSeries.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('SonarrSeries lookup parse error: $e');
                return null;
              }
            })
            .whereType<SonarrSeries>()
            .toList();
      },
    );
  }

  Future<Result<SonarrSeries>> addSeries(SonarrSeries series) {
    return dioCall(
      () => _dio.post('api/v3/series', data: series.toJson()),
      map: (data) => SonarrSeries.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> updateSeries(SonarrSeries series) {
    return dioCall(
      () => _dio.put('api/v3/series/${series.id}', data: series.toJson()),
      map: (_) {},
    );
  }

  Future<Result<void>> deleteSeries(int id, {bool deleteFiles = false}) {
    return dioCall(
      () => _dio.delete(
        'api/v3/series/$id',
        queryParameters: {'deleteFiles': deleteFiles},
      ),
      map: (_) {},
    );
  }

  Future<Result<List<SonarrEpisode>>> getEpisodes(int seriesId) {
    return dioCall(
      () => _dio.get('api/v3/episode', queryParameters: {'seriesId': seriesId}),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(SonarrEpisode.fromJson)
          .toList(),
    );
  }

  Future<Result<List<SonarrQualityProfile>>> getQualityProfiles() {
    return dioCall(
      () => _dio.get('api/v3/qualityProfile'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(SonarrQualityProfile.fromJson)
          .toList(),
    );
  }

  Future<Result<List<SonarrRootFolder>>> getRootFolders() {
    return dioCall(
      () => _dio.get('api/v3/rootFolder'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(SonarrRootFolder.fromJson)
          .toList(),
    );
  }

  Future<Result<List<SonarrQueueItem>>> getQueue() {
    return dioCall(
      () => _dio.get('api/v3/queue'),
      map: (data) {
        if (data is! Map) return [];
        final records = data['records'];
        if (records is! List) return [];
        return records
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return SonarrQueueItem.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('SonarrQueueItem parse error: $e');
                return null;
              }
            })
            .whereType<SonarrQueueItem>()
            .toList();
      },
    );
  }
}
