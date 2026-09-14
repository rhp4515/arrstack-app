// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'right_now_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RightNowSummary {

 int get downloadSpeed; int get uploadSpeed; int get downloadingCount; int get seedingCount; int? get etaToNextFinishSeconds; double get downloadingFraction; double get pausedOrStalledFraction; double get queuedFraction;
/// Create a copy of RightNowSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RightNowSummaryCopyWith<RightNowSummary> get copyWith => _$RightNowSummaryCopyWithImpl<RightNowSummary>(this as RightNowSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RightNowSummary&&(identical(other.downloadSpeed, downloadSpeed) || other.downloadSpeed == downloadSpeed)&&(identical(other.uploadSpeed, uploadSpeed) || other.uploadSpeed == uploadSpeed)&&(identical(other.downloadingCount, downloadingCount) || other.downloadingCount == downloadingCount)&&(identical(other.seedingCount, seedingCount) || other.seedingCount == seedingCount)&&(identical(other.etaToNextFinishSeconds, etaToNextFinishSeconds) || other.etaToNextFinishSeconds == etaToNextFinishSeconds)&&(identical(other.downloadingFraction, downloadingFraction) || other.downloadingFraction == downloadingFraction)&&(identical(other.pausedOrStalledFraction, pausedOrStalledFraction) || other.pausedOrStalledFraction == pausedOrStalledFraction)&&(identical(other.queuedFraction, queuedFraction) || other.queuedFraction == queuedFraction));
}


@override
int get hashCode => Object.hash(runtimeType,downloadSpeed,uploadSpeed,downloadingCount,seedingCount,etaToNextFinishSeconds,downloadingFraction,pausedOrStalledFraction,queuedFraction);

@override
String toString() {
  return 'RightNowSummary(downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, downloadingCount: $downloadingCount, seedingCount: $seedingCount, etaToNextFinishSeconds: $etaToNextFinishSeconds, downloadingFraction: $downloadingFraction, pausedOrStalledFraction: $pausedOrStalledFraction, queuedFraction: $queuedFraction)';
}


}

/// @nodoc
abstract mixin class $RightNowSummaryCopyWith<$Res>  {
  factory $RightNowSummaryCopyWith(RightNowSummary value, $Res Function(RightNowSummary) _then) = _$RightNowSummaryCopyWithImpl;
@useResult
$Res call({
 int downloadSpeed, int uploadSpeed, int downloadingCount, int seedingCount, int? etaToNextFinishSeconds, double downloadingFraction, double pausedOrStalledFraction, double queuedFraction
});




}
/// @nodoc
class _$RightNowSummaryCopyWithImpl<$Res>
    implements $RightNowSummaryCopyWith<$Res> {
  _$RightNowSummaryCopyWithImpl(this._self, this._then);

  final RightNowSummary _self;
  final $Res Function(RightNowSummary) _then;

/// Create a copy of RightNowSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloadSpeed = null,Object? uploadSpeed = null,Object? downloadingCount = null,Object? seedingCount = null,Object? etaToNextFinishSeconds = freezed,Object? downloadingFraction = null,Object? pausedOrStalledFraction = null,Object? queuedFraction = null,}) {
  return _then(RightNowSummary(
downloadSpeed: null == downloadSpeed ? _self.downloadSpeed : downloadSpeed // ignore: cast_nullable_to_non_nullable
as int,uploadSpeed: null == uploadSpeed ? _self.uploadSpeed : uploadSpeed // ignore: cast_nullable_to_non_nullable
as int,downloadingCount: null == downloadingCount ? _self.downloadingCount : downloadingCount // ignore: cast_nullable_to_non_nullable
as int,seedingCount: null == seedingCount ? _self.seedingCount : seedingCount // ignore: cast_nullable_to_non_nullable
as int,etaToNextFinishSeconds: freezed == etaToNextFinishSeconds ? _self.etaToNextFinishSeconds : etaToNextFinishSeconds // ignore: cast_nullable_to_non_nullable
as int?,downloadingFraction: null == downloadingFraction ? _self.downloadingFraction : downloadingFraction // ignore: cast_nullable_to_non_nullable
as double,pausedOrStalledFraction: null == pausedOrStalledFraction ? _self.pausedOrStalledFraction : pausedOrStalledFraction // ignore: cast_nullable_to_non_nullable
as double,queuedFraction: null == queuedFraction ? _self.queuedFraction : queuedFraction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RightNowSummary].
extension RightNowSummaryPatterns on RightNowSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RightNowSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RightNowSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RightNowSummary value)  $default,){
final _that = this;
switch (_that) {
case _RightNowSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RightNowSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RightNowSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int downloadSpeed,  int uploadSpeed,  int downloadingCount,  int seedingCount,  int? etaToNextFinishSeconds,  double downloadingFraction,  double pausedOrStalledFraction,  double queuedFraction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RightNowSummary() when $default != null:
return $default(_that.downloadSpeed,_that.uploadSpeed,_that.downloadingCount,_that.seedingCount,_that.etaToNextFinishSeconds,_that.downloadingFraction,_that.pausedOrStalledFraction,_that.queuedFraction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int downloadSpeed,  int uploadSpeed,  int downloadingCount,  int seedingCount,  int? etaToNextFinishSeconds,  double downloadingFraction,  double pausedOrStalledFraction,  double queuedFraction)  $default,) {final _that = this;
switch (_that) {
case _RightNowSummary():
return $default(_that.downloadSpeed,_that.uploadSpeed,_that.downloadingCount,_that.seedingCount,_that.etaToNextFinishSeconds,_that.downloadingFraction,_that.pausedOrStalledFraction,_that.queuedFraction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int downloadSpeed,  int uploadSpeed,  int downloadingCount,  int seedingCount,  int? etaToNextFinishSeconds,  double downloadingFraction,  double pausedOrStalledFraction,  double queuedFraction)?  $default,) {final _that = this;
switch (_that) {
case _RightNowSummary() when $default != null:
return $default(_that.downloadSpeed,_that.uploadSpeed,_that.downloadingCount,_that.seedingCount,_that.etaToNextFinishSeconds,_that.downloadingFraction,_that.pausedOrStalledFraction,_that.queuedFraction);case _:
  return null;

}
}

}

/// @nodoc


class _RightNowSummary implements RightNowSummary {
  const _RightNowSummary({required this.downloadSpeed, required this.uploadSpeed, required this.downloadingCount, required this.seedingCount, this.etaToNextFinishSeconds, required this.downloadingFraction, required this.pausedOrStalledFraction, required this.queuedFraction});
  

@override final  int downloadSpeed;
@override final  int uploadSpeed;
@override final  int downloadingCount;
@override final  int seedingCount;
@override final  int? etaToNextFinishSeconds;
@override final  double downloadingFraction;
@override final  double pausedOrStalledFraction;
@override final  double queuedFraction;

/// Create a copy of RightNowSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RightNowSummaryCopyWith<_RightNowSummary> get copyWith => __$RightNowSummaryCopyWithImpl<_RightNowSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RightNowSummary&&(identical(other.downloadSpeed, downloadSpeed) || other.downloadSpeed == downloadSpeed)&&(identical(other.uploadSpeed, uploadSpeed) || other.uploadSpeed == uploadSpeed)&&(identical(other.downloadingCount, downloadingCount) || other.downloadingCount == downloadingCount)&&(identical(other.seedingCount, seedingCount) || other.seedingCount == seedingCount)&&(identical(other.etaToNextFinishSeconds, etaToNextFinishSeconds) || other.etaToNextFinishSeconds == etaToNextFinishSeconds)&&(identical(other.downloadingFraction, downloadingFraction) || other.downloadingFraction == downloadingFraction)&&(identical(other.pausedOrStalledFraction, pausedOrStalledFraction) || other.pausedOrStalledFraction == pausedOrStalledFraction)&&(identical(other.queuedFraction, queuedFraction) || other.queuedFraction == queuedFraction));
}


@override
int get hashCode => Object.hash(runtimeType,downloadSpeed,uploadSpeed,downloadingCount,seedingCount,etaToNextFinishSeconds,downloadingFraction,pausedOrStalledFraction,queuedFraction);

@override
String toString() {
  return 'RightNowSummary(downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, downloadingCount: $downloadingCount, seedingCount: $seedingCount, etaToNextFinishSeconds: $etaToNextFinishSeconds, downloadingFraction: $downloadingFraction, pausedOrStalledFraction: $pausedOrStalledFraction, queuedFraction: $queuedFraction)';
}


}

/// @nodoc
abstract mixin class _$RightNowSummaryCopyWith<$Res> implements $RightNowSummaryCopyWith<$Res> {
  factory _$RightNowSummaryCopyWith(_RightNowSummary value, $Res Function(_RightNowSummary) _then) = __$RightNowSummaryCopyWithImpl;
@override @useResult
$Res call({
 int downloadSpeed, int uploadSpeed, int downloadingCount, int seedingCount, int? etaToNextFinishSeconds, double downloadingFraction, double pausedOrStalledFraction, double queuedFraction
});




}
/// @nodoc
class __$RightNowSummaryCopyWithImpl<$Res>
    implements _$RightNowSummaryCopyWith<$Res> {
  __$RightNowSummaryCopyWithImpl(this._self, this._then);

  final _RightNowSummary _self;
  final $Res Function(_RightNowSummary) _then;

/// Create a copy of RightNowSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloadSpeed = null,Object? uploadSpeed = null,Object? downloadingCount = null,Object? seedingCount = null,Object? etaToNextFinishSeconds = freezed,Object? downloadingFraction = null,Object? pausedOrStalledFraction = null,Object? queuedFraction = null,}) {
  return _then(_RightNowSummary(
downloadSpeed: null == downloadSpeed ? _self.downloadSpeed : downloadSpeed // ignore: cast_nullable_to_non_nullable
as int,uploadSpeed: null == uploadSpeed ? _self.uploadSpeed : uploadSpeed // ignore: cast_nullable_to_non_nullable
as int,downloadingCount: null == downloadingCount ? _self.downloadingCount : downloadingCount // ignore: cast_nullable_to_non_nullable
as int,seedingCount: null == seedingCount ? _self.seedingCount : seedingCount // ignore: cast_nullable_to_non_nullable
as int,etaToNextFinishSeconds: freezed == etaToNextFinishSeconds ? _self.etaToNextFinishSeconds : etaToNextFinishSeconds // ignore: cast_nullable_to_non_nullable
as int?,downloadingFraction: null == downloadingFraction ? _self.downloadingFraction : downloadingFraction // ignore: cast_nullable_to_non_nullable
as double,pausedOrStalledFraction: null == pausedOrStalledFraction ? _self.pausedOrStalledFraction : pausedOrStalledFraction // ignore: cast_nullable_to_non_nullable
as double,queuedFraction: null == queuedFraction ? _self.queuedFraction : queuedFraction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
