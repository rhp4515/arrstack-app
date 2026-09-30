// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diagnosticLogStore)
final diagnosticLogStoreProvider = DiagnosticLogStoreProvider._();

final class DiagnosticLogStoreProvider
    extends
        $FunctionalProvider<
          DiagnosticLogStore,
          DiagnosticLogStore,
          DiagnosticLogStore
        >
    with $Provider<DiagnosticLogStore> {
  DiagnosticLogStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosticLogStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosticLogStoreHash();

  @$internal
  @override
  $ProviderElement<DiagnosticLogStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiagnosticLogStore create(Ref ref) {
    return diagnosticLogStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiagnosticLogStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiagnosticLogStore>(value),
    );
  }
}

String _$diagnosticLogStoreHash() =>
    r'4fabbd37e6c0a4819a27d28e5cfa0ef0cd4aa47c';

@ProviderFor(diagnosticLogger)
final diagnosticLoggerProvider = DiagnosticLoggerProvider._();

final class DiagnosticLoggerProvider
    extends
        $FunctionalProvider<
          DiagnosticLogger,
          DiagnosticLogger,
          DiagnosticLogger
        >
    with $Provider<DiagnosticLogger> {
  DiagnosticLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosticLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosticLoggerHash();

  @$internal
  @override
  $ProviderElement<DiagnosticLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiagnosticLogger create(Ref ref) {
    return diagnosticLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiagnosticLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiagnosticLogger>(value),
    );
  }
}

String _$diagnosticLoggerHash() => r'c36325fe26fcaeb47a5f0e0ac1a2c3bbedc97daa';

/// The stored entries, newest first; re-reads whenever the store changes.

@ProviderFor(diagnosticLogEntries)
final diagnosticLogEntriesProvider = DiagnosticLogEntriesProvider._();

/// The stored entries, newest first; re-reads whenever the store changes.

final class DiagnosticLogEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LogEntry>>,
          List<LogEntry>,
          Stream<List<LogEntry>>
        >
    with $FutureModifier<List<LogEntry>>, $StreamProvider<List<LogEntry>> {
  /// The stored entries, newest first; re-reads whenever the store changes.
  DiagnosticLogEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosticLogEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosticLogEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<LogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LogEntry>> create(Ref ref) {
    return diagnosticLogEntries(ref);
  }
}

String _$diagnosticLogEntriesHash() =>
    r'f4d490ccadbd82f708d548d8827829418184b66b';
