/// The Requests queue (README §3c): pending/processing/available stats,
/// "needs a decision" cards with inline Approve/Deny, and a compact
/// in-progress list. Fetches every request via `seerrAllRequestsProvider`
/// and buckets client-side (`requests_bucketing.dart`) rather than relying
/// on an unverified server-side filter vocabulary — Phase 7 design spec,
/// Decision 7.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/requests/requests_bucketing.dart';
import 'package:arrstack/features/requests/widgets/in_progress_row.dart';
import 'package:arrstack/features/requests/widgets/request_card.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum RequestsFilter { all, pendingOnly, availableOnly }

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({this.initialFilter = RequestsFilter.all, super.key});

  final RequestsFilter initialFilter;

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  late RequestsFilter _filter = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    final instanceIdAsync = ref.watch(selectedSeerrInstanceIdProvider);

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'SEERR',
        title: 'Requests',
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIconsRegular.funnel,
              size: 17,
              color: _filter == RequestsFilter.pendingOnly
                  ? AppColors.accent
                  : null,
            ),
            tooltip: 'Show pending only',
            onPressed: () => setState(() {
              _filter = _filter == RequestsFilter.pendingOnly
                  ? RequestsFilter.all
                  : RequestsFilter.pendingOnly;
            }),
          ),
        ],
      ),
      body: instanceIdAsync.when(
        data: (id) => id == null
            ? const EmptyState(
                icon: Icons.error_outline,
                title: 'No instance selected',
              )
            : _RequestsBody(instanceId: id, filter: _filter),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _RequestsBody extends ConsumerWidget {
  const _RequestsBody({required this.instanceId, required this.filter});

  final String instanceId;
  final RequestsFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(seerrAllRequestsProvider(instanceId));

    return requestsAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _RequestsList(
          instanceId: instanceId,
          requests: value,
          filter: filter,
        ),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load requests',
          message: error.userMessage,
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Unexpected error: $err')),
    );
  }
}

class _RequestsList extends ConsumerWidget {
  const _RequestsList({
    required this.instanceId,
    required this.requests,
    required this.filter,
  });

  final String instanceId;
  final List<SeerrRequest> requests;
  final RequestsFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = requestStats(requests);
    final pending = filter == RequestsFilter.availableOnly
        ? const <SeerrRequest>[]
        : needsDecision(requests);
    final progress = filter == RequestsFilter.all
        ? inProgress(requests)
        : const <SeerrRequest>[];
    final available = filter == RequestsFilter.availableOnly
        ? availableRequests(requests)
        : const <SeerrRequest>[];

    void refresh() => ref.invalidate(seerrAllRequestsProvider(instanceId));

    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppInsets.pageMd,
            sliver: SliverMainAxisGroup(
              slivers: [
                if (filter != RequestsFilter.availableOnly) ...[
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        _Stat(
                          value: '${stats.pending}',
                          label: 'PENDING',
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: AppSpacing.space8),
                        _Stat(
                          value: '${stats.processing}',
                          label: 'PROCESSING',
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSpacing.space8),
                        _Stat(
                          value: '${stats.available}',
                          label: 'AVAILABLE',
                          color: AppColors.up,
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.space6),
                  ),
                ],
                if (pending.isEmpty && progress.isEmpty && available.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.space8,
                      ),
                      child: EmptyState(
                        icon: Icons.inbox_outlined,
                        title: 'No requests',
                      ),
                    ),
                  ),
                if (pending.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Text(
                      'NEEDS A DECISION · ${pending.length}',
                      style: AppTypography.kicker,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.space4),
                  ),
                  SliverList.builder(
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final request = pending[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space3,
                        ),
                        child: RequestCard(
                          key: ValueKey(request.id),
                          instanceId: instanceId,
                          request: request,
                          onDecided: refresh,
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.space6),
                  ),
                ],
                if (progress.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Text(
                      'IN PROGRESS · ${progress.length}',
                      style: AppTypography.kicker,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.space4),
                  ),
                  SliverList.builder(
                    itemCount: progress.length,
                    itemBuilder: (context, index) {
                      final request = progress[index];
                      return InProgressRow(
                        key: ValueKey(request.id),
                        instanceId: instanceId,
                        request: request,
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.space6),
                  ),
                ],
                if (available.isNotEmpty)
                  SliverList.builder(
                    itemCount: available.length,
                    itemBuilder: (context, index) {
                      final request = available[index];
                      return InProgressRow(
                        key: ValueKey(request.id),
                        instanceId: instanceId,
                        request: request,
                      );
                    },
                  ),
                if (filter == RequestsFilter.all && stats.available > 0)
                  SliverToBoxAdapter(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RequestsPage(
                            initialFilter: RequestsFilter.availableOnly,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${stats.available} available requests',
                              style: AppTypography.body,
                            ),
                            const Icon(
                              PhosphorIconsRegular.caretRight,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.statNumeral.copyWith(color: color)),
        Text(label, style: AppTypography.statCaption),
      ],
    );
  }
}
