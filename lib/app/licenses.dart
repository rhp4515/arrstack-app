/// Licence and attribution text shown on the About & licenses page.
///
/// Flutter lists every Dart package's licence there automatically; the
/// bundled Inter font is not a package, so its SIL Open Font License is
/// registered here, and the notices the services we show content from ask
/// for are the page's legalese.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

const appDisplayName = 'ArrStack Companion';

const appLegalese =
    'MIT License. Copyright (c) 2026 Hari Raman.\n\n'
    'This product uses the TMDB API but is not endorsed or certified by '
    'TMDB. Movie and show artwork comes from TMDB.\n\n'
    'ArrStack Companion is not affiliated with Sonarr, Radarr, Prowlarr, '
    'Bazarr, Seerr, Jellyfin, qBittorrent or Uptime Kuma. Their names are '
    'used only to say which services the app works with.';

/// Adds the Inter font's SIL Open Font License to Flutter's licence page.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Inter',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
}
