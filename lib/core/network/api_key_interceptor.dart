/// Injects the `X-Api-Key` header for apiKey-auth services (spec §6, §11).
/// The key itself is never hardcoded — it's looked up from `SecureStore`
/// via the injected [lookupApiKey] callback each request, so a rotated key
/// takes effect without rebuilding the Dio instance.
library;

import 'package:dio/dio.dart';

/// Resolves the current API key for a service instance, or null if none is
/// stored yet.
typedef ApiKeyLookup = Future<String?> Function();

/// Adds `X-Api-Key: <key>` to every outgoing request, sourcing the key from
/// [lookupApiKey]. No-ops (adds no header) when the lookup returns null or
/// empty — the request then fails auth downstream, mapped to [AuthError].
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor({required this.lookupApiKey});

  final ApiKeyLookup lookupApiKey;

  static const String headerName = 'X-Api-Key';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await lookupApiKey();
    if (apiKey != null && apiKey.isNotEmpty) {
      options.headers[headerName] = apiKey;
    }
    handler.next(options);
  }
}
