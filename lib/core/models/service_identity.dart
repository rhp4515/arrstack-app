/// Parsed identity returned by a service's "test connection" call (spec §6).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_identity.freezed.dart';
part 'service_identity.g.dart';

/// Minimal identity info a connection test can confirm before an instance
/// is saved: that the endpoint answered, and (if available) its version.
@freezed
abstract class ServiceIdentity with _$ServiceIdentity {
  const factory ServiceIdentity({
    required String instanceName,
    String? version,
  }) = _ServiceIdentity;

  factory ServiceIdentity.fromJson(Map<String, dynamic> json) =>
      _$ServiceIdentityFromJson(json);
}
