// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localNotifications)
final localNotificationsProvider = LocalNotificationsProvider._();

final class LocalNotificationsProvider
    extends $FunctionalProvider<LocalNotifier, LocalNotifier, LocalNotifier>
    with $Provider<LocalNotifier> {
  LocalNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationsHash();

  @$internal
  @override
  $ProviderElement<LocalNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalNotifier create(Ref ref) {
    return localNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalNotifier>(value),
    );
  }
}

String _$localNotificationsHash() =>
    r'34d84f5e57f0b5b65955d14ae1b534bced3d87db';

@ProviderFor(notificationScheduler)
final notificationSchedulerProvider = NotificationSchedulerProvider._();

final class NotificationSchedulerProvider
    extends
        $FunctionalProvider<
          NotificationScheduler,
          NotificationScheduler,
          NotificationScheduler
        >
    with $Provider<NotificationScheduler> {
  NotificationSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSchedulerHash();

  @$internal
  @override
  $ProviderElement<NotificationScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationScheduler create(Ref ref) {
    return notificationScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationScheduler>(value),
    );
  }
}

String _$notificationSchedulerHash() =>
    r'721ac6e7c45ec43297f494bf3ea9295fbc721edd';

/// Runs one check with the current settings. Used by the background
/// worker, by "Check now", and right after notifications are turned on (to
/// set every source's starting point, so the first background run only
/// reports what's new from then on). Kept alive because callers invoke the
/// returned function after reading it, when an auto-disposed provider's
/// ref could already be gone.

@ProviderFor(notificationCheckRunner)
final notificationCheckRunnerProvider = NotificationCheckRunnerProvider._();

/// Runs one check with the current settings. Used by the background
/// worker, by "Check now", and right after notifications are turned on (to
/// set every source's starting point, so the first background run only
/// reports what's new from then on). Kept alive because callers invoke the
/// returned function after reading it, when an auto-disposed provider's
/// ref could already be gone.

final class NotificationCheckRunnerProvider
    extends
        $FunctionalProvider<
          Future<int> Function(),
          Future<int> Function(),
          Future<int> Function()
        >
    with $Provider<Future<int> Function()> {
  /// Runs one check with the current settings. Used by the background
  /// worker, by "Check now", and right after notifications are turned on (to
  /// set every source's starting point, so the first background run only
  /// reports what's new from then on). Kept alive because callers invoke the
  /// returned function after reading it, when an auto-disposed provider's
  /// ref could already be gone.
  NotificationCheckRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCheckRunnerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCheckRunnerHash();

  @$internal
  @override
  $ProviderElement<Future<int> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<int> Function() create(Ref ref) {
    return notificationCheckRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<int> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<int> Function()>(value),
    );
  }
}

String _$notificationCheckRunnerHash() =>
    r'f2eab5ee6ce26d3b439c394fccc7af39b1a29864';

/// When the last check finished, for the settings page.

@ProviderFor(notificationLastRun)
final notificationLastRunProvider = NotificationLastRunProvider._();

/// When the last check finished, for the settings page.

final class NotificationLastRunProvider
    extends
        $FunctionalProvider<
          AsyncValue<DateTime?>,
          DateTime?,
          FutureOr<DateTime?>
        >
    with $FutureModifier<DateTime?>, $FutureProvider<DateTime?> {
  /// When the last check finished, for the settings page.
  NotificationLastRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationLastRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationLastRunHash();

  @$internal
  @override
  $FutureProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DateTime?> create(Ref ref) {
    return notificationLastRun(ref);
  }
}

String _$notificationLastRunHash() =>
    r'0fdbe66f8e34007b2e10201dcd8c395737c43d9e';

@ProviderFor(NotificationSettingsController)
final notificationSettingsControllerProvider =
    NotificationSettingsControllerProvider._();

final class NotificationSettingsControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationSettingsController,
          NotificationSettings
        > {
  NotificationSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsControllerHash();

  @$internal
  @override
  NotificationSettingsController create() => NotificationSettingsController();
}

String _$notificationSettingsControllerHash() =>
    r'e9b7c4d28f33f8aace6fa29e5baf1c2562fe58b2';

abstract class _$NotificationSettingsController
    extends $AsyncNotifier<NotificationSettings> {
  FutureOr<NotificationSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationSettings>, NotificationSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationSettings>,
                NotificationSettings
              >,
              AsyncValue<NotificationSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
