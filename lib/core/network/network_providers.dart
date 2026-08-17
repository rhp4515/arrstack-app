/// Riverpod wiring for the network layer: the SSID/connectivity sources and
/// the [EndpointResolver], plus a stream of the current SSID that
/// recomputes on `connectivity_plus` change events (spec §6a).
library;

import 'package:arrstack/core/network/connectivity_source.dart';
import 'package:arrstack/core/network/endpoint_resolver.dart';
import 'package:arrstack/core/network/ssid_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
SsidSource ssidSource(Ref ref) => const NetworkInfoSsidSource();

@Riverpod(keepAlive: true)
ConnectivitySource connectivitySource(Ref ref) =>
    const ConnectivityPlusSource();

@Riverpod(keepAlive: true)
EndpointResolver endpointResolver(Ref ref) => const EndpointResolver();

/// The currently connected WiFi SSID (or null if unavailable), re-read
/// every time connectivity changes so `EndpointResolver`-driven baseUrls
/// stay current (spec §6a step 4).
@riverpod
Stream<String?> currentSsid(Ref ref) async* {
  final ssid = ref.watch(ssidSourceProvider);
  final connectivity = ref.watch(connectivitySourceProvider);

  yield await ssid.currentSsid();
  await for (final _ in connectivity.onConnectivityChanged()) {
    yield await ssid.currentSsid();
  }
}
