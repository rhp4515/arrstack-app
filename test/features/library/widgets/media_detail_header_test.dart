import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, meta, chips, and both stats', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MediaDetailHeader(
            poster: SizedBox(width: 104, height: 156),
            title: 'Severance',
            metaParts: ['2022', 'Apple TV+', 'TV-MA'],
            chips: [Text('★ 8.7'), Text('Monitored')],
            stats: [('19/19', 'EPISODES'), ('61 GB', 'ON DISK')],
          ),
        ),
      ),
    );

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('2022 · Apple TV+ · TV-MA'), findsOneWidget);
    expect(find.text('★ 8.7'), findsOneWidget);
    expect(find.text('Monitored'), findsOneWidget);
    expect(find.text('19/19'), findsOneWidget);
    expect(find.text('EPISODES'), findsOneWidget);
    expect(find.text('61 GB'), findsOneWidget);
    expect(find.text('ON DISK'), findsOneWidget);
  });

  testWidgets('renders the given poster widget directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MediaDetailHeader(
            poster: Icon(Icons.movie, key: Key('custom-poster')),
            title: 'Dune',
            metaParts: [],
            chips: [],
            stats: [],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('custom-poster')), findsOneWidget);
  });
}
