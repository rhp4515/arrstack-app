/// The Service Backup file format (Settings → Advanced → Service Backup).
///
/// A backup carries API keys and passwords, so its contents are encrypted
/// with a passphrase the user chooses (spec §7: "secrets excluded from
/// plaintext export or encrypted"): PBKDF2-HMAC-SHA256 derives a 256-bit
/// key, and AES-256-GCM encrypts and authenticates the payload. Only the
/// envelope (format, version, KDF parameters, service count) is readable
/// without the passphrase.
library;

import 'dart:convert';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';

const String backupFormatId = 'arrstack-service-backup';
const int backupFormatVersion = 1;
const String backupFileExtension = 'arrbackup';

/// PBKDF2 work factor for new backups. Stored in each file, so it can be
/// raised later without breaking older backups.
const int defaultBackupKdfIterations = 310000;

/// Shortest passphrase the export form accepts.
const int minBackupPassphraseLength = 8;

sealed class BackupCodecException implements Exception {
  const BackupCodecException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The file isn't a backup this version of the app can read.
final class InvalidBackupFileException extends BackupCodecException {
  const InvalidBackupFileException([
    super.message = "This file isn't an ArrStack service backup.",
  ]);
}

/// Wrong passphrase, or the file was modified after it was written — GCM
/// can't tell those apart, and neither should the message.
final class WrongPassphraseException extends BackupCodecException {
  const WrongPassphraseException()
    : super('Wrong passphrase, or the backup file is damaged.');
}

class ServiceBackupCodec {
  const ServiceBackupCodec({this.iterations = defaultBackupKdfIterations});

  final int iterations;

  /// Encrypts [payload] (a JSON-encodable map) into the backup file's text.
  /// [serviceCount] is stored in the clear so the import screen can say
  /// what a file holds before asking for its passphrase.
  Future<String> encode({
    required Map<String, dynamic> payload,
    required String passphrase,
    required int serviceCount,
    required DateTime createdAt,
  }) {
    final iterations = this.iterations;
    return Isolate.run(() async {
      final aes = AesGcm.with256bits();
      final salt = SecretKeyData.random(length: 16).bytes;
      final key = await _deriveKey(passphrase, salt, iterations);
      final box = await aes.encrypt(
        utf8.encode(jsonEncode(payload)),
        secretKey: key,
      );
      return const JsonEncoder.withIndent('  ').convert({
        'format': backupFormatId,
        'version': backupFormatVersion,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'serviceCount': serviceCount,
        'kdf': {
          'algorithm': 'pbkdf2-hmac-sha256',
          'iterations': iterations,
          'salt': base64Encode(salt),
        },
        'cipher': {
          'algorithm': 'aes-256-gcm',
          'nonce': base64Encode(box.nonce),
          'mac': base64Encode(box.mac.bytes),
        },
        'payload': base64Encode(box.cipherText),
      });
    });
  }

  /// Reads the clear-text envelope without decrypting.
  BackupEnvelope readEnvelope(String fileText) {
    final Object? decoded;
    try {
      decoded = jsonDecode(fileText);
    } on FormatException {
      throw const InvalidBackupFileException();
    }
    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != backupFormatId) {
      throw const InvalidBackupFileException();
    }
    final version = decoded['version'];
    if (version is! int || version > backupFormatVersion) {
      throw const InvalidBackupFileException(
        'This backup was made by a newer version of the app. Update the '
        'app, then import it again.',
      );
    }
    try {
      final kdf = decoded['kdf'] as Map<String, dynamic>;
      final cipher = decoded['cipher'] as Map<String, dynamic>;
      final iterations = kdf['iterations'] as int;
      // Bounded both ways: too few is a file that was never ours, and an
      // absurd count would pin the CPU for minutes before failing.
      if (kdf['algorithm'] != 'pbkdf2-hmac-sha256' ||
          cipher['algorithm'] != 'aes-256-gcm' ||
          iterations < 1000 ||
          iterations > 5000000) {
        throw const InvalidBackupFileException();
      }
      return BackupEnvelope(
        createdAt: DateTime.tryParse(decoded['createdAt'] as String? ?? ''),
        serviceCount: decoded['serviceCount'] as int? ?? 0,
        iterations: iterations,
        salt: base64Decode(kdf['salt'] as String),
        nonce: base64Decode(cipher['nonce'] as String),
        mac: base64Decode(cipher['mac'] as String),
        cipherText: base64Decode(decoded['payload'] as String),
      );
    } on TypeError {
      throw const InvalidBackupFileException();
    } on FormatException {
      throw const InvalidBackupFileException();
    }
  }

  /// Decrypts [fileText] back into the payload map.
  Future<Map<String, dynamic>> decode({
    required String fileText,
    required String passphrase,
  }) async {
    final envelope = readEnvelope(fileText);
    final plain = await Isolate.run(() async {
      final key = await _deriveKey(
        passphrase,
        envelope.salt,
        envelope.iterations,
      );
      try {
        return await AesGcm.with256bits().decrypt(
          SecretBox(
            envelope.cipherText,
            nonce: envelope.nonce,
            mac: Mac(envelope.mac),
          ),
          secretKey: key,
        );
      } on SecretBoxAuthenticationError {
        return null;
      }
    });
    if (plain == null) throw const WrongPassphraseException();
    try {
      final payload = jsonDecode(utf8.decode(plain));
      if (payload is Map<String, dynamic>) return payload;
    } on FormatException {
      // Falls through: authenticated but not our JSON.
    }
    throw const InvalidBackupFileException();
  }
}

class BackupEnvelope {
  const BackupEnvelope({
    required this.createdAt,
    required this.serviceCount,
    required this.iterations,
    required this.salt,
    required this.nonce,
    required this.mac,
    required this.cipherText,
  });

  final DateTime? createdAt;
  final int serviceCount;
  final int iterations;
  final List<int> salt;
  final List<int> nonce;
  final List<int> mac;
  final List<int> cipherText;
}

Future<SecretKey> _deriveKey(
  String passphrase,
  List<int> salt,
  int iterations,
) {
  return Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKeyFromPassword(password: passphrase, nonce: salt);
}
