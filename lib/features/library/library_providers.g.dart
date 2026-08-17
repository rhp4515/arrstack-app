// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

@ProviderFor(SelectedLibraryInstanceId)
final selectedLibraryInstanceIdProvider = SelectedLibraryInstanceIdFamily._();

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.
final class SelectedLibraryInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedLibraryInstanceId, String?> {
  /// The currently selected instance ID for the Library view.
  /// Defaults to the first Radarr instance marked as default, or just the first.
  SelectedLibraryInstanceIdProvider._({
    required SelectedLibraryInstanceIdFamily super.from,
    required ServiceType super.argument,
  }) : super(
         retry: null,
         name: r'selectedLibraryInstanceIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedLibraryInstanceIdHash();

  @override
  String toString() {
    return r'selectedLibraryInstanceIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedLibraryInstanceId create() => SelectedLibraryInstanceId();

  @override
  bool operator ==(Object other) {
    return other is SelectedLibraryInstanceIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedLibraryInstanceIdHash() =>
    r'9dd391d3c02cea9a1e329e1b3e1358020f634191';

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

final class SelectedLibraryInstanceIdFamily extends $Family
    with
        $ClassFamilyOverride<
          SelectedLibraryInstanceId,
          AsyncValue<String?>,
          String?,
          FutureOr<String?>,
          ServiceType
        > {
  SelectedLibraryInstanceIdFamily._()
    : super(
        retry: null,
        name: r'selectedLibraryInstanceIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The currently selected instance ID for the Library view.
  /// Defaults to the first Radarr instance marked as default, or just the first.

  SelectedLibraryInstanceIdProvider call(ServiceType type) =>
      SelectedLibraryInstanceIdProvider._(argument: type, from: this);

  @override
  String toString() => r'selectedLibraryInstanceIdProvider';
}

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

abstract class _$SelectedLibraryInstanceId extends $AsyncNotifier<String?> {
  late final _$args = ref.$arg as ServiceType;
  ServiceType get type => _$args;

  FutureOr<String?> build(ServiceType type);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
