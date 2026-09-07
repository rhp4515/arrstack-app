/// Bridges `dio`'s exception-based API to the app's [Result]-based one
/// (spec §5): repositories call [guardDioCall] instead of catching
/// `DioException` themselves.
library;

import 'dart:developer' as developer;

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
    final error = mapped is AppError ? mapped : mapDioException(exception);
    developer.log(
      'DioCall request failed [${exception.requestOptions.method} ${exception.requestOptions.uri}]: ${error.userMessage}',
      name: 'arrstack.network',
      error: exception,
    );
    return Err(error);
  } on FormatException catch (exception, st) {
    developer.log(
      'DioCall format error: $exception',
      name: 'arrstack.network',
      error: exception,
      stackTrace: st,
    );
    return Err(
      ValidationError(
        cause: exception,
        userMessage: 'Received an unexpected response from the server.',
      ),
    );
  } catch (exception, st) {
    developer.log(
      'DioCall unexpected error: $exception',
      name: 'arrstack.network',
      error: exception,
      stackTrace: st,
    );
    return Err(
      ValidationError(
        cause: exception,
        userMessage: 'Unexpected processing error occurred.',
      ),
    );
  }
}

/// A convenience wrapper around [guardDioCall] that handles [Response] data
/// mapping safely, capturing any mapping/deserialization exceptions.
Future<Result<T>> dioCall<T>(
  Future<Response<dynamic>> Function() call, {
  required T Function(dynamic data) map,
}) async {
  final result = await guardDioCall(call);
  return result.flatMap((response) {
    try {
      return Ok(map(response.data));
    } catch (e, st) {
      developer.log(
        'dioCall response mapping error [${response.requestOptions.method} ${response.requestOptions.uri}]: $e',
        name: 'arrstack.network',
        error: e,
        stackTrace: st,
      );
      return Err(
        ValidationError(
          cause: e,
          userMessage: 'Failed to parse response data: $e',
        ),
      );
    }
  });
}
