/// App lock (Settings → Advanced → Security): when on, the app asks for the
/// device's biometrics or screen-lock credential on launch and whenever it
/// returns from the background after [appLockGracePeriod].
library;

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock_providers.g.dart';

const String appLockPreferenceKey = 'security.appLock';

/// Short trips out of the app (the share sheet, the file picker, the
/// biometric prompt itself) don't re-lock it.
const Duration appLockGracePeriod = Duration(seconds: 30);

/// The platform's "prove you're the owner" prompt.
abstract interface class DeviceAuthenticator {
  /// Whether the device has biometrics or a screen lock that can be used.
  Future<bool> isAvailable();

  /// Shows the system prompt; true only on a successful authentication.
  Future<bool> authenticate(String reason);
}

class LocalAuthDeviceAuthenticator implements DeviceAuthenticator {
  LocalAuthDeviceAuthenticator([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      // persistAcrossBackgrounding: a prompt interrupted by the app going
      // to the background retries on return instead of failing.
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
DeviceAuthenticator deviceAuthenticator(Ref ref) =>
    LocalAuthDeviceAuthenticator();

/// Why turning the lock on didn't happen, for the Settings snackbar.
enum AppLockChangeResult { changed, unavailable, notAuthenticated }

@Riverpod(keepAlive: true)
class AppLockEnabled extends _$AppLockEnabled {
  @override
  Future<bool> build() async =>
      await ref.watch(appPreferencesProvider).readBool(appLockPreferenceKey) ??
      false;

  /// Turning the lock on or off both require authenticating first: on, to
  /// prove the device can actually unlock it (so nobody locks themselves
  /// out); off, so someone holding an unlocked phone can't just disable it.
  Future<AppLockChangeResult> setEnabled({required bool enabled}) async {
    final authenticator = ref.read(deviceAuthenticatorProvider);
    if (enabled && !await authenticator.isAvailable()) {
      return AppLockChangeResult.unavailable;
    }
    final reason = enabled
        ? 'Confirm to lock ArrStack Companion'
        : 'Confirm to turn off the app lock';
    if (!await authenticator.authenticate(reason)) {
      return AppLockChangeResult.notAuthenticated;
    }
    await ref
        .read(appPreferencesProvider)
        .writeBool(appLockPreferenceKey, value: enabled);
    state = AsyncData(enabled);
    return AppLockChangeResult.changed;
  }
}
