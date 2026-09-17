/// One shared destructive-confirm dialog for all delete flows (README
/// §3g): a title, a body naming the real consequence, an optional
/// off-by-default "delete files" toggle, and Cancel/Remove actions.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:flutter/material.dart';

class ConfirmDialogResult {
  const ConfirmDialogResult({this.deleteFiles = false});

  final bool deleteFiles;
}

/// Shows the shared destructive-confirm dialog. Returns null if the user
/// cancels or dismisses it, or a [ConfirmDialogResult] if they confirm.
Future<ConfirmDialogResult?> showDestructiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Remove',
  bool showDeleteFilesToggle = false,
  String deleteFilesTitle = 'Also delete files on disk',
  String? deleteFilesSubtitle,
}) {
  return showDialog<ConfirmDialogResult>(
    context: context,
    builder: (context) => _ConfirmDialog(
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      confirmLabel: confirmLabel,
      showDeleteFilesToggle: showDeleteFilesToggle,
      deleteFilesTitle: deleteFilesTitle,
      deleteFilesSubtitle: deleteFilesSubtitle,
    ),
  );
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.showDeleteFilesToggle,
    required this.deleteFilesTitle,
    required this.deleteFilesSubtitle,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool showDeleteFilesToggle;
  final String deleteFilesTitle;
  final String? deleteFilesSubtitle;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _deleteFiles = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surface : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTypography.sectionTitle.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              widget.message,
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.n400 : colorScheme.onSurfaceVariant,
              ),
            ),
            if (widget.showDeleteFilesToggle) ...[
              const SizedBox(height: AppSpacing.space4),
              LabeledToggleRow(
                title: widget.deleteFilesTitle,
                subtitle: widget.deleteFilesSubtitle ?? '',
                value: _deleteFiles,
                onChanged: (value) => setState(() => _deleteFiles = value),
              ),
            ],
            const SizedBox(height: AppSpacing.space6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.n400
                          : colorScheme.onSurfaceVariant,
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Text(widget.cancelLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      ConfirmDialogResult(deleteFiles: _deleteFiles),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.down,
                      side: const BorderSide(color: AppColors.down),
                    ),
                    child: Text(widget.confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
