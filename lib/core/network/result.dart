/// A success/failure wrapper so repositories never throw across layers
/// (spec §5). Every fallible operation in `core`/`services` returns a
/// `Result<T>` instead of throwing.
library;

import 'package:arrstack/core/network/app_error.dart';

/// The outcome of a fallible operation: either [Ok] with a value, or [Err]
/// with an [AppError]. Exhaustively matched via `switch`.
sealed class Result<T> {
  const Result();

  /// True when this is [Ok].
  bool get isOk => this is Ok<T>;

  /// True when this is [Err].
  bool get isErr => this is Err<T>;

  /// The success value, or null if this is [Err].
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  /// The error, or null if this is [Ok].
  AppError? get errorOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final error) => error,
  };

  /// Exhaustive pattern-match helper.
  R when<R>({
    required R Function(T value) ok,
    required R Function(AppError error) err,
  }) => switch (this) {
    Ok<T>(:final value) => ok(value),
    Err<T>(:final error) => err(error),
  };

  /// Transforms the success value; passes an [Err] through unchanged.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T>(:final value) => Ok<R>(transform(value)),
    Err<T>(:final error) => Err<R>(error),
  };

  /// Transforms the error; passes an [Ok] through unchanged.
  Result<T> mapError(AppError Function(AppError error) transform) =>
      switch (this) {
        Ok<T>(:final value) => Ok<T>(value),
        Err<T>(:final error) => Err<T>(transform(error)),
      };
}

/// A successful [Result] carrying [value].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok<T>, value);

  @override
  String toString() => 'Ok<$T>($value)';
}

/// A failed [Result] carrying an [AppError].
final class Err<T> extends Result<T> {
  const Err(this.error);

  final AppError error;

  @override
  bool operator ==(Object other) => other is Err<T> && other.error == error;

  @override
  int get hashCode => Object.hash(Err<T>, error);

  @override
  String toString() => 'Err<$T>($error)';
}
