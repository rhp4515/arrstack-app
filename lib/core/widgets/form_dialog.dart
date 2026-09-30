/// The shell for dialogs that collect input (a passphrase, a name): the
/// same look as the destructive confirm dialog — [AppRadius.lg] corners,
/// a section title, two equal outlined buttons with a muted cancel — but
/// with caller-supplied content and an accent confirm action.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class FormDialog extends StatelessWidget {
  const FormDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.busy = false,
    super.key,
  });

  final String title;
  final Widget content;
  final String confirmLabel;
  final String cancelLabel;

  /// Called when the confirm button is pressed. The caller decides whether
  /// to pop the dialog (with a result) or keep it open.
  final VoidCallback onConfirm;

  /// While true both buttons are disabled (a request is in flight).
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : colorScheme.primary;

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
              title,
              style: AppTypography.sectionTitle.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            Flexible(child: SingleChildScrollView(child: content)),
            const SizedBox(height: AppSpacing.space6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.n400
                          : colorScheme.onSurfaceVariant,
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy ? null : onConfirm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accent,
                      side: BorderSide(color: accent),
                    ),
                    child: Text(confirmLabel),
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
