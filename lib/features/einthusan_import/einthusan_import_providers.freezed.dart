// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'einthusan_import_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EinthusanImportState {

 EinthusanJob? get job; int? get selectedTmdbId; bool get isSubmitting; AppError? get lastError;
/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EinthusanImportStateCopyWith<EinthusanImportState> get copyWith => _$EinthusanImportStateCopyWithImpl<EinthusanImportState>(this as EinthusanImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EinthusanImportState&&(identical(other.job, job) || other.job == job)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,job,selectedTmdbId,isSubmitting,lastError);

@override
String toString() {
  return 'EinthusanImportState(job: $job, selectedTmdbId: $selectedTmdbId, isSubmitting: $isSubmitting, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $EinthusanImportStateCopyWith<$Res>  {
  factory $EinthusanImportStateCopyWith(EinthusanImportState value, $Res Function(EinthusanImportState) _then) = _$EinthusanImportStateCopyWithImpl;
@useResult
$Res call({
 EinthusanJob? job, int? selectedTmdbId, bool isSubmitting, AppError? lastError
});


$EinthusanJobCopyWith<$Res>? get job;

}
/// @nodoc
class _$EinthusanImportStateCopyWithImpl<$Res>
    implements $EinthusanImportStateCopyWith<$Res> {
  _$EinthusanImportStateCopyWithImpl(this._self, this._then);

  final EinthusanImportState _self;
  final $Res Function(EinthusanImportState) _then;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = freezed,Object? selectedTmdbId = freezed,Object? isSubmitting = null,Object? lastError = freezed,}) {
  return _then(EinthusanImportState(
job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as EinthusanJob?,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}
/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EinthusanJobCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $EinthusanJobCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [EinthusanImportState].
extension EinthusanImportStatePatterns on EinthusanImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EinthusanImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EinthusanImportState value)  $default,){
final _that = this;
switch (_that) {
case _EinthusanImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EinthusanImportState value)?  $default,){
final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EinthusanJob? job,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
return $default(_that.job,_that.selectedTmdbId,_that.isSubmitting,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EinthusanJob? job,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError)  $default,) {final _that = this;
switch (_that) {
case _EinthusanImportState():
return $default(_that.job,_that.selectedTmdbId,_that.isSubmitting,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EinthusanJob? job,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError)?  $default,) {final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
return $default(_that.job,_that.selectedTmdbId,_that.isSubmitting,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc


class _EinthusanImportState implements EinthusanImportState {
  const _EinthusanImportState({this.job, this.selectedTmdbId, this.isSubmitting = false, this.lastError});
  

@override final  EinthusanJob? job;
@override final  int? selectedTmdbId;
@override@JsonKey() final  bool isSubmitting;
@override final  AppError? lastError;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EinthusanImportStateCopyWith<_EinthusanImportState> get copyWith => __$EinthusanImportStateCopyWithImpl<_EinthusanImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EinthusanImportState&&(identical(other.job, job) || other.job == job)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,job,selectedTmdbId,isSubmitting,lastError);

@override
String toString() {
  return 'EinthusanImportState(job: $job, selectedTmdbId: $selectedTmdbId, isSubmitting: $isSubmitting, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$EinthusanImportStateCopyWith<$Res> implements $EinthusanImportStateCopyWith<$Res> {
  factory _$EinthusanImportStateCopyWith(_EinthusanImportState value, $Res Function(_EinthusanImportState) _then) = __$EinthusanImportStateCopyWithImpl;
@override @useResult
$Res call({
 EinthusanJob? job, int? selectedTmdbId, bool isSubmitting, AppError? lastError
});


@override $EinthusanJobCopyWith<$Res>? get job;

}
/// @nodoc
class __$EinthusanImportStateCopyWithImpl<$Res>
    implements _$EinthusanImportStateCopyWith<$Res> {
  __$EinthusanImportStateCopyWithImpl(this._self, this._then);

  final _EinthusanImportState _self;
  final $Res Function(_EinthusanImportState) _then;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = freezed,Object? selectedTmdbId = freezed,Object? isSubmitting = null,Object? lastError = freezed,}) {
  return _then(_EinthusanImportState(
job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as EinthusanJob?,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EinthusanJobCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $EinthusanJobCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
