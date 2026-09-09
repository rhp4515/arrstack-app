// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einthusan_import_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress.

@ProviderFor(EinthusanImportController)
final einthusanImportControllerProvider = EinthusanImportControllerFamily._();

/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress.
final class EinthusanImportControllerProvider
    extends $NotifierProvider<EinthusanImportController, EinthusanImportState> {
  /// Drives the Einthusan import flow for one instance: submit URL, confirm
  /// TMDB match, poll download/import progress.
  EinthusanImportControllerProvider._({
    required EinthusanImportControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'einthusanImportControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$einthusanImportControllerHash();

  @override
  String toString() {
    return r'einthusanImportControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EinthusanImportController create() => EinthusanImportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EinthusanImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EinthusanImportState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EinthusanImportControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$einthusanImportControllerHash() =>
    r'0fef4a5fdc569000835c11efaf51aea350167174';

/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress.

final class EinthusanImportControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EinthusanImportController,
          EinthusanImportState,
          EinthusanImportState,
          EinthusanImportState,
          String
        > {
  EinthusanImportControllerFamily._()
    : super(
        retry: null,
        name: r'einthusanImportControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives the Einthusan import flow for one instance: submit URL, confirm
  /// TMDB match, poll download/import progress.

  EinthusanImportControllerProvider call(String instanceId) =>
      EinthusanImportControllerProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'einthusanImportControllerProvider';
}

/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress.

abstract class _$EinthusanImportController
    extends $Notifier<EinthusanImportState> {
  late final _$args = ref.$arg as String;
  String get instanceId => _$args;

  EinthusanImportState build(String instanceId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EinthusanImportState, EinthusanImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EinthusanImportState, EinthusanImportState>,
              EinthusanImportState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
