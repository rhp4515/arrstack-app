// ServiceCredential: fromJson/toJson round-trip for both union cases.

import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiKeyCredential round-trips through JSON', () {
    const credential = ServiceCredential.apiKey('abc123');

    final decoded = ServiceCredential.fromJson(credential.toJson());

    expect(decoded, credential);
    expect(decoded, isA<ApiKeyCredential>());
  });

  test('UsernamePasswordCredential round-trips through JSON', () {
    const credential = ServiceCredential.usernamePassword(
      username: 'admin',
      password: 'hunter2',
    );

    final decoded = ServiceCredential.fromJson(credential.toJson());

    expect(decoded, credential);
    expect(decoded, isA<UsernamePasswordCredential>());
  });

  test('pattern matching distinguishes the two credential shapes', () {
    const credential = ServiceCredential.apiKey('xyz');

    final description = switch (credential) {
      ApiKeyCredential(:final apiKey) => 'key:$apiKey',
      UsernamePasswordCredential() => 'userpass',
    };

    expect(description, 'key:xyz');
  });
}
