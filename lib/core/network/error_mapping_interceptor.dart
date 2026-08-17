/// Dio interceptor that pre-computes the [AppError] for every failed
/// request and attaches it to `DioException.error`, so callers using
/// [guardDioCall] (or catching `DioException` directly) get a consistent
/// mapping without re-deriving it (spec §5).
library;

import 'package:arrstack/core/network/dio_exception_mapper.dart';
import 'package:dio/dio.dart';

/// Attaches a mapped [AppError] to every [DioException] that passes
/// through this Dio instance.
class ErrorMappingInterceptor extends Interceptor {
  const ErrorMappingInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: mapDioException(err)));
  }
}
