/// Repository for Uptime Kuma logic.
library;

import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/uptimekuma/kuma_client.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';

class KumaRepository {
  KumaRepository(
    this._client,
    this._credential, {
    this.connectTimeout = const Duration(seconds: 5),
  });

  final KumaClient _client;
  final ServiceCredential _credential;

  /// How long the Socket.IO handshake gets. Kuma doesn't go through Dio, so
  /// it can't inherit [DioFactory]'s profiles — the provider passes the
  /// matching budget instead, which matters over Tailscale where a cold
  /// tunnel can eat most of the default 5s before the socket even opens.
  final Duration connectTimeout;

  Stream<Map<int, KumaMonitor>> get monitorsStream => _client.monitorsStream;
  Stream<KumaHeartbeat> get heartbeatStream => _client.heartbeatStream;
  Stream<bool> get connectionStream => _client.connectionStream;

  Future<Result<void>> ensureConnected() async {
    // On a retry the socket is often already open; `connectionStream` is a
    // broadcast stream with no buffered value, so awaiting `firstWhere` here
    // would hang until the connect timeout and fail. Only wait when not
    // connected.
    if (!_client.isConnected) {
      _client.connect();

      final isConnected = await _client.connectionStream
          .firstWhere((c) => c)
          .timeout(connectTimeout, onTimeout: () => false);

      if (!isConnected) {
        return const Err(
          NetworkError(userMessage: 'Failed to connect to socket.'),
        );
      }
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
