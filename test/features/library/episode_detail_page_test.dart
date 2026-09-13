import 'package:arrstack/core/models/auth_type.dart';
import 'package:arrstack/core/models/service_instance.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/episode_detail_page.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

const _bazarrInstance = ServiceInstance(
  id: 'bazarr-1',
  name: 'Bazarr',
  serviceType: ServiceType.bazarr,
  authType: AuthType.apiKey,
  localBaseUrl: 'http://192.168.1.10:6767',
);

Override _episodeOverride(SonarrEpisode episode) => sonarrEpisodeProvider(
  instanceId: 'inst-1',
  seriesId: 1,
  episodeId: 5,
).overrideWith((ref) async => Ok(episode));

Override _seriesOverride() =>
    sonarrSingleSeriesProvider(instanceId: 'inst-1', seriesId: 1).overrideWith(
      (ref) async => const Ok(SonarrSeries(id: 1, title: 'Severance')),
    );

Widget _wrap(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(
      home: EpisodeDetailPage(instanceId: 'inst-1', seriesId: 1, episodeId: 5),
    ),
  );
}

void main() {
  testWidgets(
    'renders primary Find release and secondary Subtitles buttons, and the FILE block',
    (tester) async {
      await tester.pumpWidget(
        _wrap([
          _episodeOverride(
            const SonarrEpisode(
              id: 5,
              seriesId: 1,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'The You You Are',
              hasFile: true,
              monitored: true,
              episodeFile: SonarrEpisodeFile(
                id: 1,
                size: 3100000000,
                relativePath: 'Severance/Season 02/S02E05.mkv',
                quality: SonarrQualityInfo(
                  quality: SonarrQuality(name: 'WEBDL-1080p'),
                ),
              ),
            ),
          ),
          _seriesOverride(),
          primaryBazarrInstanceProvider.overrideWith((ref) async => null),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Find release'), findsOneWidget);
      expect(find.text('Subtitles'), findsOneWidget);
      expect(find.text('FILE'), findsOneWidget);
      expect(find.text('WEBDL-1080p'), findsOneWidget);
      expect(find.text('Severance'), findsOneWidget);
    },
  );

  testWidgets(
    'omits the FILE block entirely when the episode has no episodeFile',
    (tester) async {
      await tester.pumpWidget(
        _wrap([
          _episodeOverride(
            const SonarrEpisode(
              id: 5,
              seriesId: 1,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'The You You Are',
              hasFile: false,
              monitored: true,
            ),
          ),
          _seriesOverride(),
          primaryBazarrInstanceProvider.overrideWith((ref) async => null),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('FILE'), findsNothing);
    },
  );

  testWidgets(
    'renders FILE block without Codec/Audio rows when mediaInfo is null',
    (tester) async {
      await tester.pumpWidget(
        _wrap([
          _episodeOverride(
            const SonarrEpisode(
              id: 5,
              seriesId: 1,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'The You You Are',
              hasFile: true,
              monitored: true,
              episodeFile: SonarrEpisodeFile(
                id: 1,
                size: 3100000000,
                relativePath: 'Severance/Season 02/S02E05.mkv',
                quality: SonarrQualityInfo(
                  quality: SonarrQuality(name: 'WEBDL-1080p'),
                ),
              ),
            ),
          ),
          _seriesOverride(),
          primaryBazarrInstanceProvider.overrideWith((ref) async => null),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('FILE'), findsOneWidget);
      expect(find.text('Quality'), findsOneWidget);
      expect(find.text('Codec'), findsNothing);
      expect(find.text('Audio'), findsNothing);
    },
  );

  testWidgets(
    'omits the SUBTITLES block when no Bazarr instance is configured',
    (tester) async {
      await tester.pumpWidget(
        _wrap([
          _episodeOverride(
            const SonarrEpisode(
              id: 5,
              seriesId: 1,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'The You You Are',
              hasFile: false,
              monitored: true,
            ),
          ),
          _seriesOverride(),
          primaryBazarrInstanceProvider.overrideWith((ref) async => null),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('SUBTITLES'), findsNothing);
    },
  );

  testWidgets(
    'omits the SUBTITLES block when Bazarr has no wanted subtitles for '
    'this episode',
    (tester) async {
      await tester.pumpWidget(
        _wrap([
          _episodeOverride(
            const SonarrEpisode(
              id: 5,
              seriesId: 1,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'The You You Are',
              hasFile: false,
              monitored: true,
            ),
          ),
          _seriesOverride(),
          primaryBazarrInstanceProvider.overrideWith(
            (ref) async => _bazarrInstance,
          ),
          bazarrWantedProvider(_bazarrInstance.id)
              .overrideWith((ref) async => const Ok(<BazarrWantedSubtitle>[])),
        ]),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('SUBTITLES'), findsNothing);
    },
  );
}
