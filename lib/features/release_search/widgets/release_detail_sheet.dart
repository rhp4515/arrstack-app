/// Bottom sheet showing one release in full, with the single "Download"
/// (or "Force download") confirmation that grabs it.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the release detail sheet. On a successful grab: closes the sheet,
/// pops the current route if possible, and shows a confirmation snackbar.
Future<void> showReleaseDetailSheet(
  BuildContext context, {
  required ReleaseCandidate release,
  required ServiceType service,
  required String instanceId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReleaseDetailSheet(
      release: release,
      service: service,
      instanceId: instanceId,
    ),
  );
}

class _ReleaseDetailSheet extends ConsumerStatefulWidget {
  const _ReleaseDetailSheet({
    required this.release,
    required this.service,
    required this.instanceId,
  });

  final ReleaseCandidate release;
  final ServiceType service;
  final String instanceId;

  @override
  ConsumerState<_ReleaseDetailSheet> createState() =>
      _ReleaseDetailSheetState();
}

class _ReleaseDetailSheetState extends ConsumerState<_ReleaseDetailSheet> {
  bool _grabbing = false;
  String? _error;

  ReleaseCandidate get r => widget.release;
  bool get _isForce => r.isRejected || !r.downloadAllowed;

  Future<void> _grab() async {
    setState(() {
      _grabbing = true;
      _error = null;
    });

    final Result<void> result;
    if (widget.service == ServiceType.sonarr) {
      final repo = await ref.read(
        sonarrRepositoryProvider(widget.instanceId).future,
      );
      result = await repo.grabRelease(guid: r.guid, indexerId: r.indexerId);
    } else if (widget.service == ServiceType.radarr) {
      final repo = await ref.read(
        radarrRepositoryProvider(widget.instanceId).future,
      );
      result = await repo.grabRelease(guid: r.guid, indexerId: r.indexerId);
    } else {
      result = const Err(UnknownError(userMessage: 'Unsupported service.'));
    }

    if (!mounted) {
      return;
    }

    switch (result) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);
        navigator.pop(); // close the sheet
        if (navigator.canPop()) {
          navigator.pop(); // close the search page
        }
        messenger.showSnackBar(
          SnackBar(content: Text('Sent to ${r.indexerName} — check Downloads')),
        );
      case Err(:final error):
        setState(() {
          _grabbing = false;
          _error = error.statusCode == 404
              ? 'This release is no longer available on the server — '
                    'search again.'
              : error.userMessage;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, String)>[
      ('Indexer', r.indexerName),
      ('Quality', r.qualityLabel),
      ('Size', FormatUtils.formatBytes(r.sizeBytes)),
      if (r.protocol == ReleaseProtocol.torrent)
        ('Seeders / Leechers', '${r.seeders ?? '—'} / ${r.leechers ?? '—'}'),
      ('Age', FormatUtils.formatReleaseAge(r.ageMinutes)),
      ('Protocol', r.protocol.name),
      if (r.releaseGroup != null && r.releaseGroup!.isNotEmpty)
        ('Release group', r.releaseGroup!),
      if (r.customFormatScore != null)
        ('Custom format score', '${r.customFormatScore}'),
    ];

    return PopScope(
      canPop: !_grabbing,
      child: SafeArea(
        child: Padding(
          padding: AppInsets.pageMd,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        r.title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final (label, value) in rows)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  label,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (r.rejections.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Rejected because',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        for (final reason in r.rejections)
                          Text(
                            '• $reason',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _grabbing ? null : _grab,
                  style: _isForce
                      ? FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                        )
                      : null,
                  child: _grabbing
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isForce ? 'Force download' : 'Download'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
