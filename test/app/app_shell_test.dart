import 'package:arrstack/app/app.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/storage/fakes.dart';

class _FakeSsidSource implements SsidSource {
  @override
  Future<String?> currentSsid() async => 'Home-WiFi';

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<PermissionStatus> permissionStatus() async => PermissionStatus.granted;
}

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(FakeConfigStore()),
          secureStoreProvider.overrideWithValue(FakeSecureStore()),
          ssidSourceProvider.overrideWithValue(_FakeSsidSource()),
        ],
        child: const ArrStackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows exactly 3 tabs: Home, Library, Activity', (tester) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Settings'), findsNothing); // no longer a top-level tab
    expect(find.text('Uptime'), findsNothing);
    expect(find.text('Discover'), findsNothing);
  });

  testWidgets('tapping Library switches the branch', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsWidgets); // tab label + app bar title
  });
}
