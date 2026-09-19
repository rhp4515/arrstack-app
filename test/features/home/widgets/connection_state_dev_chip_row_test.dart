// test/features/home/widgets/connection_state_dev_chip_row_test.dart
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a chip per HomeConnectionState plus Live', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: ConnectionStateDevChipRow())),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    for (final state in HomeConnectionState.values) {
      expect(find.text(state.name), findsOneWidget);
    }
  });

  testWidgets('tapping a chip sets the dev override', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: ConnectionStateDevChipRow()),
        ),
      ),
    );

    await tester.tap(find.text('offline'));
    await tester.pump();

    expect(
      container.read(homeConnectionStateDevOverrideProvider),
      HomeConnectionState.offline,
    );
  });

  testWidgets('tapping Live clears the dev override', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(homeConnectionStateDevOverrideProvider.notifier)
        .set(HomeConnectionState.offline);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: ConnectionStateDevChipRow()),
        ),
      ),
    );

    await tester.tap(find.text('Live'));
    await tester.pump();

    expect(container.read(homeConnectionStateDevOverrideProvider), isNull);
  });
}
