// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_service_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeServiceSummary {

 String get instanceId; String get instanceName; ServiceType get serviceType; bool get isReachable; String get summaryLine; String? get statusLabel;
/// Create a copy of HomeServiceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeServiceSummaryCopyWith<HomeServiceSummary> get copyWith => _$HomeServiceSummaryCopyWithImpl<HomeServiceSummary>(this as HomeServiceSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeServiceSummary&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable)&&(identical(other.summaryLine, summaryLine) || other.summaryLine == summaryLine)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}


@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,isReachable,summaryLine,statusLabel);

@override
String toString() {
  return 'HomeServiceSummary(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, isReachable: $isReachable, summaryLine: $summaryLine, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class $HomeServiceSummaryCopyWith<$Res>  {
  factory $HomeServiceSummaryCopyWith(HomeServiceSummary value, $Res Function(HomeServiceSummary) _then) = _$HomeServiceSummaryCopyWithImpl;
@useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, bool isReachable, String summaryLine, String? statusLabel
});




}
/// @nodoc
class _$HomeServiceSummaryCopyWithImpl<$Res>
    implements $HomeServiceSummaryCopyWith<$Res> {
  _$HomeServiceSummaryCopyWithImpl(this._self, this._then);

  final HomeServiceSummary _self;
  final $Res Function(HomeServiceSummary) _then;

/// Create a copy of HomeServiceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? isReachable = null,Object? summaryLine = null,Object? statusLabel = freezed,}) {
  return _then(HomeServiceSummary(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,summaryLine: null == summaryLine ? _self.summaryLine : summaryLine // ignore: cast_nullable_to_non_nullable
as String,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeServiceSummary].
extension HomeServiceSummaryPatterns on HomeServiceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeServiceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeServiceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeServiceSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeServiceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeServiceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeServiceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String summaryLine,  String? statusLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeServiceSummary() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.summaryLine,_that.statusLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String summaryLine,  String? statusLabel)  $default,) {final _that = this;
switch (_that) {
case _HomeServiceSummary():
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.summaryLine,_that.statusLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instanceId,  String instanceName,  ServiceType serviceType,  bool isReachable,  String summaryLine,  String? statusLabel)?  $default,) {final _that = this;
switch (_that) {
case _HomeServiceSummary() when $default != null:
return $default(_that.instanceId,_that.instanceName,_that.serviceType,_that.isReachable,_that.summaryLine,_that.statusLabel);case _:
  return null;

}
}

}

/// @nodoc


class _HomeServiceSummary implements HomeServiceSummary {
  const _HomeServiceSummary({required this.instanceId, required this.instanceName, required this.serviceType, required this.isReachable, required this.summaryLine, this.statusLabel});
  

@override final  String instanceId;
@override final  String instanceName;
@override final  ServiceType serviceType;
@override final  bool isReachable;
@override final  String summaryLine;
@override final  String? statusLabel;

/// Create a copy of HomeServiceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeServiceSummaryCopyWith<_HomeServiceSummary> get copyWith => __$HomeServiceSummaryCopyWithImpl<_HomeServiceSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeServiceSummary&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.instanceName, instanceName) || other.instanceName == instanceName)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable)&&(identical(other.summaryLine, summaryLine) || other.summaryLine == summaryLine)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}


@override
int get hashCode => Object.hash(runtimeType,instanceId,instanceName,serviceType,isReachable,summaryLine,statusLabel);

@override
String toString() {
  return 'HomeServiceSummary(instanceId: $instanceId, instanceName: $instanceName, serviceType: $serviceType, isReachable: $isReachable, summaryLine: $summaryLine, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class _$HomeServiceSummaryCopyWith<$Res> implements $HomeServiceSummaryCopyWith<$Res> {
  factory _$HomeServiceSummaryCopyWith(_HomeServiceSummary value, $Res Function(_HomeServiceSummary) _then) = __$HomeServiceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String instanceId, String instanceName, ServiceType serviceType, bool isReachable, String summaryLine, String? statusLabel
});




}
/// @nodoc
class __$HomeServiceSummaryCopyWithImpl<$Res>
    implements _$HomeServiceSummaryCopyWith<$Res> {
  __$HomeServiceSummaryCopyWithImpl(this._self, this._then);

  final _HomeServiceSummary _self;
  final $Res Function(_HomeServiceSummary) _then;

/// Create a copy of HomeServiceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instanceId = null,Object? instanceName = null,Object? serviceType = null,Object? isReachable = null,Object? summaryLine = null,Object? statusLabel = freezed,}) {
  return _then(_HomeServiceSummary(
instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,instanceName: null == instanceName ? _self.instanceName : instanceName // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as ServiceType,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,summaryLine: null == summaryLine ? _self.summaryLine : summaryLine // ignore: cast_nullable_to_non_nullable
as String,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
