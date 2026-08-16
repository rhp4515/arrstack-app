/// Riverpod-managed [ThemeMode] selection (System / Light / Dark).
///
/// This is the app's first `@riverpod` provider, proving the `build_runner`
/// codegen pipeline. Persisting the choice to `ConfigStore` is Phase 2+;
/// for now it just holds in-memory state defaulting to system theme.
library;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() => ThemeMode.system;

  void update(ThemeMode mode) => state = mode;
}
