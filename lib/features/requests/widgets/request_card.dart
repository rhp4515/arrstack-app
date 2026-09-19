/// A "needs a decision" card (README §3c): poster, title, a type tag + a
/// fixed "Pending" tag, an attribution line, and inline Approve/Deny/Delete —
/// no overflow menu. Delete calls `deleteRequest` directly (rather than
/// Deny, which only marks the request declined server-side) so a pending
/// request can be fully removed from Seerr (README §3c final-review
/// finding: the redesign dropped the only `deleteRequest` caller). Every
/// request rendered here is pending by construction
/// (this page only places it in the "needs a decision" section), so
/// "Pending" is a fixed style rather than derived from
/// `mediaStatusPresentation`. The attribution line omits any quality-profile
/// fragment — `SeerrRequest` doesn't carry a profile name (Phase 7 design
/// spec, Decision 10) — rather than fabricating one.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/features/discover/utils/relative_time.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class RequestCard extends ConsumerStatefulWidget {
  const RequestCard({
    required this.instanceId,
    required this.request,
    required this.onDecided,
    super.key,
  });

  final String instanceId;
  final SeerrRequest request;
  final VoidCallback onDecided;

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final media = widget.request.media;
    final tmdbId = media?.tmdbId;
    final detailAsync = tmdbId == null
        ? null
        : ref.watch(
            seerrDetailProvider(
              instanceId: widget.instanceId,
              id: tmdbId,
              mediaType: media!.mediaType,
            ),
          );
    final detail = switch (detailAsync?.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final title = detail?.displayTitle ?? 'Request #${widget.request.id}';
    final posterUrl = detail?.posterUrl;
    final isTv = media?.mediaType == 'tv';

    return Container(
      padding: AppInsets.pageMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: posterUrl != null
                    ? Image.network(
                        posterUrl,
                        width: 44,
                        height: 66,
                        fit: BoxFit.cover,
                      )
                    : Container(width: 44, height: 66, color: AppColors.n800),
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.space2),
                    Wrap(
                      spacing: AppSpacing.space2,
                      children: [
                        _tag(
                          isTv ? 'TV' : 'Movie',
                          fill: AppColors.n900,
                          text: AppColors.n300,
                        ),
                        _tag(
                          'Pending',
                          fill: AppColors.a800,
                          text: AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      _attribution(widget.request),
                      style: AppTypography.meta.copyWith(color: AppColors.n500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          if (_error != null) ...[
            Text(
              _error!,
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
            const SizedBox(height: AppSpacing.space2),
          ],
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _decide(approve: true),
                // Deliberately not an indeterminate `CircularProgressIndicator`
                // while `_busy`: on success `_busy` stays true (the card is
                // expected to be removed once the parent reacts to
                // `onDecided`, and there's no "undo" once a decision is
                // made), and an indeterminate spinner left in the tree
                // schedules animation frames forever — which would leave a
                // still-mounted card (or a widget test's `pumpAndSettle`)
                // unable to ever settle. Disabling the buttons already
                // conveys the busy state; the icon itself doesn't need to
                // animate.
                icon: const Icon(
                  PhosphorIconsRegular.check,
                  size: 15,
                  color: AppColors.accent,
                ),
                label: const Text('Approve'),
              ),
              const SizedBox(width: AppSpacing.space3),
              OutlinedButton(
                onPressed: _busy ? null : () => _decide(approve: false),
                child: const Text('Deny'),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(PhosphorIconsRegular.trash, size: 16),
                tooltip: 'Delete request',
                color: AppColors.n500,
                onPressed: _busy ? null : _confirmDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _attribution(SeerrRequest request) {
    final name = request.requestedBy?.displayName ?? 'unknown';
    final createdAt = request.createdAt;
    if (createdAt == null) return 'by $name';
    return 'by $name · ${formatRelativeTime(createdAt)}';
  }

  Widget _tag(String label, {required Color fill, required Color text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _decide({required bool approve}) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final result = approve
        ? await repository.approveRequest(widget.request.id)
        : await repository.declineRequest(widget.request.id);

    if (!mounted) return;
    switch (result) {
      case Ok():
        // `_busy` intentionally stays true here — a decision, once made,
        // isn't reversible from this card, and the parent is expected to
        // remove the card once it reacts to `onDecided()`. Re-enabling the
        // buttons would only create a window to double-submit before that
        // removal happens.
        widget.onDecided();
      case Err(:final error):
        setState(() {
          _busy = false;
          _error = error.userMessage;
        });
    }
  }

  Future<void> _confirmDelete() async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Delete this request?',
      message:
          'This removes the request from Seerr. It will not remove '
          'any media already downloaded.',
      confirmLabel: 'Delete',
    );
    if (!mounted || result == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final deleteResult = await repository.deleteRequest(widget.request.id);

    if (!mounted) return;
    switch (deleteResult) {
      case Ok():
        widget.onDecided();
      case Err(:final error):
        setState(() {
          _busy = false;
          _error = error.userMessage;
        });
    }
  }
}
