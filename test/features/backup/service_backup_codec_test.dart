import 'dart:convert';

import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A low work factor keeps the suite fast; the format stores it per file.
  const codec = ServiceBackupCodec(iterations: 1000);
  final createdAt = DateTime.utc(2026, 9, 30, 8, 45);

  Future<String> encode([Map<String, dynamic>? payload]) => codec.encode(
    payload: payload ?? {'instances': <Object>[], 'secret': 'abc123'},
    passphrase: 'correct horse',
    serviceCount: 2,
    createdAt: createdAt,
  );

  test('round-trips the payload with the right passphrase', () async {
    final text = await encode({'hello': 'world', 'n': 3});
    final decoded = await codec.decode(
      fileText: text,
      passphrase: 'correct horse',
    );
    expect(decoded, {'hello': 'world', 'n': 3});
  });

  test('the file never contains the payload in the clear', () async {
    final text = await encode();
    expect(text, isNot(contains('abc123')));
    final envelope = codec.readEnvelope(text);
    expect(envelope.serviceCount, 2);
    expect(envelope.createdAt, createdAt);
    expect(envelope.iterations, 1000);
  });

  test('a wrong passphrase fails authentication', () async {
    final text = await encode();
    await expectLater(
      codec.decode(fileText: text, passphrase: 'wrong horse'),
      throwsA(isA<WrongPassphraseException>()),
    );
  });

  test('a tampered ciphertext fails authentication', () async {
    final json = jsonDecode(await encode()) as Map<String, dynamic>;
    final bytes = base64Decode(json['payload'] as String);
    bytes[0] ^= 0xFF;
    json['payload'] = base64Encode(bytes);
    await expectLater(
      codec.decode(fileText: jsonEncode(json), passphrase: 'correct horse'),
      throwsA(isA<WrongPassphraseException>()),
    );
  });

  test('rejects files that are not backups', () {
    expect(
      () => codec.readEnvelope('not json'),
      throwsA(isA<InvalidBackupFileException>()),
    );
    expect(
      () => codec.readEnvelope('{"format":"something-else"}'),
      throwsA(isA<InvalidBackupFileException>()),
    );
    expect(
      () => codec.readEnvelope('{"format":"$backupFormatId","version":1}'),
      throwsA(isA<InvalidBackupFileException>()),
    );
  });

  test('rejects a backup from a newer format version', () async {
    final json = jsonDecode(await encode()) as Map<String, dynamic>;
    json['version'] = backupFormatVersion + 1;
    expect(
      () => codec.readEnvelope(jsonEncode(json)),
      throwsA(
        isA<InvalidBackupFileException>().having(
          (e) => e.message,
          'message',
          contains('newer version'),
        ),
      ),
    );
  });

  test('rejects an out-of-range work factor instead of running it', () async {
    final json = jsonDecode(await encode()) as Map<String, dynamic>;
    (json['kdf'] as Map<String, dynamic>)['iterations'] = 1000000000;
    expect(
      () => codec.readEnvelope(jsonEncode(json)),
      throwsA(isA<InvalidBackupFileException>()),
    );
  });
}
