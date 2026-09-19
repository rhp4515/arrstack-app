// test/core/widgets/error_card_test.dart
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows title, message, and both action labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            title: 'Bazarr is unreachable',
            message:
                "Subtitle searches will queue until it's back. Radarr and "
                'Sonarr are unaffected.',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () {},
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () {},
          ),
        ),
      ),
    );

    expect(find.text('Bazarr is unreachable'), findsOneWidget);
    expect(find.textContaining('Radarr and'), findsOneWidget);
    expect(find.text('Retry now'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('primary and secondary buttons call their callbacks', (
    tester,
  ) async {
    var primaryTapped = false;
    var secondaryTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            title: 't',
            message: 'm',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () => primaryTapped = true,
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () => secondaryTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retry now'));
    await tester.tap(find.text('Open settings'));

    expect(primaryTapped, isTrue);
    expect(secondaryTapped, isTrue);
  });
}
