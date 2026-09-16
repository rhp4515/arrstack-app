import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/discover/widgets/media_status_badge.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, SeerrMediaInfo? mediaInfo) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MediaStatusBadge(mediaInfo: mediaInfo)),
        ),
      );

  testWidgets('shows "In library" for an available item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
    );
    expect(find.text('In library'), findsOneWidget);
  });

  testWidgets('shows "In library" for a partially available item', (
    tester,
  ) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.partiallyAvailable),
    );
    expect(find.text('In library'), findsOneWidget);
  });

  testWidgets(
    'renders "In library" text in a high-contrast color against the accent '
    'fill, not AppColors.text (which fails WCAG AA on accent)',
    (tester) async {
      await pump(
        tester,
        const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
      );
      final text = tester.widget<Text>(find.text('In library'));
      expect(text.style?.color, AppColors.bg);
      expect(text.style?.color, isNot(AppColors.text));
    },
  );

  testWidgets('shows "Requested" for a pending item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.pending),
    );
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('shows "Requested" for a processing item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.processing),
    );
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('renders nothing for null mediaInfo', (tester) async {
    await pump(tester, null);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('renders nothing for an unknown status', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.unknown),
    );
    expect(find.byType(Container), findsNothing);
  });
}
