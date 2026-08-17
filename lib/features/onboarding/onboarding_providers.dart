/// Providers for the "Add Instance" flow: form state, validation, and
/// connection testing status (spec §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/uptimekuma/kuma_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'onboarding_providers.g.dart';

/// The state of the add-instance form.
class InstanceFormState {
  const InstanceFormState({
    this.id,
    this.name = '',
    this.type = ServiceType.radarr,
    this.authType = AuthType.apiKey,
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

  final String? id;
  final String name;
  final ServiceType type;
  final AuthType authType;
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
    String? id,
    String? name,
    ServiceType? type,
    AuthType? authType,
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
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      authType: authType ?? this.authType,
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

  bool get isEditing => id != null;

  bool get isValid =>
      name.isNotEmpty &&
      (localUrl.isNotEmpty || remoteUrl.isNotEmpty) &&
      (authType == AuthType.apiKey
          ? apiKey.isNotEmpty
          : (username.isNotEmpty && password.isNotEmpty));
}

@riverpod
class InstanceForm extends _$InstanceForm {
  @override
  InstanceFormState build() => const InstanceFormState();

  void reset() => state = const InstanceFormState();

  Future<void> load(String id) async {
    final instanceResult = await ref.read(instanceRepositoryProvider).getById(id);
    if (instanceResult is! Ok<ServiceInstance>) return;
    final instance = instanceResult.value;

    final credential = await ref.read(secureStoreProvider).readCredential(id);

    state = InstanceFormState(
      id: instance.id,
      name: instance.name,
      type: instance.serviceType,
      authType: instance.authType,
      localUrl: instance.localBaseUrl ?? '',
      remoteUrl: instance.remoteBaseUrl ?? '',
      isDefault: instance.isDefault,
      apiKey: credential is ApiKeyCredential ? credential.apiKey : '',
      username: credential is UsernamePasswordCredential ? credential.username : '',
      password: credential is UsernamePasswordCredential ? credential.password : '',
    );
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateType(ServiceType type) => state = state.copyWith(
        type: type,
        authType: type.defaultAuthType,
      );
  void updateAuthType(AuthType authType) => state = state.copyWith(authType: authType);
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
    final credential = state.authType == AuthType.apiKey
        ? ServiceCredential.apiKey(state.apiKey)
        : ServiceCredential.usernamePassword(username: state.username, password: state.password);

    final client = _getTestClient(baseUrl, credential);
    if (client == null) {
      return const Err(UnknownError(userMessage: 'Test connection not yet implemented for this service.'));
    }
    return client.testConnection();
  }

  ConnectionTestClient? _getTestClient(String baseUrl, ServiceCredential credential) {
    if (state.type == ServiceType.radarr) {
      final dio = const DioFactory().create(
        baseUrl: baseUrl,
        apiKeyInterceptor: credential is ApiKeyCredential
            ? ApiKeyInterceptor(lookupApiKey: () async => credential.apiKey)
            : null,
      );
      return RadarrClient(dio);
    }
    if (state.type == ServiceType.sonarr) {
      final dio = const DioFactory().create(
        baseUrl: baseUrl,
        apiKeyInterceptor: credential is ApiKeyCredential
            ? ApiKeyInterceptor(lookupApiKey: () async => credential.apiKey)
            : null,
      );
      return SonarrClient(dio);
    }
    if (state.type == ServiceType.uptimeKuma) {
      final cleanBaseUrl = baseUrl.replaceAll(RegExp(r'/socket\.io/?$'), '');
      return KumaTestClient(cleanBaseUrl, credential);
    }
    return StubConnectionTestClient(baseUrl: baseUrl, credential: credential);
  }

  Future<bool> save() async {
    if (!state.isValid) return false;
    state = state.copyWith(isSaving: true, saveError: null);

    final isEditing = state.isEditing;
    final instanceId = state.id ?? const Uuid().v4();

    final instance = ServiceInstance(
      id: instanceId,
      name: state.name,
      serviceType: state.type,
      authType: state.authType,
      localBaseUrl: state.localUrl.isNotEmpty ? state.localUrl : null,
      remoteBaseUrl: state.remoteUrl.isNotEmpty ? state.remoteUrl : null,
      isDefault: state.isDefault,
      endpointMode: EndpointMode.auto,
    );

    final credential = state.authType == AuthType.apiKey
        ? ServiceCredential.apiKey(state.apiKey)
        : ServiceCredential.usernamePassword(
            username: state.username,
            password: state.password,
          );

    final result = isEditing
        ? await ref.read(instanceRepositoryProvider).update(instance, credential: credential)
        : await ref.read(instanceRepositoryProvider).add(instance, credential: credential);

    return switch (result) {
      Ok() => () {
          ref.invalidate(instancesProvider);
          return true;
        }(),
      Err(:final error) => () {
          state = state.copyWith(isSaving: false, saveError: error);
          return false;
        }(),
    };
  }
}

/// A wrapper for Uptime Kuma to implement [ConnectionTestClient].
class KumaTestClient implements ConnectionTestClient {
  KumaTestClient(this.baseUrl, this.credential);
  final String baseUrl;
  final ServiceCredential credential;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    final client = KumaClient(baseUrl: baseUrl);
    try {
      client.connect();
      final isConnected = await client.connectionStream.firstWhere((c) => c).timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      if (!isConnected) return const Err(NetworkError(userMessage: 'Could not connect to socket.'));

      final cred = credential;
      final Result<void> loginResult;
      if (cred is ApiKeyCredential) {
        loginResult = await client.loginWithApiKey(cred.apiKey);
      } else if (cred is UsernamePasswordCredential) {
        loginResult = await client.login(cred.username, cred.password);
      } else {
        return const Err(AuthError(userMessage: 'Invalid credentials.'));
      }
      
      return loginResult.map((_) => const ServiceIdentity(instanceName: 'Uptime Kuma'));
    } finally {
      client.dispose();
    }
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
