/// Settings → Advanced → Clear cached data: drops the offline summaries
/// Home keeps for when services are unreachable, and every downloaded
/// poster/backdrop (disk and memory). Service configuration is untouched.
library;

import 'package:arrstack/core/storage/storage.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_clearing.g.dart';

/// Empties the artwork caches; swapped out in tests, which have no
/// platform file cache to empty.
typedef ArtworkCacheClearer = Future<void> Function();

Future<void> clearArtworkCaches() async {
  // CachedNetworkImage's default disk cache.
  await DefaultCacheManager().emptyCache();
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
}

@Riverpod(keepAlive: true)
ArtworkCacheClearer artworkCacheClearer(Ref ref) => clearArtworkCaches;

@riverpod
class CacheClearing extends _$CacheClearing {
  @override
  bool build() => false;

  /// Returns null on success, or a message saying what failed.
  Future<String?> clearAll() async {
    state = true;
    try {
      await ref.read(configStoreProvider).writeCachedSummaries(const []);
      ref.invalidate(cachedServiceSummariesProvider);
      await ref.read(artworkCacheClearerProvider)();
      return null;
    } on Object catch (error) {
      return 'Could not clear all cached data: $error';
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
