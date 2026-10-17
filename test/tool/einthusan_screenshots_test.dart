// Renders the Einthusan Import page (real page, real controller, real dark
// theme, real fonts) into PNGs for PR descriptions. Skipped unless
// SCREENSHOT_DIR is set, so it never runs as part of a normal test run:
//
//   SCREENSHOT_DIR=/tmp/shots \
//   MATERIAL_FONTS_DIR=$FLUTTER_ROOT/bin/cache/artifacts/material_fonts \
//   flutter test test/tool/einthusan_screenshots_test.dart
//
// Posters are not shown (the page only shows them in the TMDB candidate
// picker, which these scenes do not include).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_page.dart';
import 'package:arrstack/features/einthusan_import/einthusan_job_history_store.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _instanceId = 'i1';
final _outDir = Platform.environment['SCREENSHOT_DIR'];
final _fontsDir = Platform.environment['MATERIAL_FONTS_DIR'];

class _FakeSelectedLibraryInstanceId extends SelectedLibraryInstanceId {
  @override
  Future<String?> build(ServiceType type) async => 'r1';
}

Future<void> _loadFont(String family, String path) async {
  final bytes = await File(path).readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}

Map<String, dynamic> _job(
  String id,
  String state, {
  String? title,
  int? year,
  Map<String, dynamic>? extra,
}) => {
  'id': id,
  'state': state,
  'einthusan_url': 'https://einthusan.tv/movie/watch/$id',
  if (title != null) ...{
    'selected_tmdb_id': id.hashCode.abs() % 1000,
    'candidates': [
      {
        'tmdb_id': id.hashCode.abs() % 1000,
        'title': title,
        'year': year,
        'tmdb_url': 'https://themoviedb.org/movie/1',
      },
    ],
  },
  ...?extra,
};

void main() {
  final enabled = _outDir != null && _fontsDir != null;

  late Dio dio;
  late List<Map<String, dynamic>> serverJobs;
  late bool listingDown;
  final boundaryKey = GlobalKey();

  setUpAll(() async {
    if (!enabled) return;
    await _loadFont('Inter', 'assets/fonts/Inter-Variable.ttf');
    await _loadFont('MaterialIcons', '$_fontsDir/MaterialIcons-Regular.otf');
    await Directory(_outDir!).create(recursive: true);
  });

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    listingDown = false;
    // Oldest first, as the downloader lists them; shown newest first.
    serverJobs = [
      _job('confirm', 'awaiting_verification', title: 'Drishyam 2', year: 2022),
      _job(
        'failed',
        'error',
        title: 'Ponniyin Selvan: I',
        year: 2022,
        extra: {
          'error': {
            'code': 'download_failed',
            'message': 'Download failed: the stream link expired (HTTP 403).',
          },
        },
      ),
      _job(
        'done',
        'done',
        title: 'RRR',
        year: 2022,
        extra: {
          'result': {
            'file': 'RRR (2022) [1080p].mkv',
            'radarr_movie_id': 12,
            'tmdb_id': 579974,
          },
        },
      ),
      _job(
        'downloading',
        'downloading',
        title: 'Kantara',
        year: 2022,
        extra: {
          'progress': {
            'downloaded_bytes': 1170000000,
            'total_bytes': 2790000000,
            'percent': 41.9,
            'speed_bps': 6700000.0,
            'eta_seconds': 240.0,
          },
        },
      ),
    ];
    adapter.onGet('api/v1/jobs', (server) {
      server.replyCallback(200, (options) {
        if (listingDown) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'down',
          );
        }
        return serverJobs;
      });
    });
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Known only from history: the downloader restarted and forgot it.
    final store = PreferencesEinthusanJobHistoryStore(InMemoryAppPreferences());
    await store.write(_instanceId, [
      EinthusanJobRecord(
        jobId: 'lost',
        einthusanUrl: 'https://einthusan.tv/movie/watch/lost',
        title: 'Vikram',
        year: 2022,
        state: JobState.downloading,
        createdAt: DateTime.utc(2026, 9, 1),
        updatedAt: DateTime.utc(2026, 9, 1),
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          einthusanRepositoryProvider(_instanceId).overrideWith(
            (ref) async => EinthusanRepository(EinthusanClient(dio)),
          ),
          einthusanJobHistoryStoreProvider.overrideWithValue(store),
          selectedLibraryInstanceIdProvider(
            ServiceType.radarr,
          ).overrideWith(_FakeSelectedLibraryInstanceId.new),
        ],
        child: RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.dark,
            home: const EinthusanImportPage(instanceId: _instanceId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> capture(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    final boundary =
        boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      await File('$_outDir/$name.png').writeAsBytes(data!.buffer.asUint8List());
    });
  }

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
  }

  final skip = enabled ? null : 'set SCREENSHOT_DIR and MATERIAL_FONTS_DIR';

  testWidgets('01 recent imports list', (tester) async {
    await pumpPage(tester);
    await capture(tester, '01_recent_imports');
    await dispose(tester);
  }, skip: skip != null);

  testWidgets('02 downloader unreachable', (tester) async {
    await pumpPage(tester);
    listingDown = true;
    await tester.pump(const Duration(seconds: 3));
    await capture(tester, '02_downloader_unreachable');
    await dispose(tester);
  }, skip: skip != null);

  testWidgets('03 downloading step', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('Kantara (2022)'));
    await capture(tester, '03_open_downloading');
    await dispose(tester);
  }, skip: skip != null);

  testWidgets('04 done step', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('RRR (2022)'));
    await capture(tester, '04_open_imported');
    await dispose(tester);
  }, skip: skip != null);

  testWidgets('05 lost step', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('Vikram (2022)'));
    await capture(tester, '05_open_status_unknown');
    await dispose(tester);
  }, skip: skip != null);
}
