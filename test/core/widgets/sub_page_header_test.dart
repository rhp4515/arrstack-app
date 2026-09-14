import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders kicker over title when kicker is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: SubPageHeader(kicker: 'UPTIME KUMA', title: 'Monitors'),
        ),
      ),
    );

    expect(find.text('UPTIME KUMA'), findsOneWidget);
    expect(find.text('Monitors'), findsOneWidget);
  });

  testWidgets('renders only the title when kicker is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: SubPageHeader(title: 'Settings')),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('renders provided actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SubPageHeader(
            title: 'Indexers',
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  test('preferredSize matches the standard toolbar height', () {
    const header = SubPageHeader(title: 'Settings');
    expect(header.preferredSize, const Size.fromHeight(kToolbarHeight));
  });
}
