/// Settings tab placeholder. Real instance CRUD + theme setting UI lands in
/// Phase 3.
library;

import 'package:arrstack/core/widgets/coming_soon_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonPage(
      title: 'Settings',
      icon: Icons.settings_outlined,
    );
  }
}
