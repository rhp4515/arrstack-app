/// API client for qBittorrent (v2).
///
/// Handles cookie-based session management and torrent management endpoints.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:dio/dio.dart';

class QbitClient implements ConnectionTestClient {
  QbitClient(this._dio);

  final Dio _dio;
  String? _sid;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    // For qBittorrent, testConnection means verifying the current session
    // or attempting a login if none exists.
    // A lightweight call is /api/v2/app/version.
    return dioCall(
      () => _dio.get('api/v2/app/version'),
      map: (data) => ServiceIdentity(
        instanceName: 'qBittorrent',
        version: data as String?,
      ),
    );
  }

  Future<Result<void>> login(String username, String password) async {
    // qBittorrent's CSRF check requires the Referer to match the WebUI host.
    // We deliberately send *only* Referer: also sending an Origin that the
    // server considers cross-site is a documented cause of a 403 "Fails."
    // (qBittorrent#21106), and Referer alone satisfies the check.
    final referer = _dio.options.baseUrl.replaceAll(RegExp(r'/$'), '');
    final result = await guardDioCall(
      () => _dio.post(
        'api/v2/auth/login',
        data: {'username': username, 'password': password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Referer': referer},
        ),
      ),
    );

    return result.map((response) {
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        for (final cookie in cookies) {
          // The session cookie is `SID=` on qBittorrent < 5.2.0 and
          // `QBT_SID_<port>=` on 5.2.0+ (which also returns 204, not 200, on a
          // successful login). Capture either.
          final pair = cookie.split(';').first;
          final name = pair.split('=').first;
          if (name == 'SID' || name.startsWith('QBT_SID')) {
            _sid = pair;
            break;
          }
        }
      }
    });
  }

  Future<Result<List<QbitTorrent>>> getTorrents() {
    return dioCall(
      () => _dio.get('api/v2/torrents/info'),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return QbitTorrent.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('QbitTorrent parse error: $e');
                return null;
              }
            })
            .whereType<QbitTorrent>()
            .toList();
      },
    );
  }

  Future<Result<QbitMainData>> getMainData() {
    return dioCall(
      () => _dio.get('api/v2/sync/maindata'),
      map: (data) => QbitMainData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Stops (pauses) torrents. qBittorrent 5.0 hard-renamed this endpoint from
  /// `torrents/pause` to `torrents/stop` — the old path 404s on 5.0+.
  Future<Result<void>> stopTorrents(List<String> hashes) {
    return dioCall(
      () => _dio.post(
        'api/v2/torrents/stop',
        data: {'hashes': hashes.join('|')},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
      map: (_) {},
    );
  }

  /// Starts (resumes) torrents. Renamed from `torrents/resume` in qBittorrent
  /// 5.0 — see [stopTorrents].
  Future<Result<void>> startTorrents(List<String> hashes) {
    return dioCall(
      () => _dio.post(
        'api/v2/torrents/start',
        data: {'hashes': hashes.join('|')},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
      map: (_) {},
    );
  }

  Future<Result<void>> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) {
    // qBittorrent reads state-changing params from the POST body, not the
    // query string — sending them as queryParameters yields a 400 because
    // the server sees `hashes` as missing.
    return dioCall(
      () => _dio.post(
        'api/v2/torrents/delete',
        data: {'hashes': hashes.join('|'), 'deleteFiles': deleteFiles},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
      map: (_) {},
    );
  }

  Future<Result<void>> addTorrent(String url) {
    return dioCall(
      () => _dio.post(
        'api/v2/torrents/add',
        data: {'urls': url},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
      map: (_) {},
    );
  }

  /// Injects the SID cookie if we have one.
  Interceptor get cookieInterceptor => InterceptorsWrapper(
    onRequest: (options, handler) {
      if (_sid != null) {
        options.headers['Cookie'] = _sid;
      }
      handler.next(options);
    },
  );

  /// Injects `Authorization: Bearer <key>` for qBittorrent 5.2.0+ API-key auth.
  /// API keys are stateless and bypass the cookie/`login` flow entirely, so a
  /// client using this never needs to call [login].
  static Interceptor bearerInterceptor(String apiKey) => InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer $apiKey';
      handler.next(options);
    },
  );
}
