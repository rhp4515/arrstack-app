// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServiceHealth {

 String get instanceId; String get instanceName; ServiceType get serviceType; bool get isReachable; String get headlineStat; Color get statusColor;
/// Create a copy of ServiceHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceHealthCopyWith<ServiceHealth> get copyWith => _$ServiceHealthCopyWithImpl<ServiceHealth>(this as ServiceHealth, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceHealth&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable)&&(identical(other.headlineStat, headlineStat) || other.headlineStat == headlineStat)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor));
}


@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,isReachable,headlineStat,statusColor);

@override
String toString() {
  return 'ServiceHealth(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, isReachable: $isReachable, headlineStat: $headlineStat, statusColor: $statusColor)';
}


}

/// @nodoc
abstract mixin class $ServiceHealthCopyWith<$Res>  {
  factory $ServiceHealthCopyWith(ServiceHealth value, $Res Function(ServiceHealth) _then) = _$ServiceHealthCopyWithImpl;
@useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, bool isReachable, String headlineStat, Color statusColor
});




}
/// @nodoc
class _$ServiceHealthCopyWithImpl<$Res>
    implements $ServiceHealthCopyWith<$Res> {
  _$ServiceHealthCopyWithImpl(this._self, this._then);

  final ServiceHealth _self;
  final $Res Function(ServiceHealth) _then;

/// Create a copy of ServiceHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? isReachable = null,Object? headlineStat = null,Object? statusColor = null,}) {
  return _then(ServiceHealth(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,headlineStat: null == headlineStat ? _self.headlineStat : headlineStat // ignore: cast_nullable_to_non_nullable
as String,statusColor: null == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceHealth].
extension ServiceHealthPatterns on ServiceHealth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceHealth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceHealth value)  $default,){
final _that = this;
switch (_that) {
case _ServiceHealth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceHealth value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceHealth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String headlineStat,  Color statusColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceHealth() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.headlineStat,_that.statusColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String headlineStat,  Color statusColor)  $default,) {final _that = this;
switch (_that) {
case _ServiceHealth():
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.headlineStat,_that.statusColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String headlineStat,  Color statusColor)?  $default,) {final _that = this;
switch (_that) {
case _ServiceHealth() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.headlineStat,_that.statusColor);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceHealth implements ServiceHealth {
  const _ServiceHealth({required this.instanceId, required this.instanceName, required this.serviceType, required this.isReachable, required this.headlineStat, required this.statusColor});
  

@override final  String instanceId;
@override final  String instanceName;
@override final  ServiceType serviceType;
@override final  bool isReachable;
@override final  String headlineStat;
@override final  Color statusColor;

/// Create a copy of ServiceHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceHealthCopyWith<_ServiceHealth> get copyWith => __$ServiceHealthCopyWithImpl<_ServiceHealth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceHealth&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable)&&(identical(other.headlineStat, headlineStat) || other.headlineStat == headlineStat)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor));
}


@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,isReachable,headlineStat,statusColor);

@override
String toString() {
  return 'ServiceHealth(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, isReachable: $isReachable, headlineStat: $headlineStat, statusColor: $statusColor)';
}


}

/// @nodoc
abstract mixin class _$ServiceHealthCopyWith<$Res> implements $ServiceHealthCopyWith<$Res> {
  factory _$ServiceHealthCopyWith(_ServiceHealth value, $Res Function(_ServiceHealth) _then) = __$ServiceHealthCopyWithImpl;
@override @useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, bool isReachable, String headlineStat, Color statusColor
});




}
/// @nodoc
class __$ServiceHealthCopyWithImpl<$Res>
    implements _$ServiceHealthCopyWith<$Res> {
  __$ServiceHealthCopyWithImpl(this._self, this._then);

  final _ServiceHealth _self;
  final $Res Function(_ServiceHealth) _then;

/// Create a copy of ServiceHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? isReachable = null,Object? headlineStat = null,Object? statusColor = null,}) {
  return _then(_ServiceHealth(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,headlineStat: null == headlineStat ? _self.headlineStat : headlineStat // ignore: cast_nullable_to_non_nullable
as String,statusColor: null == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
