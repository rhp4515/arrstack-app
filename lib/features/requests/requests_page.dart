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
      child: ListView(
        padding: AppInsets.pageMd,
        children: [
          if (filter != RequestsFilter.availableOnly) ...[
            Row(
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
            const SizedBox(height: AppSpacing.space6),
          ],
          if (pending.isEmpty && progress.isEmpty && available.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.space8),
              child: EmptyState(
                icon: Icons.inbox_outlined,
                title: 'No requests',
              ),
            ),
          if (pending.isNotEmpty) ...[
            Text(
              'NEEDS A DECISION · ${pending.length}',
              style: AppTypography.kicker,
            ),
            const SizedBox(height: AppSpacing.space4),
            for (final request in pending)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: RequestCard(
                  key: ValueKey(request.id),
                  instanceId: instanceId,
                  request: request,
                  onDecided: refresh,
                ),
              ),
            const SizedBox(height: AppSpacing.space6),
          ],
          if (progress.isNotEmpty) ...[
            Text(
              'IN PROGRESS · ${progress.length}',
              style: AppTypography.kicker,
            ),
            const SizedBox(height: AppSpacing.space4),
            for (final request in progress)
              InProgressRow(
                key: ValueKey(request.id),
                instanceId: instanceId,
                request: request,
              ),
            const SizedBox(height: AppSpacing.space6),
          ],
          if (available.isNotEmpty) ...[
            for (final request in available)
              InProgressRow(
                key: ValueKey(request.id),
                instanceId: instanceId,
                request: request,
              ),
          ],
          if (filter == RequestsFilter.all && stats.available > 0)
            InkWell(
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
                    const Icon(PhosphorIconsRegular.caretRight, size: 14),
                  ],
                ),
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
