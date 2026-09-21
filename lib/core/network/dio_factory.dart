/// Builds [Dio] instances with explicit timeouts and the standard
/// interceptor stack. Never used to hand-derive a `baseUrl` — callers must
/// resolve it via [EndpointResolver] first (spec §6a, §11).
library;

import 'package:arrstack/core/network/api_key_interceptor.dart';
import 'package:arrstack/core/network/endpoint_resolver.dart';
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

  /// The profile used for a [ResolvedEndpoint.remote] base URL. A request
  /// over Tailscale can pay for the tunnel waking up before it even starts:
  /// on cellular the first connection after an idle period has to bring the
  /// link back up (and may fall back to a DERP relay) before the TCP
  /// handshake completes, which regularly outruns the 10s LAN budget. The
  /// LAN profile stays tight — a home-network service that cannot accept a
  /// socket within 10s is down, not slow.
  static const remote = DioFactory(
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
  );

  /// The profile used for a [ResolvedEndpoint.local] base URL.
  static const local = DioFactory();

  /// Picks the profile matching the endpoint a [Dio] will talk to.
  static DioFactory forEndpoint(ResolvedEndpoint endpoint) =>
      endpoint == ResolvedEndpoint.remote ? remote : local;

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
        headers: {'Accept': 'application/json'},
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
