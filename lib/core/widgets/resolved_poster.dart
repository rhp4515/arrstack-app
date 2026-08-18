/// A fixed-size, rounded poster thumbnail that resolves its image URL through
/// the service-appropriate provider (signing relative URLs, passing remote CDN
/// URLs through) and renders a cached image with a graceful fallback.
///
/// Shared by the Calendar rows and the Library list rows so poster loading
/// behaves identically everywhere.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResolvedPoster extends ConsumerWidget {
  const ResolvedPoster({
    required this.service,
    required this.instanceId,
    required this.relativeUrl,
    required this.width,
    required this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String? relativeUrl;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = relativeUrl;
    final AsyncValue<String?> urlAsync = switch (url) {
      null => const AsyncData<String?>(null),
      _ => switch (service) {
        ServiceType.sonarr => ref.watch(
          sonarrFullImageUrlProvider(instanceId: instanceId, relativeUrl: url),
        ),
        _ => ref.watch(
          radarrFullImageUrlProvider(instanceId: instanceId, relativeUrl: url),
        ),
      },
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: urlAsync.maybeWhen(
          data: (resolved) => (resolved == null || resolved.isEmpty)
              ? const _PosterFallback()
              : CachedNetworkImage(
                  imageUrl: resolved,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const _PosterFallback(),
                  errorWidget: (_, _, _) => const _PosterFallback(),
                ),
          orElse: () => const _PosterFallback(),
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}
