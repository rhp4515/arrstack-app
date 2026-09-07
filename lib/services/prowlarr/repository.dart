import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/prowlarr/client.dart';
import 'package:arrstack/services/prowlarr/models/indexer.dart';
import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';

class ProwlarrRepository {
  final ProwlarrClient _client;

  ProwlarrRepository(this._client);

  Future<Result<List<Indexer>>> getIndexers() => _client.getIndexers();

  Future<Result<IndexerStatsResponse>> getIndexerStats() => _client.getIndexerStats();
}
