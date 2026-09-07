/// Socket.io client for Uptime Kuma.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class KumaClient {
  KumaClient({required this.baseUrl});

  final String baseUrl;
  io.Socket? _socket;

  final _monitorsController =
      StreamController<Map<int, KumaMonitor>>.broadcast();
  final _heartbeatController = StreamController<KumaHeartbeat>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<Map<int, KumaMonitor>> get monitorsStream =>
      _monitorsController.stream;
  Stream<KumaHeartbeat> get heartbeatStream => _heartbeatController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Whether the underlying socket is currently connected. Callers use this to
  /// avoid awaiting a fresh `connect()` handshake that will never re-fire on an
  /// already-open socket.
  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket != null && _socket!.connected) return;

    developer.log('Connecting socket to $baseUrl', name: 'arrstack.kuma');

    // Allow polling as a fallback: websocket-only fails behind reverse proxies
    // that don't forward the Upgrade handshake, a common self-host setup.
    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      developer.log('Socket connected successfully', name: 'arrstack.kuma');
      _connectionController.add(true);
    });

    _socket!.onDisconnect((reason) {
      developer.log('Socket disconnected: $reason', name: 'arrstack.kuma');
      _connectionController.add(false);
    });

    _socket!.onConnectError((err) {
      developer.log(
        'Kuma Socket Connect Error: $err',
        name: 'arrstack.kuma',
        error: err,
      );
      _connectionController.add(false);
    });

    _socket!.on('monitorList', (data) {
      if (data is Map) {
        developer.log('Received monitorList (${data.length} items)', name: 'arrstack.kuma');
        final monitors = data.map((key, value) {
          final id = int.parse(key.toString());
          return MapEntry(
            id,
            KumaMonitor.fromJson(value as Map<String, dynamic>),
          );
        });
        _monitorsController.add(monitors);
      }
    });

    _socket!.on('heartbeat', (data) {
      if (data is Map) {
        final heartbeat = KumaHeartbeat.fromJson(data as Map<String, dynamic>);
        _heartbeatController.add(heartbeat);
      }
    });

    _socket!.connect();
  }

  Future<Result<void>> loginWithApiKey(String apiKey) async {
    final completer = Completer<Result<void>>();

    if (_socket == null || !_socket!.connected) {
      return const Err(NetworkError(userMessage: 'Socket not connected.'));
    }

    _socket!.emitWithAck(
      'login',
      {'apiKey': apiKey},
      ack: (response) {
        if (response is Map && response['ok'] == true) {
          developer.log('API Key login successful', name: 'arrstack.kuma');
          completer.complete(const Ok(null));
        } else {
          developer.log('API Key login failed: $response', name: 'arrstack.kuma');
          completer.complete(
            const Err(AuthError(userMessage: 'API Key login failed.')),
          );
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => const Err(NetworkError(isTimeout: true)),
    );
  }

  Future<Result<void>> login(String username, String password) async {
    final completer = Completer<Result<void>>();

    if (_socket == null || !_socket!.connected) {
      return const Err(NetworkError(userMessage: 'Socket not connected.'));
    }

    _socket!.emitWithAck(
      'login',
      {'username': username, 'password': password},
      ack: (response) {
        if (response is Map && response['ok'] == true) {
          developer.log('Username/password login successful', name: 'arrstack.kuma');
          completer.complete(const Ok(null));
        } else {
          developer.log('Username/password login failed: $response', name: 'arrstack.kuma');
          completer.complete(
            const Err(AuthError(userMessage: 'Login failed.')),
          );
        }
      },
    );

    // Timeout if no response
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => const Err(NetworkError(isTimeout: true)),
    );
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _monitorsController.close();
    _heartbeatController.close();
    _connectionController.close();
  }
}
