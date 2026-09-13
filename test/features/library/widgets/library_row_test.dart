import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('percent trailing shows the percentage in green', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'Severance',
            metaParts: ['2022 · Apple TV+ · 19/19'],
            trailing: LibraryRowTrailing.percent,
            percent: 100,
          ),
        ),
      ),
    );

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('progress trailing shows a progress bar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'The Simpsons',
            metaParts: ['30/296'],
            trailing: LibraryRowTrailing.progress,
            progress: 0.10,
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('unmonitored trailing dims the row and shows a bookmark', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'Andor',
            metaParts: ['2022 · 3 seasons'],
            trailing: LibraryRowTrailing.unmonitored,
          ),
        ),
      ),
    );

    expect(find.text('Unmonitored'), findsOneWidget);

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.62);
  });

  testWidgets('renders a FadingRule separator by default', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.radarr,
            instanceId: 'inst-1',
            title: 'Dune: Part Two',
            metaParts: ['54.2 GB'],
            trailing: LibraryRowTrailing.none,
            trailingText: '2160p',
          ),
        ),
      ),
    );

    expect(find.byType(FadingRule), findsOneWidget);
    expect(find.text('2160p'), findsOneWidget);
  });
}
