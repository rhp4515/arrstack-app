// Hand-written fakes for ConfigStore/SecureStore, per project testing
// conventions (fakes preferred over mocks for storage boundaries).

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
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

  List<Map<String, dynamic>> _cachedSummaries = const [];

  @override
  Future<List<Map<String, dynamic>>> readCachedSummaries() async =>
      _cachedSummaries;

  @override
  Future<void> writeCachedSummaries(
    List<Map<String, dynamic>> summaries,
  ) async {
    _cachedSummaries = List.unmodifiable(summaries);
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

class FakeInstanceRepository implements InstanceRepository {
  final List<String> deletedIds = [];

  @override
  Future<Result<List<ServiceInstance>>> list() async => const Ok([]);

  @override
  Future<Result<ServiceInstance>> getById(String id) async =>
      Err(NotFoundError(userMessage: 'Not found: $id'));

  @override
  Future<Result<ServiceInstance>> add(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async => Ok(instance);

  @override
  Future<Result<ServiceInstance>> update(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async => Ok(instance);

  @override
  Future<Result<void>> delete(String id) async {
    deletedIds.add(id);
    return const Ok(null);
  }

  @override
  Future<Result<ServiceInstance>> setDefault(String id) async =>
      Err(NotFoundError(userMessage: 'Not found: $id'));
}
