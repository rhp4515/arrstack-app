import 'package:arrstack/features/library/widgets/spec_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the kicker and each label/value row', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpecBlock(
            kicker: 'FILE',
            rows: [('Quality', 'WEBDL-1080p'), ('Size', '3.1 GB')],
          ),
        ),
      ),
    );

    expect(find.text('FILE'), findsOneWidget);
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('WEBDL-1080p'), findsOneWidget);
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('3.1 GB'), findsOneWidget);
  });

  testWidgets('renders nothing when rows is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpecBlock(kicker: 'FILE', rows: []),
        ),
      ),
    );

    expect(find.byType(SpecBlock), findsOneWidget);
    expect(find.text('FILE'), findsNothing);
  });
}
