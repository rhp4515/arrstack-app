// Smoke test: the app boots to the empty dashboard, and bottom-nav tabs
// switch pages.

import 'package:arrstack/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boots to the empty dashboard state', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ArrStackApp()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('No services yet'), findsOneWidget);
  });

  testWidgets('tapping a bottom-nav tab switches pages', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ArrStackApp()));
    await tester.pumpAndSettle();

    expect(find.text('No services yet'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('No services yet'), findsNothing);
    expect(find.text('Settings — coming soon'), findsOneWidget);
  });
}
