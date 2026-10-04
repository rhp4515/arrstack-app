import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/torrent_blocklist.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_repository.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRadarr extends Mock implements RadarrRepository {}

class _MockSonarr extends Mock implements SonarrRepository {}

class _MockQbit extends Mock implements QbitRepository {}

const _hash = 'abcdef0123456789abcdef0123456789abcdef01';

QbitTorrent _torrent() => const QbitTorrent(
  hash: _hash,
  name: 'Fake.Movie.2024.1080p',
  size: 1000,
  progress: 0.4,
  dlspeed: 0,
  upspeed: 0,
  priority: 1,
  numSeeds: 1,
  numLeechs: 1,
  numIncomplete: 0,
  ratio: 0,
  eta: 0,
  state: 'downloading',
  addedOn: 0,
  completionOn: 0,
  category: '',
  tags: '',
  savePath: '',
  timeActive: 0,
  lastActivity: 0,
);

ServiceInstance _instance(String id, ServiceType type) => ServiceInstance(
  id: id,
  name: id,
  serviceType: type,
  authType: AuthType.apiKey,
  localBaseUrl: 'http://example.test',
);

void main() {
  test('queueItemIsTorrent matches the hash case-insensitively', () {
    expect(queueItemIsTorrent(_hash.toUpperCase(), _torrent()), isTrue);
    expect(queueItemIsTorrent(_hash, _torrent()), isTrue);
    expect(queueItemIsTorrent('OTHER', _torrent()), isFalse);
    expect(queueItemIsTorrent(null, _torrent()), isFalse);
    expect(queueItemIsTorrent('', _torrent()), isFalse);
  });

  group('removeAndBlocklistTorrent', () {
    late _MockRadarr radarr;
    late _MockSonarr sonarr;
    late _MockQbit qbit;
    BlocklistOutcome? outcome;

    setUp(() {
      radarr = _MockRadarr();
      sonarr = _MockSonarr();
      qbit = _MockQbit();
      outcome = null;
      when(
        () =>
            qbit.deleteTorrents(any(), deleteFiles: any(named: 'deleteFiles')),
      ).thenAnswer((_) async => const Ok(null));
      when(
        () => radarr.deleteQueueItem(
          any(),
          removeFromClient: any(named: 'removeFromClient'),
          blocklist: any(named: 'blocklist'),
        ),
      ).thenAnswer((_) async => const Ok(null));
      when(
        () => sonarr.deleteQueueItem(
          any(),
          removeFromClient: any(named: 'removeFromClient'),
          blocklist: any(named: 'blocklist'),
        ),
      ).thenAnswer((_) async => const Ok(null));
    });

    Future<void> run(
      WidgetTester tester,
      List<ServiceInstance> instances,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok(instances)),
            radarrRepositoryProvider('radarr-1')
                .overrideWith((_) async => radarr),
            sonarrRepositoryProvider('sonarr-1')
                .overrideWith((_) async => sonarr),
            qbitRepositoryProvider('qbit-1').overrideWith((_) async => qbit),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () async =>
                    outcome = await removeAndBlocklistTorrent(
                      ref,
                      instanceId: 'qbit-1',
                      torrent: _torrent(),
                    ),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
    }

    testWidgets('blocklists in the Radarr that grabbed it and removes the '
        'download from the client', (tester) async {
      when(() => radarr.listQueue()).thenAnswer(
        (_) async => Ok([
          const RadarrQueueItem(id: 1, downloadId: 'SOMEONE-ELSE'),
          RadarrQueueItem(id: 7, downloadId: _hash.toUpperCase()),
        ]),
      );
      when(() => sonarr.listQueue()).thenAnswer((_) async => const Ok([]));

      await run(tester, [
        _instance('radarr-1', ServiceType.radarr),
        _instance('sonarr-1', ServiceType.sonarr),
      ]);

      expect(outcome, isA<Blocklisted>());
      expect((outcome! as Blocklisted).serviceName, 'radarr-1');
      verify(
        () =>
            radarr.deleteQueueItem(7, removeFromClient: true, blocklist: true),
      ).called(1);
      verifyNever(
        () =>
            qbit.deleteTorrents(any(), deleteFiles: any(named: 'deleteFiles')),
      );
    });

    testWidgets('finds the torrent in Sonarr, blocklisting every episode of a '
        'pack and removing from the client last', (tester) async {
      when(() => radarr.listQueue()).thenAnswer((_) async => const Ok([]));
      when(() => sonarr.listQueue()).thenAnswer(
        (_) async => Ok([
          SonarrQueueItem(id: 10, downloadId: _hash.toUpperCase()),
          SonarrQueueItem(id: 11, downloadId: _hash.toUpperCase()),
        ]),
      );

      await run(tester, [
        _instance('radarr-1', ServiceType.radarr),
        _instance('sonarr-1', ServiceType.sonarr),
      ]);

      expect(outcome, isA<Blocklisted>());
      verifyInOrder([
        () => sonarr.deleteQueueItem(
          10,
          removeFromClient: false,
          blocklist: true,
        ),
        () =>
            sonarr.deleteQueueItem(11, removeFromClient: true, blocklist: true),
      ]);
    });

    testWidgets('falls back to removing from qBittorrent when no queue has '
        'it', (tester) async {
      when(() => radarr.listQueue()).thenAnswer((_) async => const Ok([]));

      await run(tester, [_instance('radarr-1', ServiceType.radarr)]);

      expect(outcome, isA<RemovedWithoutBlocklist>());
      verify(() => qbit.deleteTorrents([_hash], deleteFiles: true)).called(1);
    });

    testWidgets('removes nothing when a service could not be checked', (
      tester,
    ) async {
      when(() => radarr.listQueue()).thenAnswer((_) async => const Ok([]));
      when(() => sonarr.listQueue()).thenAnswer(
        (_) async => const Err(NetworkError(userMessage: 'unreachable')),
      );

      await run(tester, [
        _instance('radarr-1', ServiceType.radarr),
        _instance('sonarr-1', ServiceType.sonarr),
      ]);

      expect(outcome, isA<BlocklistFailed>());
      expect((outcome! as BlocklistFailed).message, contains('sonarr-1'));
      verifyNever(
        () =>
            qbit.deleteTorrents(any(), deleteFiles: any(named: 'deleteFiles')),
      );
    });

    testWidgets('reports a failed queue delete and leaves the torrent', (
      tester,
    ) async {
      when(() => radarr.listQueue()).thenAnswer(
        (_) async => const Ok([RadarrQueueItem(id: 7, downloadId: _hash)]),
      );
      when(
        () => radarr.deleteQueueItem(
          any(),
          removeFromClient: any(named: 'removeFromClient'),
          blocklist: any(named: 'blocklist'),
        ),
      ).thenAnswer((_) async => const Err(NetworkError(userMessage: 'boom')));

      await run(tester, [_instance('radarr-1', ServiceType.radarr)]);

      expect(outcome, isA<BlocklistFailed>());
      expect((outcome! as BlocklistFailed).message, 'boom');
    });
  });

  testWidgets('the sheet confirms, blocklists and closes with a snackbar', (
    tester,
  ) async {
    final radarr = _MockRadarr();
    final qbit = _MockQbit();
    when(() => qbit.listTorrentFiles(any())).thenAnswer(
      (_) async => const Ok([
        QbitTorrentFile(name: 'Fake.Movie.2024.1080p.mkv.exe', size: 5),
      ]),
    );
    when(radarr.listQueue).thenAnswer(
      (_) async => const Ok([RadarrQueueItem(id: 7, downloadId: _hash)]),
    );
    when(
      () => radarr.deleteQueueItem(
        any(),
        removeFromClient: any(named: 'removeFromClient'),
        blocklist: any(named: 'blocklist'),
      ),
    ).thenAnswer((_) async => const Ok(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith(
            (ref) async => Ok([_instance('radarr-1', ServiceType.radarr)]),
          ),
          radarrRepositoryProvider('radarr-1')
              .overrideWith((_) async => radarr),
          qbitRepositoryProvider('qbit-1').overrideWith((_) async => qbit),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TorrentBlock(instanceId: 'qbit-1', torrent: _torrent()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Files'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove & blocklist'));
    await tester.pumpAndSettle();
    expect(find.text('Remove and blocklist?'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Remove & blocklist').last,
    );
    await tester.pumpAndSettle();

    verify(
      () => radarr.deleteQueueItem(7, removeFromClient: true, blocklist: true),
    ).called(1);
    expect(find.text('Removed and blocklisted in radarr-1.'), findsOneWidget);
    expect(find.text('Contains executable files (.exe)'), findsNothing);
  });
}
