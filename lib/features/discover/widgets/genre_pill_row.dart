/// Horizontally-scrollable row of outlined pill buttons for genre browsing —
/// mirrors the "Movie Genres"/"Series Genres" rows in the Nocturne Discover
/// spec: a single accent-purple outline and text, no per-pill color coding.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

class GenrePillRow extends StatelessWidget {
  const GenrePillRow({required this.genres, required this.onTap, super.key});

  final List<SeerrGenre> genres;
  final ValueChanged<SeerrGenre> onTap;

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
          return Padding(
            padding: const EdgeInsets.only(right: LegacySpacing.sm),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () => onTap(genre),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.accent),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: LegacySpacing.lg,
                    vertical: LegacySpacing.md,
                  ),
                  child: Center(
                    child: Text(
                      genre.name,
                      style: const TextStyle(
                        color: AppColors.accent,
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
