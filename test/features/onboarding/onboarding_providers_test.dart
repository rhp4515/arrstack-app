import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('errorCardTitle maps NetworkError to a connection-refused title', () {
    expect(
      errorCardTitle(const NetworkError()),
      'Local URL refused the connection',
    );
  });

  test('errorCardTitle maps AuthError to a credentials title', () {
    expect(
      errorCardTitle(const AuthError()),
      'Local URL rejected the credentials',
    );
  });
}
