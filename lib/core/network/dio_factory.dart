/// Builds [Dio] instances with explicit timeouts and the standard
/// interceptor stack. Never used to hand-derive a `baseUrl` — callers must
/// resolve it via [EndpointResolver] first (spec §6a, §11).
library;

import 'package:arrstack/core/network/api_key_interceptor.dart';
import 'package:arrstack/core/network/error_mapping_interceptor.dart';
import 'package:arrstack/core/network/redacting_log_interceptor.dart';
import 'package:dio/dio.dart';

/// Creates [Dio] instances with sane, explicit (never default) timeouts
/// and the app's standard interceptor stack.
class DioFactory {
  const DioFactory({
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 20),
  });

  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  /// Builds a [Dio] for [baseUrl] (already resolved by [EndpointResolver]).
  ///
  /// [apiKeyInterceptor] should be omitted for `usernamePassword`-auth
  /// services, which manage their own session (cookie/socket) instead.
  Dio create({
    required String baseUrl,
    ApiKeyInterceptor? apiKeyInterceptor,
    List<Interceptor> extraInterceptors = const [],
    LogSink? logger,
  }) {
    // Ensure baseUrl ends with a slash for relative paths to work correctly.
    final normalizedBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

    final dio = Dio(
      BaseOptions(
        baseUrl: normalizedBaseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.addAll([
      ?apiKeyInterceptor,
      const ErrorMappingInterceptor(),
      RedactingLogInterceptor(logger: logger),
      ...extraInterceptors,
    ]);
    return dio;
  }
}
