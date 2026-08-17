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

  Future<Result<List<QbitTorrent>>> listTorrents() async {
    final result = await _client.getTorrents();
    if (result is Err<List<QbitTorrent>> && result.error is AuthError) {
      final loginResult = await _ensureLoggedIn();
      if (loginResult is Err) return Err(loginResult.error);
      return _client.getTorrents();
    }
    return result;
  }

  Future<Result<QbitMainData>> getMainData() async {
    final result = await _client.getMainData();
    if (result is Err<QbitMainData> && result.error is AuthError) {
      final loginResult = await _ensureLoggedIn();
      if (loginResult is Err) return Err(loginResult.error);
      return _client.getMainData();
    }
    return result;
  }

  Future<Result<void>> pauseTorrents(List<String> hashes) async {
    return _authenticatedCall(() => _client.pauseTorrents(hashes));
  }

  Future<Result<void>> resumeTorrents(List<String> hashes) async {
    return _authenticatedCall(() => _client.resumeTorrents(hashes));
  }

  Future<Result<void>> deleteTorrents(List<String> hashes, {bool deleteFiles = false}) async {
    return _authenticatedCall(() => _client.deleteTorrents(hashes, deleteFiles: deleteFiles));
  }

  Future<Result<void>> addTorrent(String url) async {
    return _authenticatedCall(() => _client.addTorrent(url));
  }

  Future<Result<T>> _authenticatedCall<T>(Future<Result<T>> Function() call) async {
    final result = await call();
    if (result is Err<T> && result.error is AuthError) {
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
