// Result<T> sealed-class behavior: map, mapError, when, isOk/isErr, and the
// value/error accessors.

import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ok', () {
    test('isOk is true and isErr is false', () {
      const result = Ok<int>(1);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('valueOrNull returns the value; errorOrNull is null', () {
      const result = Ok<int>(42);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('map transforms the value', () {
      const result = Ok<int>(2);
      final mapped = result.map((value) => value * 10);
      expect(mapped.valueOrNull, 20);
    });

    test('mapError leaves an Ok result unchanged', () {
      const result = Ok<int>(2);
      final mapped = result.mapError(
        (error) => const UnknownError(userMessage: 'nope'),
      );
      expect(mapped.valueOrNull, 2);
    });

    test('when calls the ok branch', () {
      const result = Ok<int>(5);
      final output = result.when(
        ok: (value) => 'ok:$value',
        err: (error) => 'err',
      );
      expect(output, 'ok:5');
    });
  });

  group('Err', () {
    const error = ValidationError(userMessage: 'bad input');

    test('isErr is true and isOk is false', () {
      const result = Err<int>(error);
      expect(result.isErr, isTrue);
      expect(result.isOk, isFalse);
    });

    test('errorOrNull returns the error; valueOrNull is null', () {
      const result = Err<int>(error);
      expect(result.errorOrNull, error);
      expect(result.valueOrNull, isNull);
    });

    test('map leaves an Err result unchanged', () {
      const result = Err<int>(error);
      final mapped = result.map((value) => value * 10);
      expect(mapped.errorOrNull, error);
    });

    test('mapError transforms the error', () {
      const result = Err<int>(error);
      final mapped = result.mapError(
        (e) => UnknownError(userMessage: 'wrapped: ${e.userMessage}'),
      );
      expect(mapped.errorOrNull?.userMessage, 'wrapped: bad input');
    });

    test('when calls the err branch', () {
      const result = Err<int>(error);
      final output = result.when(
        ok: (value) => 'ok',
        err: (e) => 'err:${e.userMessage}',
      );
      expect(output, 'err:bad input');
    });
  });
}
