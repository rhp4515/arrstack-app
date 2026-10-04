/// Removes a torrent and blocklists its release in the Radarr/Sonarr that
/// grabbed it, so a fake release (an `.exe` posing as a movie) is cleaned up
/// *and* never picked again.
///
/// The torrent is matched to a queue item by `downloadId`, which is the
/// torrent hash for qBittorrent. Deleting that queue item with
/// `blocklist=true&removeFromClient=true` makes the arr blocklist the
/// release, tell qBittorrent to drop it and its files, and search for a
/// replacement.
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
  const _QueueMatch({
    required this.instance,
    required this.queueIds,
    required this.delete,
  });

  final ServiceInstance instance;
  final List<int> queueIds;
  final Future<Result<void>> Function(int id, {required bool removeFromClient})
  delete;
}

Future<BlocklistOutcome> removeAndBlocklistTorrent(
  WidgetRef ref, {
  required String instanceId,
  required QbitTorrent torrent,
}) async {
  final instancesResult = await ref.read(instancesProvider.future);
  final instances = switch (instancesResult) {
    Ok(:final value) =>
      value
          .where(
            (i) =>
                i.serviceType == ServiceType.radarr ||
                i.serviceType == ServiceType.sonarr,
          )
          .toList(),
    Err() => const <ServiceInstance>[],
  };

  _QueueMatch? match;
  final unreachable = <String>[];
  for (final instance in instances) {
    try {
      final found = await _findInQueue(ref, instance, torrent);
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
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    final removed = await repository.deleteTorrents([
      torrent.hash,
    ], deleteFiles: true);
    ref.invalidate(qbitTorrentsProvider(instanceId));
    return switch (removed) {
      Ok() => const RemovedWithoutBlocklist(),
      Err(:final error) => BlocklistFailed(error.userMessage),
    };
  }

  // A season pack is one torrent with a queue item per episode. Blocklist
  // each, and remove from the client with the last so the others still
  // exist when we get to them.
  final ids = match.queueIds;
  for (var i = 0; i < ids.length; i++) {
    final result = await match.delete(
      ids[i],
      removeFromClient: i == ids.length - 1,
    );
    if (result case Err(:final error)) {
      return BlocklistFailed(error.userMessage);
    }
  }

  ref.invalidate(qbitTorrentsProvider(instanceId));
  if (match.instance.serviceType == ServiceType.radarr) {
    ref.invalidate(radarrQueueProvider(match.instance.id));
  } else {
    ref.invalidate(sonarrQueueProvider(match.instance.id));
  }
  return Blocklisted(match.instance.name);
}

/// The queue items of [instance] that belong to [torrent], or null when it
/// has none. Throws when the instance can't be reached.
Future<_QueueMatch?> _findInQueue(
  WidgetRef ref,
  ServiceInstance instance,
  QbitTorrent torrent,
) async {
  if (instance.serviceType == ServiceType.radarr) {
    final repository = await ref.read(
      radarrRepositoryProvider(instance.id).future,
    );
    final queue = switch (await repository.listQueue()) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
    final ids = [
      for (final item in queue)
        if (queueItemIsTorrent(item.downloadId, torrent)) item.id,
    ];
    if (ids.isEmpty) return null;
    return _QueueMatch(
      instance: instance,
      queueIds: ids,
      delete: (id, {required removeFromClient}) => repository.deleteQueueItem(
        id,
        removeFromClient: removeFromClient,
        blocklist: true,
      ),
    );
  }

  final repository = await ref.read(
    sonarrRepositoryProvider(instance.id).future,
  );
  final queue = switch (await repository.listQueue()) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };
  final ids = [
    for (final item in queue)
      if (queueItemIsTorrent(item.downloadId, torrent)) item.id,
  ];
  if (ids.isEmpty) return null;
  return _QueueMatch(
    instance: instance,
    queueIds: ids,
    delete: (id, {required removeFromClient}) => repository.deleteQueueItem(
      id,
      removeFromClient: removeFromClient,
      blocklist: true,
    ),
  );
}
