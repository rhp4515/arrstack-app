import 'package:arrstack/features/library/library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the Library title without throwing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LibraryPage())),
    );
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.byType(LibraryPage), findsOneWidget);
  });
}
