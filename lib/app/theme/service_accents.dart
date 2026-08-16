/// Per-service accent colors (spec §8).
///
/// Used to badge/tint UI that belongs to a specific service module so the
/// user always knows which integration a screen is showing. Semantic use
/// only — accent = "which service you're in," not decoration.
library;

import 'package:flutter/painting.dart';

abstract final class ServiceAccents {
  static const Color sonarr = Color(0xFF35C5F0);
  static const Color radarr = Color(0xFFFFC230);
  static const Color bazarr = Color(0xFFBE4BDB);
  static const Color prowlarr = Color(0xFFE66000);
  static const Color qbittorrent = Color(0xFF2F67BA);
  static const Color uptimeKuma = Color(0xFF5CDD8B);
  static const Color seerr = Color(0xFF6366F1);
}
