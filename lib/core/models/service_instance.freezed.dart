// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceInstance {

 String get id; String get name; ServiceType get serviceType; AuthType get authType;/// LAN URL, e.g. `http://192.168.1.10:7878`.
 String? get localBaseUrl;/// Tailscale MagicDNS URL, e.g. `http://nas.tailnet-xxxx.ts.net:7878`.
 String? get remoteBaseUrl;/// Per-instance override of the app-level home SSID list. When null,
/// [EndpointResolver] falls back to the app-level list.
 List<String>? get homeSsidsOverride; EndpointMode get endpointMode; bool get isDefault;
/// Create a copy of ServiceInstance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceInstanceCopyWith<ServiceInstance> get copyWith => _$ServiceInstanceCopyWithImpl<ServiceInstance>(this as ServiceInstance, _$identity);

  /// Serializes this ServiceInstance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceInstance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.authType, authType) || other.authType == authType)&&(identical(other.localBaseUrl, localBaseUrl) || other.localBaseUrl == localBaseUrl)&&(identical(other.remoteBaseUrl, remoteBaseUrl) || other.remoteBaseUrl == remoteBaseUrl)&&const DeepCollectionEquality().equals(other.homeSsidsOverride, homeSsidsOverride)&&(identical(other.endpointMode, endpointMode) || other.endpointMode == endpointMode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,serviceType,authType,localBaseUrl,remoteBaseUrl,const DeepCollectionEquality().hash(homeSsidsOverride),endpointMode,isDefault);

@override
String toString() {
  return 'ServiceInstance(id: $id, name: $name, serviceType: $serviceType, authType: $authType, localBaseUrl: $localBaseUrl, remoteBaseUrl: $remoteBaseUrl, homeSsidsOverride: $homeSsidsOverride, endpointMode: $endpointMode, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ServiceInstanceCopyWith<$Res>  {
  factory $ServiceInstanceCopyWith(ServiceInstance value, $Res Function(ServiceInstance) _then) = _$ServiceInstanceCopyWithImpl;
@useResult
$Res call({
 String id, String name, ServiceType serviceType, AuthType authType, String? localBaseUrl, String? remoteBaseUrl, List<String>? homeSsidsOverride, EndpointMode endpointMode, bool isDefault
});




}
/// @nodoc
class _$ServiceInstanceCopyWithImpl<$Res>
    implements $ServiceInstanceCopyWith<$Res> {
  _$ServiceInstanceCopyWithImpl(this._self, this._then);

  final ServiceInstance _self;
  final $Res Function(ServiceInstance) _then;

/// Create a copy of ServiceInstance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? serviceType = null,Object? authType = null,Object? localBaseUrl = freezed,Object? remoteBaseUrl = freezed,Object? homeSsidsOverride = freezed,Object? endpointMode = null,Object? isDefault = null,}) {
  return _then(ServiceInstance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,authType: null == authType ? _self.authType : authType // ignore: cast_nullable_to_non_nullable
as AuthType,localBaseUrl: freezed == localBaseUrl ? _self.localBaseUrl : localBaseUrl // ignore: cast_nullable_to_non_nullable
as String?,remoteBaseUrl: freezed == remoteBaseUrl ? _self.remoteBaseUrl : remoteBaseUrl // ignore: cast_nullable_to_non_nullable
as String?,homeSsidsOverride: freezed == homeSsidsOverride ? _self.homeSsidsOverride : homeSsidsOverride // ignore: cast_nullable_to_non_nullable
as List<String>?,endpointMode: null == endpointMode ? _self.endpointMode : endpointMode // ignore: cast_nullable_to_non_nullable
as EndpointMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceInstance].
extension ServiceInstancePatterns on ServiceInstance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceInstance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceInstance() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceInstance value)  $default,){
final _that = this;
switch (_that) {
case _ServiceInstance():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceInstance value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceInstance() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ServiceType serviceType,  AuthType authType,  String? localBaseUrl,  String? remoteBaseUrl,  List<String>? homeSsidsOverride,  EndpointMode endpointMode,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceInstance() when $default != null:
return $default(_that.id,_that.name,_that.serviceType,_that.authType,_that.localBaseUrl,_that.remoteBaseUrl,_that.homeSsidsOverride,_that.endpointMode,_that.isDefault);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ServiceType serviceType,  AuthType authType,  String? localBaseUrl,  String? remoteBaseUrl,  List<String>? homeSsidsOverride,  EndpointMode endpointMode,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ServiceInstance():
return $default(_that.id,_that.name,_that.serviceType,_that.authType,_that.localBaseUrl,_that.remoteBaseUrl,_that.homeSsidsOverride,_that.endpointMode,_that.isDefault);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ServiceType serviceType,  AuthType authType,  String? localBaseUrl,  String? remoteBaseUrl,  List<String>? homeSsidsOverride,  EndpointMode endpointMode,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ServiceInstance() when $default != null:
return $default(_that.id,_that.name,_that.serviceType,_that.authType,_that.localBaseUrl,_that.remoteBaseUrl,_that.homeSsidsOverride,_that.endpointMode,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceInstance implements ServiceInstance {
  const _ServiceInstance({required this.id, required this.name, required this.serviceType, required this.authType, this.localBaseUrl, this.remoteBaseUrl,  List<String>? homeSsidsOverride, this.endpointMode = EndpointMode.auto, this.isDefault = false}): _homeSsidsOverride = homeSsidsOverride;
  factory _ServiceInstance.fromJson(Map<String, dynamic> json) => _$ServiceInstanceFromJson(json);

@override final  String id;
@override final  String name;
@override final  ServiceType serviceType;
@override final  AuthType authType;
/// LAN URL, e.g. `http://192.168.1.10:7878`.
@override final  String? localBaseUrl;
/// Tailscale MagicDNS URL, e.g. `http://nas.tailnet-xxxx.ts.net:7878`.
@override final  String? remoteBaseUrl;
/// Per-instance override of the app-level home SSID list. When null,
/// [EndpointResolver] falls back to the app-level list.
 final  List<String>? _homeSsidsOverride;
/// Per-instance override of the app-level home SSID list. When null,
/// [EndpointResolver] falls back to the app-level list.
@override List<String>? get homeSsidsOverride {
  final value = _homeSsidsOverride;
  if (value == null) return null;
  if (_homeSsidsOverride is EqualUnmodifiableListView) return _homeSsidsOverride;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  EndpointMode endpointMode;
@override@JsonKey() final  bool isDefault;

/// Create a copy of ServiceInstance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceInstanceCopyWith<_ServiceInstance> get copyWith => __$ServiceInstanceCopyWithImpl<_ServiceInstance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceInstanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceInstance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.authType, authType) || other.authType == authType)&&(identical(other.localBaseUrl, localBaseUrl) || other.localBaseUrl == localBaseUrl)&&(identical(other.remoteBaseUrl, remoteBaseUrl) || other.remoteBaseUrl == remoteBaseUrl)&&const DeepCollectionEquality().equals(other._homeSsidsOverride, _homeSsidsOverride)&&(identical(other.endpointMode, endpointMode) || other.endpointMode == endpointMode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,serviceType,authType,localBaseUrl,remoteBaseUrl,const DeepCollectionEquality().hash(_homeSsidsOverride),endpointMode,isDefault);

@override
String toString() {
  return 'ServiceInstance(id: $id, name: $name, serviceType: $serviceType, authType: $authType, localBaseUrl: $localBaseUrl, remoteBaseUrl: $remoteBaseUrl, homeSsidsOverride: $homeSsidsOverride, endpointMode: $endpointMode, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ServiceInstanceCopyWith<$Res> implements $ServiceInstanceCopyWith<$Res> {
  factory _$ServiceInstanceCopyWith(_ServiceInstance value, $Res Function(_ServiceInstance) _then) = __$ServiceInstanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ServiceType serviceType, AuthType authType, String? localBaseUrl, String? remoteBaseUrl, List<String>? homeSsidsOverride, EndpointMode endpointMode, bool isDefault
});




}
/// @nodoc
class __$ServiceInstanceCopyWithImpl<$Res>
    implements _$ServiceInstanceCopyWith<$Res> {
  __$ServiceInstanceCopyWithImpl(this._self, this._then);

  final _ServiceInstance _self;
  final $Res Function(_ServiceInstance) _then;

/// Create a copy of ServiceInstance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? serviceType = null,Object? authType = null,Object? localBaseUrl = freezed,Object? remoteBaseUrl = freezed,Object? homeSsidsOverride = freezed,Object? endpointMode = null,Object? isDefault = null,}) {
  return _then(_ServiceInstance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,authType: null == authType ? _self.authType : authType // ignore: cast_nullable_to_non_nullable
as AuthType,localBaseUrl: freezed == localBaseUrl ? _self.localBaseUrl : localBaseUrl // ignore: cast_nullable_to_non_nullable
as String?,remoteBaseUrl: freezed == remoteBaseUrl ? _self.remoteBaseUrl : remoteBaseUrl // ignore: cast_nullable_to_non_nullable
as String?,homeSsidsOverride: freezed == homeSsidsOverride ? _self._homeSsidsOverride : homeSsidsOverride // ignore: cast_nullable_to_non_nullable
as List<String>?,endpointMode: null == endpointMode ? _self.endpointMode : endpointMode // ignore: cast_nullable_to_non_nullable
as EndpointMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
