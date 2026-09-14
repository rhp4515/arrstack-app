import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/collection_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows both chips with inline counts', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CollectionChips(showsCount: 68, moviesCount: 412),
          ),
        ),
      ),
    );

    expect(find.text('Shows 68'), findsOneWidget);
    expect(find.text('Movies 412'), findsOneWidget);
  });

  testWidgets('tapping Movies switches the active tab', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: CollectionChips(showsCount: 68, moviesCount: 412),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Movies 412'));
    await tester.pump();

    expect(container.read(activeLibraryTabProvider), LibraryTab.movies);
  });
}
