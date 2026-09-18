// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cached_service_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CachedServiceSummary {

 String get instanceId; String get instanceName; ServiceType get serviceType; String get summaryLine; DateTime get lastFetchedAt;
/// Create a copy of CachedServiceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CachedServiceSummaryCopyWith<CachedServiceSummary> get copyWith => _$CachedServiceSummaryCopyWithImpl<CachedServiceSummary>(this as CachedServiceSummary, _$identity);

  /// Serializes this CachedServiceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CachedServiceSummary&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.summaryLine, summaryLine) || other.summaryLine == summaryLine)&&(identical(other.lastFetchedAt, lastFetchedAt) || other.lastFetchedAt == lastFetchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,summaryLine,lastFetchedAt);

@override
String toString() {
  return 'CachedServiceSummary(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, summaryLine: $summaryLine, lastFetchedAt: $lastFetchedAt)';
}


}

/// @nodoc
abstract mixin class $CachedServiceSummaryCopyWith<$Res>  {
  factory $CachedServiceSummaryCopyWith(CachedServiceSummary value, $Res Function(CachedServiceSummary) _then) = _$CachedServiceSummaryCopyWithImpl;
@useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, String summaryLine, DateTime lastFetchedAt
});




}
/// @nodoc
class _$CachedServiceSummaryCopyWithImpl<$Res>
    implements $CachedServiceSummaryCopyWith<$Res> {
  _$CachedServiceSummaryCopyWithImpl(this._self, this._then);

  final CachedServiceSummary _self;
  final $Res Function(CachedServiceSummary) _then;

/// Create a copy of CachedServiceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? summaryLine = null,Object? lastFetchedAt = null,}) {
  return _then(CachedServiceSummary(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,summaryLine: null == summaryLine ? _self.summaryLine : summaryLine // ignore: cast_nullable_to_non_nullable
as String,lastFetchedAt: null == lastFetchedAt ? _self.lastFetchedAt : lastFetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CachedServiceSummary].
extension CachedServiceSummaryPatterns on CachedServiceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CachedServiceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CachedServiceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CachedServiceSummary value)  $default,){
final _that = this;
switch (_that) {
case _CachedServiceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CachedServiceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CachedServiceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  String summaryLine,  DateTime lastFetchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CachedServiceSummary() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.summaryLine,_that.lastFetchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  String summaryLine,  DateTime lastFetchedAt)  $default,) {final _that = this;
switch (_that) {
case _CachedServiceSummary():
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.summaryLine,_that.lastFetchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instanceId,  String instanceName,  ServiceType serviceType,  String summaryLine,  DateTime lastFetchedAt)?  $default,) {final _that = this;
switch (_that) {
case _CachedServiceSummary() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.summaryLine,_that.lastFetchedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CachedServiceSummary implements CachedServiceSummary {
  const _CachedServiceSummary({required this.instanceId, required this.instanceName, required this.serviceType, required this.summaryLine, required this.lastFetchedAt});
  factory _CachedServiceSummary.fromJson(Map<String, dynamic> json) => _$CachedServiceSummaryFromJson(json);

@override final  String instanceId;
@override final  String instanceName;
@override final  ServiceType serviceType;
@override final  String summaryLine;
@override final  DateTime lastFetchedAt;

/// Create a copy of CachedServiceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CachedServiceSummaryCopyWith<_CachedServiceSummary> get copyWith => __$CachedServiceSummaryCopyWithImpl<_CachedServiceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CachedServiceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CachedServiceSummary&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.summaryLine, summaryLine) || other.summaryLine == summaryLine)&&(identical(other.lastFetchedAt, lastFetchedAt) || other.lastFetchedAt == lastFetchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,summaryLine,lastFetchedAt);

@override
String toString() {
  return 'CachedServiceSummary(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, summaryLine: $summaryLine, lastFetchedAt: $lastFetchedAt)';
}


}

/// @nodoc
abstract mixin class _$CachedServiceSummaryCopyWith<$Res> implements $CachedServiceSummaryCopyWith<$Res> {
  factory _$CachedServiceSummaryCopyWith(_CachedServiceSummary value, $Res Function(_CachedServiceSummary) _then) = __$CachedServiceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, String summaryLine, DateTime lastFetchedAt
});




}
/// @nodoc
class __$CachedServiceSummaryCopyWithImpl<$Res>
    implements _$CachedServiceSummaryCopyWith<$Res> {
  __$CachedServiceSummaryCopyWithImpl(this._self, this._then);

  final _CachedServiceSummary _self;
  final $Res Function(_CachedServiceSummary) _then;

/// Create a copy of CachedServiceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? summaryLine = null,Object? lastFetchedAt = null,}) {
  return _then(_CachedServiceSummary(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,summaryLine: null == summaryLine ? _self.summaryLine : summaryLine // ignore: cast_nullable_to_non_nullable
as String,lastFetchedAt: null == lastFetchedAt ? _self.lastFetchedAt : lastFetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
