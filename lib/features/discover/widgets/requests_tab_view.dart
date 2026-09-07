/// The "Requests" tab body on the Discover page — filter/sort pill row plus
/// the vertical request list. Matches
/// example_mockups/seerr_requests_listview.jpeg.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/discover/widgets/request_list_tile.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsTabView extends ConsumerStatefulWidget {
  const RequestsTabView({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<RequestsTabView> createState() => _RequestsTabViewState();
}

class _RequestsTabViewState extends ConsumerState<RequestsTabView> {
  String _filter = 'all';
  String _sort = 'added';

  static const _filterLabels = {
    'all': 'All',
    'pending': 'Pending',
    'approved': 'Approved',
    'declined': 'Declined',
  };

  static const _sortLabels = {'added': 'Added', 'modified': 'Modified'};

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(
      seerrRequestsProvider(
        instanceId: widget.instanceId,
        filter: _filter,
        sort: _sort,
      ),
    );

    return Column(
      children: [
        Padding(
          padding: AppInsets.horizontalMd,
          child: Row(
            children: [
              _FilterSortPill(
                icon: Icons.filter_alt_outlined,
                label: 'Filter: ${_filterLabels[_filter]}',
                items: _filterLabels,
                selected: _filter,
                onSelected: (value) => setState(() => _filter = value),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterSortPill(
                icon: Icons.swap_vert,
                label: 'Sort: ${_sortLabels[_sort]}',
                items: _sortLabels,
                selected: _sort,
                onSelected: (value) => setState(() => _sort = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: requestsAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) =>
                value.results.isEmpty
                    ? const EmptyState(
                        icon: Icons.inbox_outlined,
                        title: 'No requests',
                        message: 'Requests you make will show up here.',
                      )
                    : RefreshIndicator(
                        onRefresh: () async => ref.invalidate(
                          seerrRequestsProvider(
                            instanceId: widget.instanceId,
                            filter: _filter,
                            sort: _sort,
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          itemCount: value.results.length,
                          itemBuilder: (context, index) => RequestListTile(
                            instanceId: widget.instanceId,
                            request: value.results[index],
                            onDeleted: () => ref.invalidate(
                              seerrRequestsProvider(
                                instanceId: widget.instanceId,
                                filter: _filter,
                                sort: _sort,
                              ),
                            ),
                          ),
                        ),
                      ),
              Err(:final error) => EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load requests',
                message: error.userMessage,
              ),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _FilterSortPill extends StatelessWidget {
  const _FilterSortPill({
    required this.icon,
    required this.label,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final Map<String, String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => items.entries
          .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      child: Chip(avatar: Icon(icon, size: 16), label: Text(label)),
    );
  }
}
