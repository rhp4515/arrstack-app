/// Repository for qBittorrent service logic.
///
/// Orchestrates session login and data fetching, handling session persistence
/// across calls (spec §6).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_client.dart';

class QbitRepository {
  QbitRepository(this._client, this._credential);

  final QbitClient _client;
  final ServiceCredential _credential;

  Future<Result<List<QbitTorrent>>> listTorrents() =>
      _authenticatedCall(_client.getTorrents);

  Future<Result<QbitMainData>> getMainData() =>
      _authenticatedCall(_client.getMainData);

  Future<Result<void>> stopTorrents(List<String> hashes) async {
    return _authenticatedCall(() => _client.stopTorrents(hashes));
  }

  Future<Result<void>> startTorrents(List<String> hashes) async {
    return _authenticatedCall(() => _client.startTorrents(hashes));
  }

  Future<Result<void>> deleteTorrents(List<String> hashes, {bool deleteFiles = false}) async {
    return _authenticatedCall(() => _client.deleteTorrents(hashes, deleteFiles: deleteFiles));
  }

  Future<Result<void>> addTorrent(String url) async {
    return _authenticatedCall(() => _client.addTorrent(url));
  }

  Future<Result<T>> _authenticatedCall<T>(
    Future<Result<T>> Function() call,
  ) async {
    // Proactively log in if using cookie-based username/password auth and no session exists yet.
    if (_credential is UsernamePasswordCredential && !_client.hasSession) {
      final loginResult = await _ensureLoggedIn();
      if (loginResult is Err) return Err(loginResult.error);
    }

    final result = await call();
    // Only a cookie session can be recovered by logging in again. API-key
    // (Bearer) auth is stateless, so an AuthError there means a bad/missing
    // key — retrying login is pointless and can trip qBittorrent's
    // failed-attempt IP ban, so surface the error directly instead.
    if (result is Err<T> &&
        result.error is AuthError &&
        _credential is UsernamePasswordCredential) {
      final loginResult = await _ensureLoggedIn();
      if (loginResult is Err) return Err(loginResult.error);
      return call();
    }
    return result;
  }

  Future<Result<void>> _ensureLoggedIn() async {
    final cred = _credential;
    if (cred is! UsernamePasswordCredential) {
      return const Err(AuthError(userMessage: 'qBittorrent requires username and password.'));
    }
    return _client.login(cred.username, cred.password);
  }
}
