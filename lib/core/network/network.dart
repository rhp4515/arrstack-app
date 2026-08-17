/// Dio factory, interceptors, error mapping, `Result<T>`, and the
/// network-aware [EndpointResolver] (spec §5, §6a).
library;

export 'package:arrstack/core/network/api_key_interceptor.dart';
export 'package:arrstack/core/network/app_error.dart';
export 'package:arrstack/core/network/connectivity_source.dart';
export 'package:arrstack/core/network/dio_call.dart';
export 'package:arrstack/core/network/dio_exception_mapper.dart';
export 'package:arrstack/core/network/dio_factory.dart';
export 'package:arrstack/core/network/endpoint_resolver.dart';
export 'package:arrstack/core/network/error_mapping_interceptor.dart';
export 'package:arrstack/core/network/instance_dio_providers.dart';
export 'package:arrstack/core/network/network_providers.dart';
export 'package:arrstack/core/network/redacting_log_interceptor.dart';
export 'package:arrstack/core/network/result.dart';
export 'package:arrstack/core/network/ssid_source.dart';
