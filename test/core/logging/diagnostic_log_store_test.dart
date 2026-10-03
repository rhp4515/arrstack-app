import 'dart:io';

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('diag_log_test');
    file = File('${dir.path}/log.json');
  });

  tearDown(() => dir.deleteSync(recursive: true));

  LogEntry entry(int n, {String message = 'm'}) => LogEntry(
    time: DateTime.utc(2026, 9, 30, 12, 0, n),
    level: LogLevel.warn,
    tag: 'Radarr',
    message: '$message $n',
  );

  test('stores newest first and persists across instances', () async {
    final store = FileDiagnosticLogStore(() async => file);
    await store.append(entry(1));
    await store.append(entry(2));

    final reopened = FileDiagnosticLogStore(() async => file);
    final all = await reopened.readAll();
    expect(all.map((e) => e.message), ['m 2', 'm 1']);
  });

  test('drops the oldest entries beyond the cap', () async {
    final store = FileDiagnosticLogStore(() async => file, maxEntries: 3);
    for (var i = 0; i < 5; i++) {
      await store.append(entry(i));
    }
    expect((await store.readAll()).map((e) => e.message), [
      'm 4',
      'm 3',
      'm 2',
    ]);
  });

  test('redacts messages before they are written to disk', () async {
    final store = FileDiagnosticLogStore(() async => file);
    await store.append(entry(1, message: 'http://10.0.0.5:7878/api'));
    expect(file.readAsStringSync(), isNot(contains('10.0.0.5')));
    expect((await store.readAll()).single.message, 'http://<host>/api 1');
  });

  test(
    'a corrupt file reads as empty and is replaced on the next write',
    () async {
      file.writeAsStringSync('{not json');
      final store = FileDiagnosticLogStore(() async => file);
      expect(await store.readAll(), isEmpty);
      await store.append(entry(1));
      expect(await store.readAll(), hasLength(1));
    },
  );

  test('clear empties the log and notifies listeners', () async {
    final store = FileDiagnosticLogStore(() async => file);
    var changes = 0;
    final sub = store.changes.listen((_) => changes++);
    await store.append(entry(1));
    await store.clear();
    await Future<void>.delayed(Duration.zero);
    expect(await store.readAll(), isEmpty);
    expect(changes, 2);
    await sub.cancel();
  });

  group('shared with the background isolate', () {
    // The background notification worker runs in its own isolate with its
    // own store over the same file. Two instances over one file stand in
    // for the two isolates.

    test(
      'one store sees entries the other wrote after it first read',
      () async {
        final ui = FileDiagnosticLogStore(() async => file);
        final background = FileDiagnosticLogStore(() async => file);

        await ui.append(entry(1)); // the UI has now read the file
        await background.append(entry(2));

        expect((await ui.readAll()).map((e) => e.message), ['m 2', 'm 1']);
      },
    );

    test("one store's append keeps entries the other wrote, rather than "
        'writing back a stale copy over them', () async {
      final ui = FileDiagnosticLogStore(() async => file);
      final background = FileDiagnosticLogStore(() async => file);

      await ui.append(entry(1));
      await background.append(entry(2)); // the worker logs a failure
      await ui.append(entry(3)); // the UI's next append

      expect((await background.readAll()).map((e) => e.message), [
        'm 3',
        'm 2',
        'm 1',
      ]);
    });

    test('leaves no temp files behind', () async {
      final store = FileDiagnosticLogStore(() async => file);
      for (var i = 0; i < 5; i++) {
        await store.append(entry(i));
      }

      expect(dir.listSync().map((f) => f.uri.pathSegments.last), ['log.json']);
    });
  });

  test('redacts the tag as well as the message', () async {
    final store = FileDiagnosticLogStore(() async => file);
    await store.append(
      LogEntry(
        time: DateTime.utc(2026, 9, 30),
        level: LogLevel.warn,
        // Instance names are user-chosen, and may be an address.
        tag: '192.168.1.20 Radarr',
        message: 'Notification check failed',
      ),
    );

    expect(file.readAsStringSync(), isNot(contains('192.168.1.20')));
    expect((await store.readAll()).single.tag, '<host> Radarr');
  });

  test('concurrent appends are all kept', () async {
    final store = FileDiagnosticLogStore(() async => file);
    await Future.wait([for (var i = 0; i < 20; i++) store.append(entry(i))]);
    expect(await store.readAll(), hasLength(20));
  });
}
