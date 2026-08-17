/// Riverpod-managed [ThemeMode] selection (System / Light / Dark).
///
/// This is the app's first `@riverpod` provider, proving the `build_runner`
/// codegen pipeline. Persisting the choice to `ConfigStore` is Phase 2+;
/// for now it just holds in-memory state defaulting to system theme.
library;

import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final raw = await ref.read(configStoreProvider).readThemeMode();
    if (raw != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == raw,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> update(ThemeMode mode) async {
    state = mode;
    await ref.read(configStoreProvider).writeThemeMode(mode.name);
  }
}
