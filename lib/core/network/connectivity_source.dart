/// Thin, fakeable boundary around `connectivity_plus` — the provider layer
/// listens for network-change events through this to trigger endpoint
/// re-resolution (spec §6a); core logic never touches the plugin directly.
library;

import 'package:connectivity_plus/connectivity_plus.dart';

/// Source of network connectivity state/changes.
abstract interface class ConnectivitySource {
  /// The current connectivity state(s) (WiFi, mobile, none, ...).
  Future<List<ConnectivityResult>> currentConnectivity();

  /// Emits whenever connectivity changes.
  Stream<List<ConnectivityResult>> onConnectivityChanged();
}

/// [ConnectivitySource] backed by `connectivity_plus`.
class ConnectivityPlusSource implements ConnectivitySource {
  const ConnectivityPlusSource([Connectivity? connectivity])
    : _connectivity = connectivity;

  final Connectivity? _connectivity;

  Connectivity get _instance => _connectivity ?? Connectivity();

  @override
  Future<List<ConnectivityResult>> currentConnectivity() =>
      _instance.checkConnectivity();

  @override
  Stream<List<ConnectivityResult>> onConnectivityChanged() =>
      _instance.onConnectivityChanged;
}
