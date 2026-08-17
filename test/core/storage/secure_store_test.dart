// FlutterSecureCredentialStore parsing: a corrupted or legacy entry must be
// treated as absent (return null), never crash across the storage boundary
// (spec §5). Mocks flutter_secure_storage so no plugin/platform channel runs.

import 'dart:convert';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late SecureStore store;

  setUp(() {
    storage = _MockSecureStorage();
    store = FlutterSecureCredentialStore(storage);
  });

  void stubRead(String? value) {
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => value);
  }

  group('readCredential', () {
    test('returns null when nothing is stored', () async {
      stubRead(null);

      expect(await store.readCredential('id'), isNull);
    });

    test('round-trips a valid stored credential', () async {
      const credential = ServiceCredential.apiKey('k3y');
      stubRead(jsonEncode(credential.toJson()));

      expect(await store.readCredential('id'), credential);
    });

    test('treats malformed JSON as absent, without throwing', () async {
      stubRead('this is not json');

      expect(await store.readCredential('id'), isNull);
    });

    test('treats a non-object payload as absent, without throwing', () async {
      stubRead('[1, 2, 3]');

      expect(await store.readCredential('id'), isNull);
    });

    test('treats an unrecognized union tag as absent, without throwing — '
        'a corrupted or legacy secure-storage entry', () async {
      stubRead(jsonEncode(const {'runtimeType': 'bogus', 'apiKey': 'x'}));

      expect(await store.readCredential('id'), isNull);
    });
  });
}
