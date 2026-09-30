/// Pull-to-refresh scaffolding shared by the Library's sub-tab lists, so
/// loading, empty and error states can be refreshed the same way as data.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// An always-scrollable list under a [RefreshIndicator].
class RefreshableSection extends StatelessWidget {
  const RefreshableSection({
    required this.onRefresh,
    required this.children,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.space8),
        children: children,
      ),
    );
  }
}

/// An [EmptyState] that can still be pulled to refresh.
class RefreshableMessage extends StatelessWidget {
  const RefreshableMessage({
    required this.onRefresh,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return RefreshableSection(
      onRefresh: onRefresh,
      children: [
        const SizedBox(height: AppSpacing.space8),
        EmptyState(icon: icon, title: title, message: message, action: action),
      ],
    );
  }
}

/// The standard failure state: the error's user message plus Retry.
class RefreshableError extends StatelessWidget {
  const RefreshableError({
    required this.onRefresh,
    required this.title,
    required this.message,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return RefreshableMessage(
      onRefresh: onRefresh,
      icon: PhosphorIconsRegular.warning,
      title: title,
      message: message,
      action: FilledButton(onPressed: onRefresh, child: const Text('Retry')),
    );
  }
}

/// Case-insensitive title match for the header search box.
bool matchesQuery(String query, String title) =>
    query.isEmpty || title.toLowerCase().contains(query.toLowerCase());
