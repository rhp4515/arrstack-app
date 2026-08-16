/// Downloads tab placeholder. Real qBittorrent queue UI lands in Phase 6.
library;

import 'package:arrstack/core/widgets/coming_soon_page.dart';
import 'package:flutter/material.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonPage(
      title: 'Downloads',
      icon: Icons.download_outlined,
    );
  }
}
