/// The secret half of a service instance's auth — lives only in
/// [SecureStore], never in [ServiceInstance], `ConfigStore`, or logs.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_credential.freezed.dart';
part 'service_credential.g.dart';

/// Either an API key or a username/password pair, matching [AuthType].
@freezed
sealed class ServiceCredential with _$ServiceCredential {
  const factory ServiceCredential.apiKey(String apiKey) = ApiKeyCredential;

  const factory ServiceCredential.usernamePassword({
    required String username,
    required String password,
  }) = UsernamePasswordCredential;

  factory ServiceCredential.fromJson(Map<String, dynamic> json) =>
      _$ServiceCredentialFromJson(json);
}
