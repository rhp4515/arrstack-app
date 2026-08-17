/// The closed set of failures the app can surface, produced by mapping
/// `DioException`s (see `dio_exception_mapper.dart`) or raised directly by
/// validation code. Every variant carries a user-friendly [userMessage]
/// that never leaks secrets (keys, tokens, credentials).
library;

/// Base type for every recoverable failure in the app. Exhaustively matched
/// via `switch` — never thrown across layers (spec §5).
sealed class AppError {
  const AppError({required this.userMessage, this.cause, this.statusCode});

  /// Friendly, UI-safe message. Never includes a key/token/URL secret.
  final String userMessage;

  /// The underlying exception/error, if any, for logging/diagnostics only.
  final Object? cause;

  /// The HTTP status code, if this error originated from a response.
  final int? statusCode;

  @override
  String toString() => '$runtimeType(${statusCode ?? ''} $userMessage)';
}

/// Could not reach the server at all, or the request timed out.
final class NetworkError extends AppError {
  const NetworkError({
    this.isTimeout = false,
    super.cause,
    super.userMessage =
        'Could not reach the server. Check the URL and your connection.',
  });

  /// True when this was specifically a connect/send/receive timeout.
  final bool isTimeout;
}

/// The server rejected the request as unauthenticated/unauthorized
/// (401/403) — usually a missing or wrong API key / credentials.
final class AuthError extends AppError {
  const AuthError({
    super.statusCode,
    super.cause,
    super.userMessage =
        'Authentication failed. Check the API key or '
        'credentials for this instance.',
  });
}

/// The server responded 404 for the requested resource/endpoint.
final class NotFoundError extends AppError {
  const NotFoundError({
    super.cause,
    super.userMessage = 'That was not found on the server.',
  }) : super(statusCode: 404);
}

/// The server responded 429; the caller is being rate-limited.
final class RateLimitedError extends AppError {
  const RateLimitedError({
    this.retryAfter,
    super.cause,
    super.userMessage = 'Too many requests — please slow down and retry.',
  }) : super(statusCode: 429);

  /// Parsed `Retry-After` value, if the server sent one.
  final Duration? retryAfter;
}

/// The server responded with a 5xx error.
final class ServerError extends AppError {
  const ServerError({
    super.statusCode,
    super.cause,
    super.userMessage = 'The server ran into a problem. Try again shortly.',
  });
}

/// A request or response failed local validation/parsing — e.g. an
/// unparseable URL, a malformed instance, or an unexpected JSON shape.
final class ValidationError extends AppError {
  const ValidationError({
    this.field,
    super.cause,
    super.userMessage = 'That value is not valid.',
  });

  /// The offending field name, if known.
  final String? field;
}

/// A failure to read or write to local storage (Keychain, preferences).
final class StorageError extends AppError {
  const StorageError({
    super.cause,
    super.userMessage = 'Failed to access local storage.',
  });
}

/// Anything that doesn't fit the categories above.
final class UnknownError extends AppError {
  const UnknownError({
    super.statusCode,
    super.cause,
    super.userMessage = 'Something went wrong. Please try again.',
  });
}
