/// Covers the whole app with a lock screen while the app lock is on and the
/// user hasn't authenticated yet (on launch, and after returning from the
/// background for longer than [appLockGracePeriod]). The app underneath
/// stays mounted, so unlocking returns to exactly where the user was.
library;

import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/security/app_lock_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, this.clock, super.key});

  final Widget child;

  /// Injected by tests to control the background grace period.
  final DateTime Function()? clock;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _locked = false;
  bool _decided = false;
  bool _authenticating = false;
  DateTime? _backgroundedAt;

  DateTime _now() => (widget.clock ?? DateTime.now)();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The biometric prompt itself backgrounds the app on some devices;
    // that trip must not re-lock it.
    if (_authenticating) return;
    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _backgroundedAt ??= _now();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        final enabled = ref.read(appLockEnabledProvider).value ?? false;
        if (enabled &&
            !_locked &&
            since != null &&
            _now().difference(since) >= appLockGracePeriod) {
          setState(() => _locked = true);
          _unlock();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    _authenticating = true;
    try {
      final ok = await ref
          .read(deviceAuthenticatorProvider)
          .authenticate('Unlock ArrStack Companion');
      if (ok && mounted) setState(() => _locked = false);
    } finally {
      _authenticating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabledAsync = ref.watch(appLockEnabledProvider);
    ref.listen(appLockEnabledProvider, (previous, next) {
      // Turning the lock off (from Settings, already authenticated) drops
      // any pending lock; turning it on doesn't lock the current session —
      // the user just proved who they are.
      if (next.value == false && _locked) setState(() => _locked = false);
    });

    // An unreadable setting counts as "off": locking the user out of the
    // app over a storage hiccup would be worse.
    if (!_decided && (enabledAsync.hasValue || enabledAsync.hasError)) {
      _decided = true;
      if (enabledAsync.value ?? false) {
        _locked = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
      }
    }

    // Until the setting has loaded, don't flash the app's content.
    final covered = _locked || (!_decided && enabledAsync.isLoading);
    return Stack(
      children: [
        ExcludeSemantics(excluding: covered, child: widget.child),
        if (covered)
          Positioned.fill(
            child: _decided
                ? _LockScreen(onUnlock: _unlock)
                : ColoredBox(color: Theme.of(context).colorScheme.surface),
          ),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: EmptyState(
          icon: PhosphorIconsRegular.lockSimple,
          title: 'ArrStack is locked',
          message: 'Unlock with your fingerprint, face, or device PIN.',
          action: FilledButton.icon(
            onPressed: onUnlock,
            icon: const Icon(PhosphorIconsRegular.lockSimpleOpen, size: 17),
            label: const Text('Unlock'),
          ),
        ),
      ),
    );
  }
}
