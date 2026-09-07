/// Repository for Bazarr service logic.
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/bazarr/bazarr_client.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';

class BazarrRepository {
  const BazarrRepository(this._client);

  final BazarrClient _client;

  Future<Result<List<BazarrWantedSubtitle>>> listWantedEpisodes() =>
      _client.getWantedEpisodes();

  Future<Result<List<BazarrWantedSubtitle>>> listWantedMovies() =>
      _client.getWantedMovies();

  Future<Result<void>> searchSubtitle(BazarrWantedSubtitle subtitle) {
    if (subtitle.type == 'movie' && subtitle.radarrId != null) {
      return _client.searchMovieSubtitles(subtitle.radarrId!);
    } else if (subtitle.type == 'episode' && subtitle.episodeId != null) {
      return _client.searchEpisodeSubtitles(subtitle.episodeId!);
    }
    return Future.value(
      const Err(ValidationError(userMessage: 'Invalid subtitle item.')),
    );
  }

  Future<Result<void>> searchAllSubtitles() => _client.searchAllSubtitles();

  Future<Result<BazarrSystemStatus>> getStatus() => _client.getSystemStatus();
}
