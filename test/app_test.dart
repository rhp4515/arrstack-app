// Smoke test: the app boots to the empty dashboard, and bottom-nav tabs
// switch pages.

import 'package:arrstack/app/app.dart';
import 'package:arrstack/app/router.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/dashboard/dashboard_page.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/storage/fakes.dart';

class FakeSsidSource implements SsidSource {
  @override
  Future<String?> currentSsid() async => 'Home-WiFi';

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<PermissionStatus> permissionStatus() async => PermissionStatus.granted;
}

void main() {
  testWidgets('boots to the empty dashboard state', (tester) async {
    final configStore = FakeConfigStore();
    final secureStore = FakeSecureStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(configStore),
          secureStoreProvider.overrideWithValue(secureStore),
          ssidSourceProvider.overrideWithValue(FakeSsidSource()),
        ],
        child: const ArrStackApp(),
      ),
    );
    await tester.pumpAndSettle();
    
    // Explicitly navigate to dashboard if needed
    appRouter.go('/dashboard');
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
  });

  testWidgets('tapping a bottom-nav tab switches pages', (tester) async {
    final configStore = FakeConfigStore();
    final secureStore = FakeSecureStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(configStore),
          secureStoreProvider.overrideWithValue(secureStore),
          ssidSourceProvider.overrideWithValue(FakeSsidSource()),
        ],
        child: const ArrStackApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DashboardPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('INSTANCES'), findsOneWidget);
  });
}
