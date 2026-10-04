/// Removes a torrent and blocklists its release in the Radarr/Sonarr that
/// grabbed it, so a fake release (an `.exe` posing as a movie) is cleaned up
/// *and* never picked again.
///
/// The torrent is matched to a queue item by `downloadId`, which is the
/// torrent hash for qBittorrent. Deleting that queue item with
/// `blocklist=true&removeFromClient=true` makes the arr blocklist the
/// release, tell qBittorrent to drop it and its files, and search for a
/// replacement.
///
/// Works on a [ProviderContainer] rather than a widget's `ref`: the sheet
/// that starts it can be closed while the requests are in flight, and a
/// disposed widget's `ref` throws on its next use.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class BlocklistOutcome {
  const BlocklistOutcome();
}

/// The release was blocklisted in [serviceName] and the torrent removed.
class Blocklisted extends BlocklistOutcome {
  const Blocklisted(this.serviceName);

  final String serviceName;
}

/// No Radarr/Sonarr queue knows this torrent (added by hand, or already
/// imported and cleared), so there was nothing to blocklist; it was only
/// removed from qBittorrent.
class RemovedWithoutBlocklist extends BlocklistOutcome {
  const RemovedWithoutBlocklist();
}

/// Nothing was removed.
class BlocklistFailed extends BlocklistOutcome {
  const BlocklistFailed(this.message);

  final String message;
}

/// Whether [downloadId] from a queue item is [torrent]'s hash. qBittorrent
/// reports the hash lower-case; Radarr/Sonarr upper-case it.
bool queueItemIsTorrent(String? downloadId, QbitTorrent torrent) =>
    downloadId != null &&
    downloadId.isNotEmpty &&
    downloadId.toLowerCase() == torrent.hash.toLowerCase();

class _QueueMatch {
  const _QueueMatch({required this.instance, required this.delete});

  final ServiceInstance instance;

  /// Blocklists the release and removes the download from the client.
  final Future<Result<void>> Function() delete;
}

Future<BlocklistOutcome> removeAndBlocklistTorrent(
  ProviderContainer container, {
  required String instanceId,
  required QbitTorrent torrent,
}) async {
  final instancesResult = await container.read(instancesProvider.future);
  // Without the instance list we can't tell "not tracked" from "couldn't
  // look", so removing the torrent would forfeit the blocklist.
  if (instancesResult case Err(:final error)) {
    return BlocklistFailed(
      "Couldn't read your configured services, so nothing was removed. "
      '${error.userMessage}',
    );
  }
  final instances = [
    for (final i in (instancesResult as Ok<List<ServiceInstance>>).value)
      if (i.serviceType == ServiceType.radarr ||
          i.serviceType == ServiceType.sonarr)
        i,
  ];

  _QueueMatch? match;
  final unreachable = <String>[];
  for (final instance in instances) {
    try {
      final found = await _findInQueue(container, instance, torrent);
      if (found == null) continue;
      match = found;
      break;
    } on Object {
      unreachable.add(instance.name);
    }
  }

  if (match == null) {
    // Without a match we can't tell "not tracked" from "couldn't ask", and
    // removing the torrent now would throw away the chance to blocklist.
    if (unreachable.isNotEmpty) {
      return BlocklistFailed(
        "Couldn't check ${unreachable.join(', ')} for this release, so "
        'nothing was removed. Try again when it is reachable.',
      );
    }
    final repository = await container.read(
      qbitRepositoryProvider(instanceId).future,
    );
    final removed = await repository.deleteTorrents([
      torrent.hash,
    ], deleteFiles: true);
    container.invalidate(qbitTorrentsProvider(instanceId));
    return switch (removed) {
      Ok() => const RemovedWithoutBlocklist(),
      Err(:final error) => BlocklistFailed(error.userMessage),
    };
  }

  // One request covers a season pack too: its per-episode queue items share
  // one download, and the first delete stops the arr tracking all of them
  // (later ids 404), while blocklisting is by download, so every episode of
  // the release is blocklisted.
  final result = await match.delete();
  if (result case Err(:final error)) return BlocklistFailed(error.userMessage);

  container.invalidate(qbitTorrentsProvider(instanceId));
  if (match.instance.serviceType == ServiceType.radarr) {
    container.invalidate(radarrQueueProvider(match.instance.id));
  } else {
    container.invalidate(sonarrQueueProvider(match.instance.id));
  }
  return Blocklisted(match.instance.name);
}

/// The queue item of [instance] that belongs to [torrent], or null when it
/// has none. Throws when the instance can't be reached.
Future<_QueueMatch?> _findInQueue(
  ProviderContainer container,
  ServiceInstance instance,
  QbitTorrent torrent,
) async {
  if (instance.serviceType == ServiceType.radarr) {
    final repository = await container.read(
      radarrRepositoryProvider(instance.id).future,
    );
    final queue = switch (await repository.listQueue()) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
    final item = queue
        .where((i) => queueItemIsTorrent(i.downloadId, torrent))
        .firstOrNull;
    if (item == null) return null;
    return _QueueMatch(
      instance: instance,
      delete: () => repository.deleteQueueItem(
        item.id,
        removeFromClient: true,
        blocklist: true,
      ),
    );
  }

  final repository = await container.read(
    sonarrRepositoryProvider(instance.id).future,
  );
  final queue = switch (await repository.listQueue()) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };
  final item = queue
      .where((i) => queueItemIsTorrent(i.downloadId, torrent))
      .firstOrNull;
  if (item == null) return null;
  return _QueueMatch(
    instance: instance,
    delete: () => repository.deleteQueueItem(
      item.id,
      removeFromClient: true,
      blocklist: true,
    ),
  );
}
