/// Horizontally-scrollable row of gradient pill buttons for genre browsing —
/// mirrors the "Movie Genres"/"Series Genres" rows in the Seerr Discover
/// mockup (example_mockups/seerr_discover_listview.jpeg).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

class GenrePillRow extends StatelessWidget {
  const GenrePillRow({required this.genres, required this.onTap, super.key});

  final List<SeerrGenre> genres;
  final ValueChanged<SeerrGenre> onTap;

  /// Fixed gradient palette cycled across pills, matching the varied
  /// pink/blue/purple gradients seen in the mockup (no per-genre backdrop
  /// image is used — flat gradients only).
  static const _gradients = [
    [Color(0xFFEC4899), Color(0xFFDB2777)],
    [Color(0xFF3B82F6), Color(0xFF2563EB)],
    [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    [Color(0xFFF97316), Color(0xFFEA580C)],
    [Color(0xFF10B981), Color(0xFF059669)],
  ];

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppInsets.screenHorizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final gradient = _gradients[index % _gradients.length];
          return Padding(
            padding: const EdgeInsets.only(right: LegacySpacing.sm),
            child: Material(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () => onTap(genre),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    gradient: LinearGradient(colors: gradient),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: LegacySpacing.lg,
                    vertical: LegacySpacing.md,
                  ),
                  child: Center(
                    child: Text(
                      genre.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
