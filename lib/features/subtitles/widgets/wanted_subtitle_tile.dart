/// A tile for a wanted subtitle item (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WantedSubtitleTile extends ConsumerStatefulWidget {
  const WantedSubtitleTile({
    required this.instanceId,
    required this.subtitle,
    super.key,
  });

  final String instanceId;
  final BazarrWantedSubtitle subtitle;

  @override
  ConsumerState<WantedSubtitleTile> createState() => _WantedSubtitleTileState();
}

class _WantedSubtitleTileState extends ConsumerState<WantedSubtitleTile> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.subtitle;
    final isEpisode = item.type == 'episode';

    return Card(
      margin: const EdgeInsets.only(bottom: LegacySpacing.sm),
      child: ListTile(
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEpisode && item.seriesTitle != null)
              Text(
                '${item.seriesTitle} - S${item.seasonNumber}E${item.episodeNumber}',
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: item.languages
                  .map((l) => _LanguageChip(label: l))
                  .toList(),
            ),
          ],
        ),
        trailing: _isSearching
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: _triggerSearch,
                tooltip: 'Search Subtitle',
              ),
      ),
    );
  }

  Future<void> _triggerSearch() async {
    setState(() => _isSearching = true);
    final repository = await ref.read(
      bazarrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repository.searchSubtitle(widget.subtitle);

    if (mounted) {
      setState(() => _isSearching = false);
      if (result.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search triggered for ${widget.subtitle.title}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${result.errorOrNull?.userMessage}'),
          ),
        );
      }
    }
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
