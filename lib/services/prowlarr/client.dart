import 'dart:developer' as developer;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/prowlarr/models/indexer.dart';
import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';
import 'package:dio/dio.dart';

class ProwlarrClient {
  const ProwlarrClient(this._dio);

  final Dio _dio;

  Future<Result<List<Indexer>>> getIndexers() {
    return dioCall(
      () => _dio.get('api/v1/indexer'),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return Indexer.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'Indexer parse error: $e',
                  name: 'arrstack.prowlarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<Indexer>()
            .toList();
      },
    );
  }

  Future<Result<IndexerStatsResponse>> getIndexerStats({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = <String, dynamic>{};
    if (startDate != null) query['startDate'] = _isoDateTime(startDate);
    if (endDate != null) query['endDate'] = _isoDateTime(endDate);

    return dioCall(
      () => _dio.get('api/v1/indexerstats', queryParameters: query),
      map: (data) =>
          IndexerStatsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  static String _isoDateTime(DateTime date) => date.toUtc().toIso8601String();
}
