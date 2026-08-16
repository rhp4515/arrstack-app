/// Shared "coming soon" placeholder page for bottom-nav tabs whose real
/// screens land in later build phases (spec §10). Not a fake data screen —
/// just a scaffold with a title and an empty-state message.
library;

import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(icon: icon, title: '$title — coming soon'),
    );
  }
}
