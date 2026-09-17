import 'dart:async';

import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return capturedContext;
  }

  testWidgets('cancel returns null', (tester) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });

  testWidgets('confirm with the toggle off returns deleteFiles: false', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
        showDeleteFilesToggle: true,
        deleteFilesSubtitle: '1.4 GB downloaded so far',
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    expect(find.text('Also delete files on disk'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.deleteFiles, isFalse);
  });

  testWidgets('toggling on before confirming returns deleteFiles: true', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
        showDeleteFilesToggle: true,
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(result!.deleteFiles, isTrue);
  });

  testWidgets('the toggle is hidden by default', (tester) async {
    final context = await pumpHost(tester);

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this instance?',
        message: 'This removes it and its stored credentials.',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Switch), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
