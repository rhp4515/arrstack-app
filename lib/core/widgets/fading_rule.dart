/// A 1px divider that fades to transparent at both ends (README "Shared
/// shell" -> "Fading rules"). Used between list rows and detail sections
/// instead of a solid Divider.
library;

import 'package:flutter/material.dart';

class FadingRule extends StatelessWidget {
  const FadingRule({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            divider.withValues(alpha: 0),
            divider,
            divider,
            divider.withValues(alpha: 0),
          ],
          // Fixed stop fractions approximating the spec's fixed 48px
          // fade-in on this app's full-bleed row widths. Not meant to be
          // configurable — FadingRule is always used at consistent widths.
          stops: const [0, 0.14, 0.86, 1],
        ),
      ),
    );
  }
}
