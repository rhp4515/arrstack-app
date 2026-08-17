// ServiceIdentity: fromJson/toJson round-trip.

import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round-trips with a version present', () {
    const identity = ServiceIdentity(
      instanceName: 'Home Radarr',
      version: '5.1.2',
    );

    final decoded = ServiceIdentity.fromJson(identity.toJson());

    expect(decoded, identity);
  });

  test('round-trips without a version', () {
    const identity = ServiceIdentity(instanceName: 'Home Radarr');

    final decoded = ServiceIdentity.fromJson(identity.toJson());

    expect(decoded.version, isNull);
    expect(decoded.instanceName, 'Home Radarr');
  });
}
