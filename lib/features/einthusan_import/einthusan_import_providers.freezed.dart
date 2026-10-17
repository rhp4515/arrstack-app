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
mixin _$TrackedImportJob {

 EinthusanJobRecord get record;/// The latest live job; null until the downloader has been asked about
/// a job restored from history.
 EinthusanJob? get job;/// A job that was still in progress when the downloader stopped
/// listing it (it restarted), so its outcome is unknown.
 bool get isLost;
/// Create a copy of TrackedImportJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackedImportJobCopyWith<TrackedImportJob> get copyWith => _$TrackedImportJobCopyWithImpl<TrackedImportJob>(this as TrackedImportJob, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedImportJob&&(identical(other.record, record) || other.record == record)&&(identical(other.job, job) || other.job == job)&&(identical(other.isLost, isLost) || other.isLost == isLost));
}


@override
int get hashCode => Object.hash(runtimeType,record,job,isLost);

@override
String toString() {
  return 'TrackedImportJob(record: $record, job: $job, isLost: $isLost)';
}


}

/// @nodoc
abstract mixin class $TrackedImportJobCopyWith<$Res>  {
  factory $TrackedImportJobCopyWith(TrackedImportJob value, $Res Function(TrackedImportJob) _then) = _$TrackedImportJobCopyWithImpl;
@useResult
$Res call({
 EinthusanJobRecord record, EinthusanJob? job, bool isLost
});


$EinthusanJobCopyWith<$Res>? get job;

}
/// @nodoc
class _$TrackedImportJobCopyWithImpl<$Res>
    implements $TrackedImportJobCopyWith<$Res> {
  _$TrackedImportJobCopyWithImpl(this._self, this._then);

  final TrackedImportJob _self;
  final $Res Function(TrackedImportJob) _then;

/// Create a copy of TrackedImportJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? record = null,Object? job = freezed,Object? isLost = null,}) {
  return _then(TrackedImportJob(
record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as EinthusanJobRecord,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as EinthusanJob?,isLost: null == isLost ? _self.isLost : isLost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TrackedImportJob
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


/// Adds pattern-matching-related methods to [TrackedImportJob].
extension TrackedImportJobPatterns on TrackedImportJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackedImportJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackedImportJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackedImportJob value)  $default,){
final _that = this;
switch (_that) {
case _TrackedImportJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackedImportJob value)?  $default,){
final _that = this;
switch (_that) {
case _TrackedImportJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EinthusanJobRecord record,  EinthusanJob? job,  bool isLost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackedImportJob() when $default != null:
return $default(_that.record,_that.job,_that.isLost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EinthusanJobRecord record,  EinthusanJob? job,  bool isLost)  $default,) {final _that = this;
switch (_that) {
case _TrackedImportJob():
return $default(_that.record,_that.job,_that.isLost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EinthusanJobRecord record,  EinthusanJob? job,  bool isLost)?  $default,) {final _that = this;
switch (_that) {
case _TrackedImportJob() when $default != null:
return $default(_that.record,_that.job,_that.isLost);case _:
  return null;

}
}

}

/// @nodoc


class _TrackedImportJob extends TrackedImportJob {
  const _TrackedImportJob({required this.record, this.job, this.isLost = false}): super._();
  

@override final  EinthusanJobRecord record;
/// The latest live job; null until the downloader has been asked about
/// a job restored from history.
@override final  EinthusanJob? job;
/// A job that was still in progress when the downloader stopped
/// listing it (it restarted), so its outcome is unknown.
@override@JsonKey() final  bool isLost;

/// Create a copy of TrackedImportJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackedImportJobCopyWith<_TrackedImportJob> get copyWith => __$TrackedImportJobCopyWithImpl<_TrackedImportJob>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackedImportJob&&(identical(other.record, record) || other.record == record)&&(identical(other.job, job) || other.job == job)&&(identical(other.isLost, isLost) || other.isLost == isLost));
}


@override
int get hashCode => Object.hash(runtimeType,record,job,isLost);

@override
String toString() {
  return 'TrackedImportJob(record: $record, job: $job, isLost: $isLost)';
}


}

/// @nodoc
abstract mixin class _$TrackedImportJobCopyWith<$Res> implements $TrackedImportJobCopyWith<$Res> {
  factory _$TrackedImportJobCopyWith(_TrackedImportJob value, $Res Function(_TrackedImportJob) _then) = __$TrackedImportJobCopyWithImpl;
@override @useResult
$Res call({
 EinthusanJobRecord record, EinthusanJob? job, bool isLost
});


@override $EinthusanJobCopyWith<$Res>? get job;

}
/// @nodoc
class __$TrackedImportJobCopyWithImpl<$Res>
    implements _$TrackedImportJobCopyWith<$Res> {
  __$TrackedImportJobCopyWithImpl(this._self, this._then);

  final _TrackedImportJob _self;
  final $Res Function(_TrackedImportJob) _then;

/// Create a copy of TrackedImportJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? record = null,Object? job = freezed,Object? isLost = null,}) {
  return _then(_TrackedImportJob(
record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as EinthusanJobRecord,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as EinthusanJob?,isLost: null == isLost ? _self.isLost : isLost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TrackedImportJob
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

/// @nodoc
mixin _$EinthusanImportState {

/// Tracked jobs, newest first.
 List<TrackedImportJob> get jobs;/// The job whose wizard step is on screen; null shows the input step
/// and the job list.
 String? get activeJobId; int? get selectedTmdbId; bool get isSubmitting; AppError? get lastError;/// The last attempt to list the downloader's jobs failed, so the jobs
/// shown are as last known.
 bool get serverUnreachable;
/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EinthusanImportStateCopyWith<EinthusanImportState> get copyWith => _$EinthusanImportStateCopyWithImpl<EinthusanImportState>(this as EinthusanImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EinthusanImportState&&const DeepCollectionEquality().equals(other.jobs, jobs)&&(identical(other.activeJobId, activeJobId) || other.activeJobId == activeJobId)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.serverUnreachable, serverUnreachable) || other.serverUnreachable == serverUnreachable));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jobs),activeJobId,selectedTmdbId,isSubmitting,lastError,serverUnreachable);

@override
String toString() {
  return 'EinthusanImportState(jobs: $jobs, activeJobId: $activeJobId, selectedTmdbId: $selectedTmdbId, isSubmitting: $isSubmitting, lastError: $lastError, serverUnreachable: $serverUnreachable)';
}


}

/// @nodoc
abstract mixin class $EinthusanImportStateCopyWith<$Res>  {
  factory $EinthusanImportStateCopyWith(EinthusanImportState value, $Res Function(EinthusanImportState) _then) = _$EinthusanImportStateCopyWithImpl;
@useResult
$Res call({
 List<TrackedImportJob> jobs, String? activeJobId, int? selectedTmdbId, bool isSubmitting, AppError? lastError, bool serverUnreachable
});




}
/// @nodoc
class _$EinthusanImportStateCopyWithImpl<$Res>
    implements $EinthusanImportStateCopyWith<$Res> {
  _$EinthusanImportStateCopyWithImpl(this._self, this._then);

  final EinthusanImportState _self;
  final $Res Function(EinthusanImportState) _then;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobs = null,Object? activeJobId = freezed,Object? selectedTmdbId = freezed,Object? isSubmitting = null,Object? lastError = freezed,Object? serverUnreachable = null,}) {
  return _then(EinthusanImportState(
jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<TrackedImportJob>,activeJobId: freezed == activeJobId ? _self.activeJobId : activeJobId // ignore: cast_nullable_to_non_nullable
as String?,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as AppError?,serverUnreachable: null == serverUnreachable ? _self.serverUnreachable : serverUnreachable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TrackedImportJob> jobs,  String? activeJobId,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError,  bool serverUnreachable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
return $default(_that.jobs,_that.activeJobId,_that.selectedTmdbId,_that.isSubmitting,_that.lastError,_that.serverUnreachable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TrackedImportJob> jobs,  String? activeJobId,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError,  bool serverUnreachable)  $default,) {final _that = this;
switch (_that) {
case _EinthusanImportState():
return $default(_that.jobs,_that.activeJobId,_that.selectedTmdbId,_that.isSubmitting,_that.lastError,_that.serverUnreachable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TrackedImportJob> jobs,  String? activeJobId,  int? selectedTmdbId,  bool isSubmitting,  AppError? lastError,  bool serverUnreachable)?  $default,) {final _that = this;
switch (_that) {
case _EinthusanImportState() when $default != null:
return $default(_that.jobs,_that.activeJobId,_that.selectedTmdbId,_that.isSubmitting,_that.lastError,_that.serverUnreachable);case _:
  return null;

}
}

}

/// @nodoc


class _EinthusanImportState extends EinthusanImportState {
  const _EinthusanImportState({ List<TrackedImportJob> jobs = const [], this.activeJobId, this.selectedTmdbId, this.isSubmitting = false, this.lastError, this.serverUnreachable = false}): _jobs = jobs,super._();
  

/// Tracked jobs, newest first.
 final  List<TrackedImportJob> _jobs;
/// Tracked jobs, newest first.
@override@JsonKey() List<TrackedImportJob> get jobs {
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jobs);
}

/// The job whose wizard step is on screen; null shows the input step
/// and the job list.
@override final  String? activeJobId;
@override final  int? selectedTmdbId;
@override@JsonKey() final  bool isSubmitting;
@override final  AppError? lastError;
/// The last attempt to list the downloader's jobs failed, so the jobs
/// shown are as last known.
@override@JsonKey() final  bool serverUnreachable;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EinthusanImportStateCopyWith<_EinthusanImportState> get copyWith => __$EinthusanImportStateCopyWithImpl<_EinthusanImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EinthusanImportState&&const DeepCollectionEquality().equals(other._jobs, _jobs)&&(identical(other.activeJobId, activeJobId) || other.activeJobId == activeJobId)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.serverUnreachable, serverUnreachable) || other.serverUnreachable == serverUnreachable));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jobs),activeJobId,selectedTmdbId,isSubmitting,lastError,serverUnreachable);

@override
String toString() {
  return 'EinthusanImportState(jobs: $jobs, activeJobId: $activeJobId, selectedTmdbId: $selectedTmdbId, isSubmitting: $isSubmitting, lastError: $lastError, serverUnreachable: $serverUnreachable)';
}


}

/// @nodoc
abstract mixin class _$EinthusanImportStateCopyWith<$Res> implements $EinthusanImportStateCopyWith<$Res> {
  factory _$EinthusanImportStateCopyWith(_EinthusanImportState value, $Res Function(_EinthusanImportState) _then) = __$EinthusanImportStateCopyWithImpl;
@override @useResult
$Res call({
 List<TrackedImportJob> jobs, String? activeJobId, int? selectedTmdbId, bool isSubmitting, AppError? lastError, bool serverUnreachable
});




}
/// @nodoc
class __$EinthusanImportStateCopyWithImpl<$Res>
    implements _$EinthusanImportStateCopyWith<$Res> {
  __$EinthusanImportStateCopyWithImpl(this._self, this._then);

  final _EinthusanImportState _self;
  final $Res Function(_EinthusanImportState) _then;

/// Create a copy of EinthusanImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobs = null,Object? activeJobId = freezed,Object? selectedTmdbId = freezed,Object? isSubmitting = null,Object? lastError = freezed,Object? serverUnreachable = null,}) {
  return _then(_EinthusanImportState(
jobs: null == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<TrackedImportJob>,activeJobId: freezed == activeJobId ? _self.activeJobId : activeJobId // ignore: cast_nullable_to_non_nullable
as String?,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as AppError?,serverUnreachable: null == serverUnreachable ? _self.serverUnreachable : serverUnreachable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
