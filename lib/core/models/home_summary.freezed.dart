// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeStatusLine {

 String get label; bool get isWarning;
/// Create a copy of HomeStatusLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStatusLineCopyWith<HomeStatusLine> get copyWith => _$HomeStatusLineCopyWithImpl<HomeStatusLine>(this as HomeStatusLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStatusLine&&(identical(other.label, label) || other.label == label)&&(identical(other.isWarning, isWarning) || other.isWarning == isWarning));
}


@override
int get hashCode => Object.hash(runtimeType,label,isWarning);

@override
String toString() {
  return 'HomeStatusLine(label: $label, isWarning: $isWarning)';
}


}

/// @nodoc
abstract mixin class $HomeStatusLineCopyWith<$Res>  {
  factory $HomeStatusLineCopyWith(HomeStatusLine value, $Res Function(HomeStatusLine) _then) = _$HomeStatusLineCopyWithImpl;
@useResult
$Res call({
 String label, bool isWarning
});




}
/// @nodoc
class _$HomeStatusLineCopyWithImpl<$Res>
    implements $HomeStatusLineCopyWith<$Res> {
  _$HomeStatusLineCopyWithImpl(this._self, this._then);

  final HomeStatusLine _self;
  final $Res Function(HomeStatusLine) _then;

/// Create a copy of HomeStatusLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? isWarning = null,}) {
  return _then(HomeStatusLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isWarning: null == isWarning ? _self.isWarning : isWarning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeStatusLine].
extension HomeStatusLinePatterns on HomeStatusLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeStatusLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeStatusLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeStatusLine value)  $default,){
final _that = this;
switch (_that) {
case _HomeStatusLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeStatusLine value)?  $default,){
final _that = this;
switch (_that) {
case _HomeStatusLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  bool isWarning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeStatusLine() when $default != null:
return $default(_that.label,_that.isWarning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  bool isWarning)  $default,) {final _that = this;
switch (_that) {
case _HomeStatusLine():
return $default(_that.label,_that.isWarning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  bool isWarning)?  $default,) {final _that = this;
switch (_that) {
case _HomeStatusLine() when $default != null:
return $default(_that.label,_that.isWarning);case _:
  return null;

}
}

}

/// @nodoc


class _HomeStatusLine implements HomeStatusLine {
  const _HomeStatusLine({required this.label, required this.isWarning});
  

@override final  String label;
@override final  bool isWarning;

/// Create a copy of HomeStatusLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStatusLineCopyWith<_HomeStatusLine> get copyWith => __$HomeStatusLineCopyWithImpl<_HomeStatusLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeStatusLine&&(identical(other.label, label) || other.label == label)&&(identical(other.isWarning, isWarning) || other.isWarning == isWarning));
}


@override
int get hashCode => Object.hash(runtimeType,label,isWarning);

@override
String toString() {
  return 'HomeStatusLine(label: $label, isWarning: $isWarning)';
}


}

/// @nodoc
abstract mixin class _$HomeStatusLineCopyWith<$Res> implements $HomeStatusLineCopyWith<$Res> {
  factory _$HomeStatusLineCopyWith(_HomeStatusLine value, $Res Function(_HomeStatusLine) _then) = __$HomeStatusLineCopyWithImpl;
@override @useResult
$Res call({
 String label, bool isWarning
});




}
/// @nodoc
class __$HomeStatusLineCopyWithImpl<$Res>
    implements _$HomeStatusLineCopyWith<$Res> {
  __$HomeStatusLineCopyWithImpl(this._self, this._then);

  final _HomeStatusLine _self;
  final $Res Function(_HomeStatusLine) _then;

/// Create a copy of HomeStatusLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? isWarning = null,}) {
  return _then(_HomeStatusLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isWarning: null == isWarning ? _self.isWarning : isWarning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$HomeSummary {

 int get healthy; int get total; List<HomeStatusLine> get statusLines;
/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSummaryCopyWith<HomeSummary> get copyWith => _$HomeSummaryCopyWithImpl<HomeSummary>(this as HomeSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSummary&&(identical(other.healthy, healthy) || other.healthy == healthy)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.statusLines, statusLines));
}


@override
int get hashCode => Object.hash(runtimeType,healthy,total,const DeepCollectionEquality().hash(statusLines));

@override
String toString() {
  return 'HomeSummary(healthy: $healthy, total: $total, statusLines: $statusLines)';
}


}

/// @nodoc
abstract mixin class $HomeSummaryCopyWith<$Res>  {
  factory $HomeSummaryCopyWith(HomeSummary value, $Res Function(HomeSummary) _then) = _$HomeSummaryCopyWithImpl;
@useResult
$Res call({
 int healthy, int total, List<HomeStatusLine> statusLines
});




}
/// @nodoc
class _$HomeSummaryCopyWithImpl<$Res>
    implements $HomeSummaryCopyWith<$Res> {
  _$HomeSummaryCopyWithImpl(this._self, this._then);

  final HomeSummary _self;
  final $Res Function(HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? healthy = null,Object? total = null,Object? statusLines = null,}) {
  return _then(HomeSummary(
healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,statusLines: null == statusLines ? _self.statusLines : statusLines // ignore: cast_nullable_to_non_nullable
as List<HomeStatusLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeSummary].
extension HomeSummaryPatterns on HomeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int healthy,  int total,  List<HomeStatusLine> statusLines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.healthy,_that.total,_that.statusLines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int healthy,  int total,  List<HomeStatusLine> statusLines)  $default,) {final _that = this;
switch (_that) {
case _HomeSummary():
return $default(_that.healthy,_that.total,_that.statusLines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int healthy,  int total,  List<HomeStatusLine> statusLines)?  $default,) {final _that = this;
switch (_that) {
case _HomeSummary() when $default != null:
return $default(_that.healthy,_that.total,_that.statusLines);case _:
  return null;

}
}

}

/// @nodoc


class _HomeSummary implements HomeSummary {
  const _HomeSummary({required this.healthy, required this.total, required  List<HomeStatusLine> statusLines}): _statusLines = statusLines;
  

@override final  int healthy;
@override final  int total;
 final  List<HomeStatusLine> _statusLines;
@override List<HomeStatusLine> get statusLines {
  if (_statusLines is EqualUnmodifiableListView) return _statusLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusLines);
}


/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSummaryCopyWith<_HomeSummary> get copyWith => __$HomeSummaryCopyWithImpl<_HomeSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSummary&&(identical(other.healthy, healthy) || other.healthy == healthy)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._statusLines, _statusLines));
}


@override
int get hashCode => Object.hash(runtimeType,healthy,total,const DeepCollectionEquality().hash(_statusLines));

@override
String toString() {
  return 'HomeSummary(healthy: $healthy, total: $total, statusLines: $statusLines)';
}


}

/// @nodoc
abstract mixin class _$HomeSummaryCopyWith<$Res> implements $HomeSummaryCopyWith<$Res> {
  factory _$HomeSummaryCopyWith(_HomeSummary value, $Res Function(_HomeSummary) _then) = __$HomeSummaryCopyWithImpl;
@override @useResult
$Res call({
 int healthy, int total, List<HomeStatusLine> statusLines
});




}
/// @nodoc
class __$HomeSummaryCopyWithImpl<$Res>
    implements _$HomeSummaryCopyWith<$Res> {
  __$HomeSummaryCopyWithImpl(this._self, this._then);

  final _HomeSummary _self;
  final $Res Function(_HomeSummary) _then;

/// Create a copy of HomeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? healthy = null,Object? total = null,Object? statusLines = null,}) {
  return _then(_HomeSummary(
healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,statusLines: null == statusLines ? _self._statusLines : statusLines // ignore: cast_nullable_to_non_nullable
as List<HomeStatusLine>,
  ));
}


}

// dart format on
