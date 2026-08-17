// ServiceInstance: fromJson/toJson round-trip, immutability (copyWith),
// and validateServiceInstance boundary checks.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  group('fromJson/toJson round-trip', () {
    test('round-trips every field, including optional ones', () {
      final instance = buildInstance(
        homeSsidsOverride: ['Office', 'Warehouse'],
        endpointMode: EndpointMode.forceRemote,
        isDefault: true,
      );

      final decoded = ServiceInstance.fromJson(instance.toJson());

      expect(decoded, instance);
    });

    test('round-trips with null local/remote URLs omitted appropriately', () {
      final instance = buildInstance(localBaseUrl: null);

      final decoded = ServiceInstance.fromJson(instance.toJson());

      expect(decoded.localBaseUrl, isNull);
      expect(decoded.remoteBaseUrl, instance.remoteBaseUrl);
    });

    test('endpointMode defaults to auto when absent from JSON', () {
      final json = {
        'id': 'sonarr-1',
        'name': 'Home Sonarr',
        'serviceType': 'sonarr',
        'authType': 'apiKey',
        'localBaseUrl': 'http://192.168.1.5:8989',
      };

      final instance = ServiceInstance.fromJson(json);

      expect(instance.endpointMode, EndpointMode.auto);
      expect(instance.isDefault, isFalse);
    });
  });

  group('immutability', () {
    test('copyWith returns a new instance without mutating the original', () {
      final original = buildInstance();
      final renamed = original.copyWith(name: 'Renamed Radarr');

      expect(renamed.name, 'Renamed Radarr');
      expect(original.name, 'Home Radarr');
      expect(identical(original, renamed), isFalse);
    });
  });

  group('validateServiceInstance', () {
    test('accepts an instance with only a local URL', () {
      final instance = buildInstance(remoteBaseUrl: null);

      final result = validateServiceInstance(instance);

      expect(result.isOk, isTrue);
    });

    test('accepts an instance with only a remote URL', () {
      final instance = buildInstance(localBaseUrl: null);

      final result = validateServiceInstance(instance);

      expect(result.isOk, isTrue);
    });

    test('rejects an instance with neither local nor remote URL', () {
      final instance = buildInstance(localBaseUrl: null, remoteBaseUrl: null);

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('rejects an unparseable local URL', () {
      final instance = buildInstance(localBaseUrl: 'not a url');

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
    });

    test('rejects a URL with no scheme', () {
      final instance = buildInstance(localBaseUrl: '192.168.1.10:7878');

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
    });

    test('rejects a URL with no host', () {
      final instance = buildInstance(localBaseUrl: 'http://');

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
    });

    test('rejects an empty id', () {
      final instance = buildInstance(id: '   ');

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
    });

    test('rejects an empty name', () {
      final instance = buildInstance(name: '');

      final result = validateServiceInstance(instance);

      expect(result.isErr, isTrue);
    });
  });

  group('ServiceType', () {
    test('qbittorrent and uptimeKuma default to usernamePassword', () {
      expect(
        ServiceType.qbittorrent.defaultAuthType,
        AuthType.usernamePassword,
      );
      expect(ServiceType.uptimeKuma.defaultAuthType, AuthType.usernamePassword);
    });

    test('the *arr services and seerr default to apiKey', () {
      for (final type in [
        ServiceType.sonarr,
        ServiceType.radarr,
        ServiceType.bazarr,
        ServiceType.prowlarr,
        ServiceType.seerr,
      ]) {
        expect(type.defaultAuthType, AuthType.apiKey);
      }
    });

    test('every service type has a non-empty display name', () {
      for (final type in ServiceType.values) {
        expect(type.displayName, isNotEmpty);
      }
    });
  });
}
