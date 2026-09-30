import 'package:arrstack/core/widgets/lens_chip.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/library_section_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders five secondary-tier (10.5px) lens chips', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: LibrarySectionChips())),
      ),
    );

    for (final label in ['All', 'Upcoming', 'Missing', 'Queue', 'History']) {
      expect(find.text(label), findsOneWidget);
      expect(tester.widget<Text>(find.text(label)).style!.fontSize, 10.5);
    }
    expect(find.byType(LensChip), findsNWidgets(5));
  });

  testWidgets('tapping a chip selects that section', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: LibrarySectionChips())),
      ),
    );

    await tester.tap(find.text('Queue'));
    await tester.pump();

    expect(container.read(activeLibrarySectionProvider), LibrarySection.queue);
  });
}
