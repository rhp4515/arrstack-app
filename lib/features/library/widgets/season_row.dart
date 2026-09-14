/// Collapsible season row and its indented episode rows (spec 2e
/// "SEASONS"). Replaces the old `_SeasonTile`/`_SeasonEpisodes`/
/// `_EpisodeCard`/`_CountPill` private classes.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SeasonRow extends StatefulWidget {
  const SeasonRow({
    required this.label,
    required this.have,
    required this.total,
    required this.episodes,
    this.initiallyExpanded = false,
    super.key,
  });

  final String label;
  final int have;
  final int total;
  final Widget Function(BuildContext) episodes;
  final bool initiallyExpanded;

  @override
  State<SeasonRow> createState() => _SeasonRowState();
}

class _SeasonRowState extends State<SeasonRow> {
  late bool _expanded = widget.initiallyExpanded;

  Color _countColor() {
    if (widget.total > 0 && widget.have >= widget.total) return AppColors.up;
    if (widget.have == 0) return AppColors.down;
    return AppColors.a300;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = widget.total > 0 ? widget.have / widget.total : 0.0;
    final countColor = _countColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
            child: Row(
              children: [
                Icon(
                  _expanded
                      ? PhosphorIconsRegular.caretDown
                      : PhosphorIconsRegular.caretRight,
                  size: 12,
                  color: _expanded ? colorScheme.primary : AppColors.n500,
                ),
                const SizedBox(width: AppSpacing.space2),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppTypography.cardTitle.copyWith(
                      color: _expanded
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.n800,
                      valueColor: AlwaysStoppedAnimation(countColor),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space2),
                SizedBox(
                  width: 38,
                  child: Text(
                    '${widget.have}/${widget.total}',
                    textAlign: TextAlign.right,
                    style: AppTypography.meta.copyWith(
                      color: countColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Builder(builder: widget.episodes),
          ),
      ],
    );
  }
}

class EpisodeRow extends StatelessWidget {
  const EpisodeRow({
    required this.code,
    required this.title,
    required this.hasFile,
    required this.qualityLabel,
    super.key,
  });

  final String code;
  final String title;
  final bool hasFile;
  final String? qualityLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = hasFile ? colorScheme.onSurface : AppColors.n500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              code,
              style: AppTypography.meta.copyWith(
                color: hasFile ? colorScheme.primary : AppColors.n500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle.copyWith(color: textColor),
            ),
          ),
          if (hasFile && qualityLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.n900,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                qualityLabel!,
                style: AppTypography.meta.copyWith(color: AppColors.n300),
              ),
            )
          else if (!hasFile)
            Text(
              'Missing',
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
        ],
      ),
    );
  }
}
