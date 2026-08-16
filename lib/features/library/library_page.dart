/// Library tab placeholder. Real Radarr/Sonarr browse UI lands in Phase 4-5.
library;

import 'package:arrstack/core/widgets/coming_soon_page.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonPage(
      title: 'Library',
      icon: Icons.video_library_outlined,
    );
  }
}
