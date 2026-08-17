// Hand-written fakes for ConfigStore/SecureStore, per project testing
// conventions (fakes preferred over mocks for storage boundaries).

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage.dart';

class FakeConfigStore implements ConfigStore {
  List<Map<String, dynamic>> _instances = const [];
  List<String> _homeSsids = const [];
  EndpointMode _defaultEndpointMode = EndpointMode.auto;
  String? _themeMode;

  @override
  Future<List<Map<String, dynamic>>> readInstances() async => _instances;

  @override
  Future<void> writeInstances(List<Map<String, dynamic>> instances) async {
    _instances = List.unmodifiable(instances);
  }

  @override
  Future<List<String>> readHomeSsids() async => _homeSsids;

  @override
  Future<void> writeHomeSsids(List<String> ssids) async {
    _homeSsids = List.unmodifiable(ssids);
  }

  @override
  Future<EndpointMode> readDefaultEndpointMode() async => _defaultEndpointMode;

  @override
  Future<void> writeDefaultEndpointMode(EndpointMode mode) async {
    _defaultEndpointMode = mode;
  }

  @override
  Future<String?> readThemeMode() async => _themeMode;

  @override
  Future<void> writeThemeMode(String mode) async {
    _themeMode = mode;
  }
}

class FakeSecureStore implements SecureStore {
  final Map<String, ServiceCredential> _credentials = {};

  /// Test-only accessor to assert what actually landed in "secure" storage.
  Map<String, ServiceCredential> get storedCredentials =>
      Map.unmodifiable(_credentials);

  @override
  Future<ServiceCredential?> readCredential(String instanceId) async =>
      _credentials[instanceId];

  @override
  Future<void> writeCredential(
    String instanceId,
    ServiceCredential credential,
  ) async {
    _credentials[instanceId] = credential;
  }

  @override
  Future<void> deleteCredential(String instanceId) async {
    _credentials.remove(instanceId);
  }
}
