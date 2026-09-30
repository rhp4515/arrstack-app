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

  test('concurrent appends are all kept', () async {
    final store = FileDiagnosticLogStore(() async => file);
    await Future.wait([for (var i = 0; i < 20; i++) store.append(entry(i))]);
    expect(await store.readAll(), hasLength(20));
  });
}
