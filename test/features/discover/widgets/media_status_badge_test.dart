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
