// instanceVersionProvider (settings_providers.dart) dispatches by ServiceType
// to each repository's real version source: testConnection() for the
// simple apiKey/session-authenticated services, and Bazarr's getStatus()
// specifically (its ConnectionTestClient implementation hits a health-check
// endpoint with no version field). Uptime Kuma/Prowlarr/Einthusan have no
// live version source wired up and must resolve to null rather than a
// fabricated value. Any failure (unreachable instance, parse error) must
// also resolve to null rather than propagating as a provider error.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_client.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_repository.dart';
import 'package:arrstack/services/qbittorrent/qbit_client.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_repository.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

ProviderContainer _container(List<Override> overrides) {
  final c = ProviderContainer(overrides: overrides);
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('returns the live version for a reachable Radarr instance', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://r.test'));
    DioAdapter(
      dio: dio,
    ).onGet('api/v3/system/status', (s) => s.reply(200, {'version': '5.14.0'}));
    final container = _container([
      radarrRepositoryProvider('i1')
          .overrideWith((ref) async => RadarrRepository(RadarrClient(dio))),
    ]);

    final version = await container.read(
      instanceVersionProvider('i1', ServiceType.radarr).future,
    );

    expect(version, '5.14.0');
  });

  test('returns the live version for a reachable Sonarr instance', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(
      dio: dio,
    ).onGet('api/v3/system/status', (s) => s.reply(200, {'version': '4.0.15'}));
    final container = _container([
      sonarrRepositoryProvider('i2')
          .overrideWith((ref) async => SonarrRepository(SonarrClient(dio))),
    ]);

    final version = await container.read(
      instanceVersionProvider('i2', ServiceType.sonarr).future,
    );

    expect(version, '4.0.15');
  });

  test('reads the Bazarr version from getStatus, not the version-less '
      'testConnection health check', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://b.test'));
    DioAdapter(dio: dio).onGet(
      'api/system/status',
      (s) => s.reply(200, {
        'version': '1.4.3',
        'branch': 'master',
        'app_name': 'Bazarr',
      }),
    );
    final container = _container([
      bazarrRepositoryProvider('i3')
          .overrideWith((ref) async => BazarrRepository(BazarrClient(dio))),
    ]);

    final version = await container.read(
      instanceVersionProvider('i3', ServiceType.bazarr).future,
    );

    expect(version, '1.4.3');
  });

  test('returns the live version for a reachable Seerr instance', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://x.test'));
    DioAdapter(dio: dio)
        .onGet('api/v1/status', (s) => s.reply(200, {'version': '1.33.2'}));
    final container = _container([
      seerrRepositoryProvider('i4')
          .overrideWith((ref) async => SeerrRepository(SeerrClient(dio))),
    ]);

    final version = await container.read(
      instanceVersionProvider('i4', ServiceType.seerr).future,
    );

    expect(version, '1.33.2');
  });

  test(
    'returns the live version for a reachable qBittorrent instance',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://q.test'));
      DioAdapter(dio: dio)
          .onGet('api/v2/app/version', (s) => s.reply(200, 'v4.6.0'));
      final container = _container([
        qbitRepositoryProvider('i5').overrideWith(
          (ref) async =>
              QbitRepository(QbitClient(dio), const ApiKeyCredential('x')),
        ),
      ]);

      final version = await container.read(
        instanceVersionProvider('i5', ServiceType.qbittorrent).future,
      );

      expect(version, 'v4.6.0');
    },
  );

  test('resolves to null for Uptime Kuma, Prowlarr, and Einthusan '
      'rather than fabricating a version', () async {
    final container = _container([]);

    for (final type in [
      ServiceType.uptimeKuma,
      ServiceType.prowlarr,
      ServiceType.einthusan,
    ]) {
      final version = await container.read(
        instanceVersionProvider('i6', type).future,
      );
      expect(version, isNull, reason: '$type must not fabricate a version');
    }
  });

  test(
    'resolves to null rather than throwing when the version fetch fails',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://r2.test'));
      DioAdapter(
        dio: dio,
      ).onGet('api/v3/system/status', (s) => s.reply(500, {'message': 'boom'}));
      final container = _container([
        radarrRepositoryProvider('i7')
            .overrideWith((ref) async => RadarrRepository(RadarrClient(dio))),
      ]);

      final version = await container.read(
        instanceVersionProvider('i7', ServiceType.radarr).future,
      );

      expect(version, isNull);
    },
  );
}
