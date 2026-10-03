// Moving stored credentials to first-unlock accessibility without losing
// any.
//
// iOS background refresh mostly runs with the phone locked, and under the
// old `unlocked` accessibility every credential read there failed. The fix
// changes the accessibility, which is only safe with a migration: the
// plugin filters every keychain query by accessibility, and keychain
// uniqueness ignores it. The fake below models exactly that, as
// flutter_secure_storage_darwin implements it:
//
//   - read:   finds an item only if its accessibility matches the query's
//   - write:  updates a matching item, adds otherwise — and adding over an
//             item with a different accessibility is a duplicate error
//   - delete: removes the item whatever its accessibility

import 'dart:convert';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

/// The device keychain: one item per key, each with an accessibility.
class _Keychain {
  final Map<String, ({String value, String accessibility})> items = {};
}

/// One FlutterSecureStorage configured with one accessibility.
class _Storage extends Fake implements FlutterSecureStorage {
  _Storage(this.keychain, this.accessibility);

  final _Keychain keychain;
  final String accessibility;
  bool failWrites = false;

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    final item = keychain.items[key];
    return item != null && item.accessibility == accessibility
        ? item.value
        : null;
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (failWrites) {
      throw PlatformException(code: 'Unexpected security result code');
    }
    final existing = keychain.items[key];
    if (existing != null && existing.accessibility != accessibility) {
      throw PlatformException(
        code: 'Unexpected security result code',
        details: -25299, // errSecDuplicateItem
      );
    }
    keychain.items[key] = (value: value!, accessibility: accessibility);
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => keychain.items.remove(key);
}

const _credential = ServiceCredential.apiKey('0123456789abcdef');
final _stored = jsonEncode(_credential.toJson());

void main() {
  late _Keychain keychain;
  late _Storage current;
  late _Storage legacy;
  late SecureStore store;

  setUp(() {
    keychain = _Keychain();
    current = _Storage(keychain, 'first_unlock');
    legacy = _Storage(keychain, 'unlocked');
    store = FlutterSecureCredentialStore(current, legacy);
  });

  void storeLegacy() => keychain.items['credential.r1'] = (
    value: _stored,
    accessibility: 'unlocked',
  );

  test('finds a credential stored before the change, rather than '
      'reporting it missing', () async {
    storeLegacy();

    expect(await store.readCredential('r1'), _credential);
  });

  test('moves it to first-unlock on that read, so a later locked '
      'background read can see it', () async {
    storeLegacy();

    await store.readCredential('r1');

    expect(keychain.items['credential.r1']?.accessibility, 'first_unlock');
    expect(await current.read(key: 'credential.r1'), _stored);
  });

  test('keeps the credential if moving it fails', () async {
    storeLegacy();
    current.failWrites = true;

    await expectLater(
      store.readCredential('r1'),
      throwsA(isA<PlatformException>()),
    );

    expect(keychain.items['credential.r1'], (
      value: _stored,
      accessibility: 'unlocked',
    ), reason: 'the old item is put back, not lost');
  });

  test('can save over a credential not yet moved, which a plain write '
      'rejects as a duplicate', () async {
    storeLegacy();
    const replacement = ServiceCredential.apiKey('fedcba9876543210');

    await store.writeCredential('r1', replacement);

    expect(keychain.items['credential.r1']?.accessibility, 'first_unlock');
    expect(await store.readCredential('r1'), replacement);
  });

  test('stores new credentials under first-unlock directly', () async {
    await store.writeCredential('r2', _credential);

    expect(keychain.items['credential.r2']?.accessibility, 'first_unlock');
  });

  test('reads nothing for an instance with no credential under either '
      'setting', () async {
    expect(await store.readCredential('nope'), isNull);
  });
}
