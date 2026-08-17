// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InstanceForm)
final instanceFormProvider = InstanceFormProvider._();

final class InstanceFormProvider
    extends $NotifierProvider<InstanceForm, InstanceFormState> {
  InstanceFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instanceFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instanceFormHash();

  @$internal
  @override
  InstanceForm create() => InstanceForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstanceFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstanceFormState>(value),
    );
  }
}

String _$instanceFormHash() => r'7b36d3183172b36fcb712682d3844f63d772c8f0';

abstract class _$InstanceForm extends $Notifier<InstanceFormState> {
  InstanceFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InstanceFormState, InstanceFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InstanceFormState, InstanceFormState>,
              InstanceFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
