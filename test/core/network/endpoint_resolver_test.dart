// EndpointResolver matrix (spec §6a): home vs away, forced modes, missing-
// URL fallbacks, SSID-unavailable path, and per-instance homeSsids override.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  const resolver = EndpointResolver();
  const appHomeSsids = ['HomeWifi'];

  group('auto mode', () {
    test('resolves to local when SSID matches a home SSID', () {
      final instance = buildInstance();

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      final resolution = result.valueOrNull;
      expect(resolution, isNotNull);
      expect(resolution!.endpoint, ResolvedEndpoint.local);
      expect(resolution.baseUrl, instance.localBaseUrl);
      expect(resolution.needsManualOverride, isFalse);
    });

    test('matches home SSID case-insensitively and trims whitespace', () {
      final instance = buildInstance();

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: [' homewifi '],
        currentSsid: 'HomeWifi',
      );

      expect(result.valueOrNull?.endpoint, ResolvedEndpoint.local);
    });

    test('resolves to remote when SSID does not match any home SSID', () {
      final instance = buildInstance();

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'CoffeeShopWifi',
      );

      final resolution = result.valueOrNull;
      expect(resolution!.endpoint, ResolvedEndpoint.remote);
      expect(resolution.baseUrl, instance.remoteBaseUrl);
      expect(resolution.needsManualOverride, isFalse);
    });

    test('defaults to remote and flags manual override when SSID is '
        'unavailable', () {
      final instance = buildInstance();

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: null,
      );

      final resolution = result.valueOrNull;
      expect(resolution!.endpoint, ResolvedEndpoint.remote);
      expect(resolution.needsManualOverride, isTrue);
    });

    test('per-instance homeSsidsOverride beats the app-level list', () {
      final instance = buildInstance(homeSsidsOverride: ['OfficeWifi']);

      // "HomeWifi" is the app-level home SSID, but this instance overrides
      // it with "OfficeWifi" — so HomeWifi should now resolve to remote...
      final awayFromOverride = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );
      expect(awayFromOverride.valueOrNull?.endpoint, ResolvedEndpoint.remote);

      // ...and "OfficeWifi" should resolve to local.
      final matchingOverride = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'OfficeWifi',
      );
      expect(matchingOverride.valueOrNull?.endpoint, ResolvedEndpoint.local);
    });
  });

  group('forced modes', () {
    test('forceLocal always uses the local URL regardless of SSID', () {
      final instance = buildInstance(endpointMode: EndpointMode.forceLocal);

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'CoffeeShopWifi',
      );

      final resolution = result.valueOrNull;
      expect(resolution!.endpoint, ResolvedEndpoint.local);
      expect(resolution.needsManualOverride, isFalse);
    });

    test('forceRemote always uses the remote URL regardless of SSID', () {
      final instance = buildInstance(endpointMode: EndpointMode.forceRemote);

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      expect(result.valueOrNull?.endpoint, ResolvedEndpoint.remote);
    });
  });

  group('fallbacks', () {
    test('falls back to remote when the preferred local URL is missing', () {
      final instance = buildInstance(localBaseUrl: null);

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      final resolution = result.valueOrNull;
      expect(resolution!.endpoint, ResolvedEndpoint.remote);
      expect(resolution.baseUrl, instance.remoteBaseUrl);
    });

    test('falls back to local when the preferred remote URL is missing', () {
      final instance = buildInstance(remoteBaseUrl: null);

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'CoffeeShopWifi',
      );

      final resolution = result.valueOrNull;
      expect(resolution!.endpoint, ResolvedEndpoint.local);
      expect(resolution.baseUrl, instance.localBaseUrl);
    });

    test('forceLocal falls back to remote when local URL is missing', () {
      final instance = buildInstance(
        localBaseUrl: null,
        endpointMode: EndpointMode.forceLocal,
      );

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      expect(result.valueOrNull?.endpoint, ResolvedEndpoint.remote);
    });

    test('forceRemote falls back to local when remote URL is missing', () {
      final instance = buildInstance(
        remoteBaseUrl: null,
        endpointMode: EndpointMode.forceRemote,
      );

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      expect(result.valueOrNull?.endpoint, ResolvedEndpoint.local);
    });

    test('treats a blank (whitespace-only) URL as missing', () {
      final instance = buildInstance(localBaseUrl: '   ');

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      expect(result.valueOrNull?.endpoint, ResolvedEndpoint.remote);
    });
  });

  group('validation', () {
    test('returns a ValidationError when both URLs are missing', () {
      final instance = buildInstance(localBaseUrl: null, remoteBaseUrl: null);

      final result = resolver.resolve(
        instance: instance,
        appHomeSsids: appHomeSsids,
        currentSsid: 'HomeWifi',
      );

      expect(result.isErr, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });
}
