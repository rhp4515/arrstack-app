// Smoke test: the app boots to Home, and the 3 bottom-nav tabs switch pages.

import 'package:arrstack/app/app.dart';
import 'package:arrstack/app/router.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/calendar/calendar_page.dart';
import 'package:arrstack/features/downloads/downloads_page.dart';
import 'package:arrstack/features/home/home_page.dart';
import 'package:arrstack/features/library/library_page.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

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
  Future<void> pumpApp(WidgetTester tester) async {
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
  }

  testWidgets('boots to the empty Home state', (tester) async {
    await pumpApp(tester);

    appRouter.go('/home');
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('tapping Library and Activity tabs switches pages', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryPage), findsOneWidget);

    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadsPage), findsOneWidget);
  });

  testWidgets('tapping the Home settings icon opens Settings', (tester) async {
    await pumpApp(tester);

    appRouter.go('/home');
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byIcon(PhosphorIconsRegular.gear));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('tapping the Downloads calendar icon opens the Calendar', (
    tester,
  ) async {
    await pumpApp(tester);

    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadsPage), findsOneWidget);

    await tester.tap(find.byIcon(PhosphorIconsRegular.calendarBlank));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarPage), findsOneWidget);
  });
}
