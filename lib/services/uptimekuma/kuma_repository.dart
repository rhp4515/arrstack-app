/// Repository for Uptime Kuma logic.
library;

import 'dart:async';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/uptimekuma/kuma_client.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';

class KumaRepository {
  KumaRepository(this._client, this._credential);

  final KumaClient _client;
  final ServiceCredential _credential;

  Stream<Map<int, KumaMonitor>> get monitorsStream => _client.monitorsStream;
  Stream<KumaHeartbeat> get heartbeatStream => _client.heartbeatStream;
  Stream<bool> get connectionStream => _client.connectionStream;

  Future<Result<void>> ensureConnected() async {
    _client.connect();
    
    // Wait for connection
    final isConnected = await _client.connectionStream.firstWhere((c) => c).timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );

    if (!isConnected) {
      return const Err(NetworkError(userMessage: 'Failed to connect to socket.'));
    }

    return switch (_credential) {
      ApiKeyCredential(:final apiKey) => _client.loginWithApiKey(apiKey),
      UsernamePasswordCredential(:final username, :final password) =>
        _client.login(username, password),
    };
  }

  void disconnect() {
    _client.disconnect();
  }
}
