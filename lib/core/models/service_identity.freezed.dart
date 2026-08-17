// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceIdentity {

 String get instanceName; String? get version;
/// Create a copy of ServiceIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceIdentityCopyWith<ServiceIdentity> get copyWith => _$ServiceIdentityCopyWithImpl<ServiceIdentity>(this as ServiceIdentity, _$identity);

  /// Serializes this ServiceIdentity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceIdentity&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instanceName,version);

@override
String toString() {
  return 'ServiceIdentity(instanceName: $instanceName, version: $version)';
}


}

/// @nodoc
abstract mixin class $ServiceIdentityCopyWith<$Res>  {
  factory $ServiceIdentityCopyWith(ServiceIdentity value, $Res Function(ServiceIdentity) _then) = _$ServiceIdentityCopyWithImpl;
@useResult
$Res call({
 String instanceName, String? version
});




}
/// @nodoc
class _$ServiceIdentityCopyWithImpl<$Res>
    implements $ServiceIdentityCopyWith<$Res> {
  _$ServiceIdentityCopyWithImpl(this._self, this._then);

  final ServiceIdentity _self;
  final $Res Function(ServiceIdentity) _then;

/// Create a copy of ServiceIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instanceName = null,Object? version = freezed,}) {
  return _then(ServiceIdentity(
instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceIdentity].
extension ServiceIdentityPatterns on ServiceIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceIdentity value)  $default,){
final _that = this;
switch (_that) {
case _ServiceIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instanceName,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceIdentity() when $default != null:
return $default(_that.instanceName,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instanceName,  String? version)  $default,) {final _that = this;
switch (_that) {
case _ServiceIdentity():
return $default(_that.instanceName,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instanceName,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _ServiceIdentity() when $default != null:
return $default(_that.instanceName,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceIdentity implements ServiceIdentity {
  const _ServiceIdentity({required this.instanceName, this.version});
  factory _ServiceIdentity.fromJson(Map<String, dynamic> json) => _$ServiceIdentityFromJson(json);

@override final  String instanceName;
@override final  String? version;

/// Create a copy of ServiceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceIdentityCopyWith<_ServiceIdentity> get copyWith => __$ServiceIdentityCopyWithImpl<_ServiceIdentity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceIdentityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceIdentity&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instanceName,version);

@override
String toString() {
  return 'ServiceIdentity(instanceName: $instanceName, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ServiceIdentityCopyWith<$Res> implements $ServiceIdentityCopyWith<$Res> {
  factory _$ServiceIdentityCopyWith(_ServiceIdentity value, $Res Function(_ServiceIdentity) _then) = __$ServiceIdentityCopyWithImpl;
@override @useResult
$Res call({
 String instanceName, String? version
});




}
/// @nodoc
class __$ServiceIdentityCopyWithImpl<$Res>
    implements _$ServiceIdentityCopyWith<$Res> {
  __$ServiceIdentityCopyWithImpl(this._self, this._then);

  final _ServiceIdentity _self;
  final $Res Function(_ServiceIdentity) _then;

/// Create a copy of ServiceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instanceName = null,Object? version = freezed,}) {
  return _then(_ServiceIdentity(
instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
