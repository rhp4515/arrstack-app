/// Providers for the "Add Instance" flow: form state, validation, and
/// connection testing status (spec §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'onboarding_providers.g.dart';

/// The state of the add-instance form.
class InstanceFormState {
  const InstanceFormState({
    this.name = '',
    this.type = ServiceType.radarr,
    this.localUrl = '',
    this.remoteUrl = '',
    this.apiKey = '',
    this.username = '',
    this.password = '',
    this.isDefault = false,
    this.isTestingLocal = false,
    this.isTestingRemote = false,
    this.localTestResult,
    this.remoteTestResult,
    this.isSaving = false,
    this.saveError,
  });

  final String name;
  final ServiceType type;
  final String localUrl;
  final String remoteUrl;
  final String apiKey;
  final String username;
  final String password;
  final bool isDefault;

  final bool isTestingLocal;
  final bool isTestingRemote;
  final Result<ServiceIdentity>? localTestResult;
  final Result<ServiceIdentity>? remoteTestResult;

  final bool isSaving;
  final AppError? saveError;

  InstanceFormState copyWith({
    String? name,
    ServiceType? type,
    String? localUrl,
    String? remoteUrl,
    String? apiKey,
    String? username,
    String? password,
    bool? isDefault,
    bool? isTestingLocal,
    bool? isTestingRemote,
    Result<ServiceIdentity>? localTestResult,
    Result<ServiceIdentity>? remoteTestResult,
    bool? isSaving,
    AppError? saveError,
  }) {
    return InstanceFormState(
      name: name ?? this.name,
      type: type ?? this.type,
      localUrl: localUrl ?? this.localUrl,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      apiKey: apiKey ?? this.apiKey,
      username: username ?? this.username,
      password: password ?? this.password,
      isDefault: isDefault ?? this.isDefault,
      isTestingLocal: isTestingLocal ?? this.isTestingLocal,
      isTestingRemote: isTestingRemote ?? this.isTestingRemote,
      localTestResult: localTestResult ?? this.localTestResult,
      remoteTestResult: remoteTestResult ?? this.remoteTestResult,
      isSaving: isSaving ?? this.isSaving,
      saveError: saveError ?? this.saveError,
    );
  }

  bool get isValid =>
      name.isNotEmpty &&
      (localUrl.isNotEmpty || remoteUrl.isNotEmpty) &&
      (type.defaultAuthType == AuthType.apiKey
          ? apiKey.isNotEmpty
          : (username.isNotEmpty && password.isNotEmpty));
}

@riverpod
class InstanceForm extends _$InstanceForm {
  @override
  InstanceFormState build() => const InstanceFormState();

  void updateName(String name) => state = state.copyWith(name: name);
  void updateType(ServiceType type) => state = state.copyWith(type: type);
  void updateLocalUrl(String url) => state = state.copyWith(localUrl: url, localTestResult: null);
  void updateRemoteUrl(String url) => state = state.copyWith(remoteUrl: url, remoteTestResult: null);
  void updateApiKey(String key) => state = state.copyWith(apiKey: key);
  void updateUsername(String username) => state = state.copyWith(username: username);
  void updatePassword(String password) => state = state.copyWith(password: password);
  void updateIsDefault(bool isDefault) => state = state.copyWith(isDefault: isDefault);

  Future<void> testLocal() async {
    if (state.localUrl.isEmpty) return;
    state = state.copyWith(isTestingLocal: true, localTestResult: null);
    final result = await _test(state.localUrl);
    state = state.copyWith(isTestingLocal: false, localTestResult: result);
  }

  Future<void> testRemote() async {
    if (state.remoteUrl.isEmpty) return;
    state = state.copyWith(isTestingRemote: true, remoteTestResult: null);
    final result = await _test(state.remoteUrl);
    state = state.copyWith(isTestingRemote: false, remoteTestResult: result);
  }

  Future<Result<ServiceIdentity>> _test(String baseUrl) async {
    final credential = state.type.defaultAuthType == AuthType.apiKey
        ? ServiceCredential.apiKey(state.apiKey)
        : ServiceCredential.usernamePassword(username: state.username, password: state.password);

    // In Phase 3, we don't have real clients yet. Use a stub or look up
    // via a factory if we implement one.
    // For now, let's assume we'll implement a MockConnectionTestClient
    // or eventually use the real one once Phase 4+ lands.
    final client = _getTestClient(baseUrl, credential);
    if (client == null) {
      return const Err(UnknownError(userMessage: 'Test connection not yet implemented for this service.'));
    }
    return client.testConnection();
  }

  ConnectionTestClient? _getTestClient(String baseUrl, ServiceCredential credential) {
    // TODO: Wire up real clients as they are implemented.
    // For Phase 3, return a stub that succeeds if URL contains "success".
    return StubConnectionTestClient(baseUrl: baseUrl, credential: credential);
  }

  Future<bool> save() async {
    if (!state.isValid) return false;
    state = state.copyWith(isSaving: true, saveError: null);

    final instanceId = const Uuid().v4();
    final instance = ServiceInstance(
      id: instanceId,
      name: state.name,
      serviceType: state.type,
      authType: state.type.defaultAuthType,
      localBaseUrl: state.localUrl.isNotEmpty ? state.localUrl : null,
      remoteBaseUrl: state.remoteUrl.isNotEmpty ? state.remoteUrl : null,
      isDefault: state.isDefault,
      endpointMode: EndpointMode.auto,
    );

    final credential = state.type.defaultAuthType == AuthType.apiKey
        ? ServiceCredential.apiKey(state.apiKey)
        : ServiceCredential.usernamePassword(username: state.username, password: state.password);

    final result = await ref.read(instanceRepositoryProvider).add(
      instance,
      credential: credential,
    );

    return switch (result) {
      Ok() => true,
      Err(:final error) => () {
          state = state.copyWith(isSaving: false, saveError: error);
          return false;
        }(),
    };
  }
}

/// A stub client for Phase 3 to verify the UI flow.
class StubConnectionTestClient implements ConnectionTestClient {
  const StubConnectionTestClient({required this.baseUrl, required this.credential});
  final String baseUrl;
  final ServiceCredential credential;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    await Future.delayed(const Duration(seconds: 1));
    if (baseUrl.contains('error')) {
      return const Err(NetworkError(userMessage: 'Stub: Connection failed.'));
    }
    return const Ok(ServiceIdentity(instanceName: 'Stub Instance', version: '1.0.0-stub'));
  }
}
