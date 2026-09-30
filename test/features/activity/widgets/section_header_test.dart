import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
  theme: ThemeData(colorScheme: const ColorScheme.dark()),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('renders an accent kicker with muted right-aligned meta', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const SectionHeader(kicker: 'MISSING · 3', trailing: 'Sonarr')),
    );

    expect(
      tester.widget<Text>(find.text('MISSING · 3')).style!.color,
      AppColors.accent,
    );
    expect(
      tester.widget<Text>(find.text('Sonarr')).style!.color,
      AppColors.n400,
    );
  });

  testWidgets('a trailing widget replaces the meta text', (tester) async {
    await tester.pumpWidget(
      _host(
        SectionHeader(
          kicker: 'K',
          trailing: 'ignored',
          trailingWidget: TextButton(
            onPressed: () {},
            child: const Text('Search all'),
          ),
        ),
      ),
    );

    expect(find.text('Search all'), findsOneWidget);
    expect(find.text('ignored'), findsNothing);
  });
}
