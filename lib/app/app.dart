/// Root app widget: wires theme + router together.
library;

import 'package:arrstack/app/router.dart';
import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArrStackApp extends ConsumerWidget {
  const ArrStackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: 'ArrStack Companion',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
