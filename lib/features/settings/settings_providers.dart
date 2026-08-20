/// Providers for global app settings: Home SSIDs and default endpoint mode
/// (spec §6a, §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network_providers.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
class HomeSsidsSettings extends _$HomeSsidsSettings {
  @override
  Future<List<String>> build() async {
    final result = await ref.watch(homeSsidsProvider.future);
    if (result case Ok<List<String>>(:final value)) return value;
    return const [];
  }

  Future<void> addHomeSsid(String ssid) async {
    final current = await future;
    if (ssid.isNotEmpty && !current.contains(ssid)) {
      final next = [...current, ssid];
      await ref.read(configStoreProvider).writeHomeSsids(next);
      ref.invalidate(homeSsidsProvider);
    }
  }

  Future<void> removeHomeSsid(String ssid) async {
    final current = await future;
    final next = current.where((s) => s != ssid).toList();
    await ref.read(configStoreProvider).writeHomeSsids(next);
    ref.invalidate(homeSsidsProvider);
  }

  Future<String?> detectCurrentSsid() async {
    final ssidSource = ref.read(ssidSourceProvider);
    final status = await ssidSource.permissionStatus();
    if (!status.isGranted) {
      final granted = await ssidSource.requestPermission();
      if (!granted) return null;
    }
    return ssidSource.currentSsid();
  }
}

@Riverpod(keepAlive: true)
class DefaultEndpointModeSettings extends _$DefaultEndpointModeSettings {
  @override
  Future<EndpointMode> build() async {
    final result = await ref.watch(defaultEndpointModeProvider.future);
    if (result case Ok<EndpointMode>(:final value)) return value;
    return EndpointMode.auto;
  }

  Future<void> updateMode(EndpointMode mode) async {
    await ref.read(configStoreProvider).writeDefaultEndpointMode(mode);
    ref.invalidate(defaultEndpointModeProvider);
  }
}
