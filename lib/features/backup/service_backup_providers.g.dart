// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_backup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backupFileGateway)
final backupFileGatewayProvider = BackupFileGatewayProvider._();

final class BackupFileGatewayProvider
    extends
        $FunctionalProvider<
          BackupFileGateway,
          BackupFileGateway,
          BackupFileGateway
        >
    with $Provider<BackupFileGateway> {
  BackupFileGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupFileGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupFileGatewayHash();

  @$internal
  @override
  $ProviderElement<BackupFileGateway> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BackupFileGateway create(Ref ref) {
    return backupFileGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupFileGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupFileGateway>(value),
    );
  }
}

String _$backupFileGatewayHash() => r'f4587d0677ee432f85bcf8475386530d9d7fda08';

@ProviderFor(serviceBackupService)
final serviceBackupServiceProvider = ServiceBackupServiceProvider._();

final class ServiceBackupServiceProvider
    extends
        $FunctionalProvider<
          ServiceBackupService,
          ServiceBackupService,
          ServiceBackupService
        >
    with $Provider<ServiceBackupService> {
  ServiceBackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceBackupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceBackupServiceHash();

  @$internal
  @override
  $ProviderElement<ServiceBackupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServiceBackupService create(Ref ref) {
    return serviceBackupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceBackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceBackupService>(value),
    );
  }
}

String _$serviceBackupServiceHash() =>
    r'e85bcc81a45bf08ebe9aafbe0aa737e0541ca85d';

@ProviderFor(ServiceBackupController)
final serviceBackupControllerProvider = ServiceBackupControllerProvider._();

final class ServiceBackupControllerProvider
    extends $NotifierProvider<ServiceBackupController, BackupPageState> {
  ServiceBackupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceBackupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceBackupControllerHash();

  @$internal
  @override
  ServiceBackupController create() => ServiceBackupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupPageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupPageState>(value),
    );
  }
}

String _$serviceBackupControllerHash() =>
    r'2053e28949f68f02e68f28c04e9531d245bb01f5';

abstract class _$ServiceBackupController extends $Notifier<BackupPageState> {
  BackupPageState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BackupPageState, BackupPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BackupPageState, BackupPageState>,
              BackupPageState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
