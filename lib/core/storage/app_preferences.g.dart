// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPreferences)
final appPreferencesProvider = AppPreferencesProvider._();

final class AppPreferencesProvider
    extends $FunctionalProvider<AppPreferences, AppPreferences, AppPreferences>
    with $Provider<AppPreferences> {
  AppPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesHash();

  @$internal
  @override
  $ProviderElement<AppPreferences> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppPreferences create(Ref ref) {
    return appPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferences>(value),
    );
  }
}

String _$appPreferencesHash() => r'd1b7c0a50f95eb8a6ef62bc16272bee525ed4046';
