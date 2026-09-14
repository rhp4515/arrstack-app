import 'package:arrstack/core/widgets/labeled_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders label, selected value and caption', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Quality profile',
            value: 'HD-1080p',
            items: const [
              DropdownMenuItem(value: 'HD-1080p', child: Text('HD-1080p')),
              DropdownMenuItem(value: '4K', child: Text('4K')),
            ],
            onChanged: (_) {},
            caption: '2.4 TB free of 18 TB',
          ),
        ),
      ),
    );

    expect(find.text('Quality profile'), findsOneWidget);
    expect(find.text('HD-1080p'), findsOneWidget);
    expect(find.text('2.4 TB free of 18 TB'), findsOneWidget);
  });

  testWidgets('omits the caption row when none is given', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Root folder',
            value: '/data/media/movies',
            items: const [
              DropdownMenuItem(
                value: '/data/media/movies',
                child: Text('/data/media/movies'),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Root folder'), findsOneWidget);
    expect(find.byType(LabeledDropdownField<String>), findsOneWidget);
  });

  testWidgets('onChanged fires with the newly selected item', (tester) async {
    String? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Quality profile',
            value: 'HD-1080p',
            items: const [
              DropdownMenuItem(value: 'HD-1080p', child: Text('HD-1080p')),
              DropdownMenuItem(value: '4K', child: Text('4K')),
            ],
            onChanged: (v) => captured = v,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4K').last);
    await tester.pumpAndSettle();

    expect(captured, '4K');
  });
}
