/// Bridges `dio`'s exception-based API to the app's [Result]-based one
/// (spec §5): repositories call [guardDioCall] instead of catching
/// `DioException` themselves.
library;

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/dio_exception_mapper.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:dio/dio.dart';

/// Runs [call] and converts any [DioException]/[FormatException] into an
/// [Err]. Never lets a `dio` exception escape to the caller.
Future<Result<T>> guardDioCall<T>(Future<T> Function() call) async {
  try {
    return Ok(await call());
  } on DioException catch (exception) {
    final mapped = exception.error;
    return Err(mapped is AppError ? mapped : mapDioException(exception));
  } on FormatException catch (exception) {
    return Err(
      ValidationError(
        cause: exception,
        userMessage: 'Received an unexpected response from the server.',
      ),
    );
  }
}

/// A convenience wrapper around [guardDioCall] that handles [Response] data
/// mapping.
Future<Result<T>> dioCall<T>(
  Future<Response<dynamic>> Function() call, {
  required T Function(dynamic data) map,
}) async {
  final result = await guardDioCall(call);
  return result.map((response) => map(response.data));
}
