// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'einthusan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EinthusanJob {

 String get id; JobState get state;@JsonKey(name: 'einthusan_url') String get einthusanUrl; List<TmdbCandidate> get candidates;@JsonKey(name: 'selected_tmdb_id') int? get selectedTmdbId; JobProgress? get progress; JobResult? get result; JobErrorInfo? get error;
/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EinthusanJobCopyWith<EinthusanJob> get copyWith => _$EinthusanJobCopyWithImpl<EinthusanJob>(this as EinthusanJob, _$identity);

  /// Serializes this EinthusanJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EinthusanJob&&(identical(other.id, id) || other.id == id)&&(identical(other.state, state) || other.state == state)&&(identical(other.einthusanUrl, einthusanUrl) || other.einthusanUrl == einthusanUrl)&&const DeepCollectionEquality().equals(other.candidates, candidates)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,state,einthusanUrl,const DeepCollectionEquality().hash(candidates),selectedTmdbId,progress,result,error);

@override
String toString() {
  return 'EinthusanJob(id: $id, state: $state, einthusanUrl: $einthusanUrl, candidates: $candidates, selectedTmdbId: $selectedTmdbId, progress: $progress, result: $result, error: $error)';
}


}

/// @nodoc
abstract mixin class $EinthusanJobCopyWith<$Res>  {
  factory $EinthusanJobCopyWith(EinthusanJob value, $Res Function(EinthusanJob) _then) = _$EinthusanJobCopyWithImpl;
@useResult
$Res call({
 String id, JobState state,@JsonKey(name: 'einthusan_url') String einthusanUrl, List<TmdbCandidate> candidates,@JsonKey(name: 'selected_tmdb_id') int? selectedTmdbId, JobProgress? progress, JobResult? result, JobErrorInfo? error
});


$JobProgressCopyWith<$Res>? get progress;$JobResultCopyWith<$Res>? get result;$JobErrorInfoCopyWith<$Res>? get error;

}
/// @nodoc
class _$EinthusanJobCopyWithImpl<$Res>
    implements $EinthusanJobCopyWith<$Res> {
  _$EinthusanJobCopyWithImpl(this._self, this._then);

  final EinthusanJob _self;
  final $Res Function(EinthusanJob) _then;

/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? state = null,Object? einthusanUrl = null,Object? candidates = null,Object? selectedTmdbId = freezed,Object? progress = freezed,Object? result = freezed,Object? error = freezed,}) {
  return _then(EinthusanJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JobState,einthusanUrl: null == einthusanUrl ? _self.einthusanUrl : einthusanUrl // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<TmdbCandidate>,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as JobProgress?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as JobResult?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as JobErrorInfo?,
  ));
}
/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $JobProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $JobResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobErrorInfoCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $JobErrorInfoCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [EinthusanJob].
extension EinthusanJobPatterns on EinthusanJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EinthusanJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EinthusanJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EinthusanJob value)  $default,){
final _that = this;
switch (_that) {
case _EinthusanJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EinthusanJob value)?  $default,){
final _that = this;
switch (_that) {
case _EinthusanJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  JobState state, @JsonKey(name: 'einthusan_url')  String einthusanUrl,  List<TmdbCandidate> candidates, @JsonKey(name: 'selected_tmdb_id')  int? selectedTmdbId,  JobProgress? progress,  JobResult? result,  JobErrorInfo? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EinthusanJob() when $default != null:
return $default(_that.id,_that.state,_that.einthusanUrl,_that.candidates,_that.selectedTmdbId,_that.progress,_that.result,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  JobState state, @JsonKey(name: 'einthusan_url')  String einthusanUrl,  List<TmdbCandidate> candidates, @JsonKey(name: 'selected_tmdb_id')  int? selectedTmdbId,  JobProgress? progress,  JobResult? result,  JobErrorInfo? error)  $default,) {final _that = this;
switch (_that) {
case _EinthusanJob():
return $default(_that.id,_that.state,_that.einthusanUrl,_that.candidates,_that.selectedTmdbId,_that.progress,_that.result,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  JobState state, @JsonKey(name: 'einthusan_url')  String einthusanUrl,  List<TmdbCandidate> candidates, @JsonKey(name: 'selected_tmdb_id')  int? selectedTmdbId,  JobProgress? progress,  JobResult? result,  JobErrorInfo? error)?  $default,) {final _that = this;
switch (_that) {
case _EinthusanJob() when $default != null:
return $default(_that.id,_that.state,_that.einthusanUrl,_that.candidates,_that.selectedTmdbId,_that.progress,_that.result,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EinthusanJob implements EinthusanJob {
  const _EinthusanJob({required this.id, required this.state, @JsonKey(name: 'einthusan_url') required this.einthusanUrl,  List<TmdbCandidate> candidates = const [], @JsonKey(name: 'selected_tmdb_id') this.selectedTmdbId, this.progress, this.result, this.error}): _candidates = candidates;
  factory _EinthusanJob.fromJson(Map<String, dynamic> json) => _$EinthusanJobFromJson(json);

@override final  String id;
@override final  JobState state;
@override@JsonKey(name: 'einthusan_url') final  String einthusanUrl;
 final  List<TmdbCandidate> _candidates;
@override@JsonKey() List<TmdbCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

@override@JsonKey(name: 'selected_tmdb_id') final  int? selectedTmdbId;
@override final  JobProgress? progress;
@override final  JobResult? result;
@override final  JobErrorInfo? error;

/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EinthusanJobCopyWith<_EinthusanJob> get copyWith => __$EinthusanJobCopyWithImpl<_EinthusanJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EinthusanJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EinthusanJob&&(identical(other.id, id) || other.id == id)&&(identical(other.state, state) || other.state == state)&&(identical(other.einthusanUrl, einthusanUrl) || other.einthusanUrl == einthusanUrl)&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&(identical(other.selectedTmdbId, selectedTmdbId) || other.selectedTmdbId == selectedTmdbId)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,state,einthusanUrl,const DeepCollectionEquality().hash(_candidates),selectedTmdbId,progress,result,error);

@override
String toString() {
  return 'EinthusanJob(id: $id, state: $state, einthusanUrl: $einthusanUrl, candidates: $candidates, selectedTmdbId: $selectedTmdbId, progress: $progress, result: $result, error: $error)';
}


}

/// @nodoc
abstract mixin class _$EinthusanJobCopyWith<$Res> implements $EinthusanJobCopyWith<$Res> {
  factory _$EinthusanJobCopyWith(_EinthusanJob value, $Res Function(_EinthusanJob) _then) = __$EinthusanJobCopyWithImpl;
@override @useResult
$Res call({
 String id, JobState state,@JsonKey(name: 'einthusan_url') String einthusanUrl, List<TmdbCandidate> candidates,@JsonKey(name: 'selected_tmdb_id') int? selectedTmdbId, JobProgress? progress, JobResult? result, JobErrorInfo? error
});


@override $JobProgressCopyWith<$Res>? get progress;@override $JobResultCopyWith<$Res>? get result;@override $JobErrorInfoCopyWith<$Res>? get error;

}
/// @nodoc
class __$EinthusanJobCopyWithImpl<$Res>
    implements _$EinthusanJobCopyWith<$Res> {
  __$EinthusanJobCopyWithImpl(this._self, this._then);

  final _EinthusanJob _self;
  final $Res Function(_EinthusanJob) _then;

/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? state = null,Object? einthusanUrl = null,Object? candidates = null,Object? selectedTmdbId = freezed,Object? progress = freezed,Object? result = freezed,Object? error = freezed,}) {
  return _then(_EinthusanJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JobState,einthusanUrl: null == einthusanUrl ? _self.einthusanUrl : einthusanUrl // ignore: cast_nullable_to_non_nullable
as String,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<TmdbCandidate>,selectedTmdbId: freezed == selectedTmdbId ? _self.selectedTmdbId : selectedTmdbId // ignore: cast_nullable_to_non_nullable
as int?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as JobProgress?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as JobResult?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as JobErrorInfo?,
  ));
}

/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $JobProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $JobResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}/// Create a copy of EinthusanJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobErrorInfoCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $JobErrorInfoCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$TmdbCandidate {

@JsonKey(name: 'tmdb_id') int get tmdbId; String get title; int get year;@JsonKey(name: 'tmdb_url') String get tmdbUrl;@JsonKey(name: 'poster_url') String? get posterUrl;
/// Create a copy of TmdbCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TmdbCandidateCopyWith<TmdbCandidate> get copyWith => _$TmdbCandidateCopyWithImpl<TmdbCandidate>(this as TmdbCandidate, _$identity);

  /// Serializes this TmdbCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TmdbCandidate&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.tmdbUrl, tmdbUrl) || other.tmdbUrl == tmdbUrl)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,year,tmdbUrl,posterUrl);

@override
String toString() {
  return 'TmdbCandidate(tmdbId: $tmdbId, title: $title, year: $year, tmdbUrl: $tmdbUrl, posterUrl: $posterUrl)';
}


}

/// @nodoc
abstract mixin class $TmdbCandidateCopyWith<$Res>  {
  factory $TmdbCandidateCopyWith(TmdbCandidate value, $Res Function(TmdbCandidate) _then) = _$TmdbCandidateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tmdb_id') int tmdbId, String title, int year,@JsonKey(name: 'tmdb_url') String tmdbUrl,@JsonKey(name: 'poster_url') String? posterUrl
});




}
/// @nodoc
class _$TmdbCandidateCopyWithImpl<$Res>
    implements $TmdbCandidateCopyWith<$Res> {
  _$TmdbCandidateCopyWithImpl(this._self, this._then);

  final TmdbCandidate _self;
  final $Res Function(TmdbCandidate) _then;

/// Create a copy of TmdbCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tmdbId = null,Object? title = null,Object? year = null,Object? tmdbUrl = null,Object? posterUrl = freezed,}) {
  return _then(TmdbCandidate(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,tmdbUrl: null == tmdbUrl ? _self.tmdbUrl : tmdbUrl // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TmdbCandidate].
extension TmdbCandidatePatterns on TmdbCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TmdbCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TmdbCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TmdbCandidate value)  $default,){
final _that = this;
switch (_that) {
case _TmdbCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TmdbCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _TmdbCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tmdb_id')  int tmdbId,  String title,  int year, @JsonKey(name: 'tmdb_url')  String tmdbUrl, @JsonKey(name: 'poster_url')  String? posterUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TmdbCandidate() when $default != null:
return $default(_that.tmdbId,_that.title,_that.year,_that.tmdbUrl,_that.posterUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tmdb_id')  int tmdbId,  String title,  int year, @JsonKey(name: 'tmdb_url')  String tmdbUrl, @JsonKey(name: 'poster_url')  String? posterUrl)  $default,) {final _that = this;
switch (_that) {
case _TmdbCandidate():
return $default(_that.tmdbId,_that.title,_that.year,_that.tmdbUrl,_that.posterUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tmdb_id')  int tmdbId,  String title,  int year, @JsonKey(name: 'tmdb_url')  String tmdbUrl, @JsonKey(name: 'poster_url')  String? posterUrl)?  $default,) {final _that = this;
switch (_that) {
case _TmdbCandidate() when $default != null:
return $default(_that.tmdbId,_that.title,_that.year,_that.tmdbUrl,_that.posterUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TmdbCandidate implements TmdbCandidate {
  const _TmdbCandidate({@JsonKey(name: 'tmdb_id') required this.tmdbId, required this.title, required this.year, @JsonKey(name: 'tmdb_url') required this.tmdbUrl, @JsonKey(name: 'poster_url') this.posterUrl});
  factory _TmdbCandidate.fromJson(Map<String, dynamic> json) => _$TmdbCandidateFromJson(json);

@override@JsonKey(name: 'tmdb_id') final  int tmdbId;
@override final  String title;
@override final  int year;
@override@JsonKey(name: 'tmdb_url') final  String tmdbUrl;
@override@JsonKey(name: 'poster_url') final  String? posterUrl;

/// Create a copy of TmdbCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TmdbCandidateCopyWith<_TmdbCandidate> get copyWith => __$TmdbCandidateCopyWithImpl<_TmdbCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TmdbCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TmdbCandidate&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.tmdbUrl, tmdbUrl) || other.tmdbUrl == tmdbUrl)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,year,tmdbUrl,posterUrl);

@override
String toString() {
  return 'TmdbCandidate(tmdbId: $tmdbId, title: $title, year: $year, tmdbUrl: $tmdbUrl, posterUrl: $posterUrl)';
}


}

/// @nodoc
abstract mixin class _$TmdbCandidateCopyWith<$Res> implements $TmdbCandidateCopyWith<$Res> {
  factory _$TmdbCandidateCopyWith(_TmdbCandidate value, $Res Function(_TmdbCandidate) _then) = __$TmdbCandidateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tmdb_id') int tmdbId, String title, int year,@JsonKey(name: 'tmdb_url') String tmdbUrl,@JsonKey(name: 'poster_url') String? posterUrl
});




}
/// @nodoc
class __$TmdbCandidateCopyWithImpl<$Res>
    implements _$TmdbCandidateCopyWith<$Res> {
  __$TmdbCandidateCopyWithImpl(this._self, this._then);

  final _TmdbCandidate _self;
  final $Res Function(_TmdbCandidate) _then;

/// Create a copy of TmdbCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tmdbId = null,Object? title = null,Object? year = null,Object? tmdbUrl = null,Object? posterUrl = freezed,}) {
  return _then(_TmdbCandidate(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,tmdbUrl: null == tmdbUrl ? _self.tmdbUrl : tmdbUrl // ignore: cast_nullable_to_non_nullable
as String,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JobProgress {

@JsonKey(name: 'downloaded_bytes') int get downloadedBytes;@JsonKey(name: 'total_bytes') int get totalBytes; double get percent;@JsonKey(name: 'speed_bps') double get speedBps;@JsonKey(name: 'eta_seconds') double? get etaSeconds;
/// Create a copy of JobProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobProgressCopyWith<JobProgress> get copyWith => _$JobProgressCopyWithImpl<JobProgress>(this as JobProgress, _$identity);

  /// Serializes this JobProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobProgress&&(identical(other.downloadedBytes, downloadedBytes) || other.downloadedBytes == downloadedBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.speedBps, speedBps) || other.speedBps == speedBps)&&(identical(other.etaSeconds, etaSeconds) || other.etaSeconds == etaSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadedBytes,totalBytes,percent,speedBps,etaSeconds);

@override
String toString() {
  return 'JobProgress(downloadedBytes: $downloadedBytes, totalBytes: $totalBytes, percent: $percent, speedBps: $speedBps, etaSeconds: $etaSeconds)';
}


}

/// @nodoc
abstract mixin class $JobProgressCopyWith<$Res>  {
  factory $JobProgressCopyWith(JobProgress value, $Res Function(JobProgress) _then) = _$JobProgressCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'downloaded_bytes') int downloadedBytes,@JsonKey(name: 'total_bytes') int totalBytes, double percent,@JsonKey(name: 'speed_bps') double speedBps,@JsonKey(name: 'eta_seconds') double? etaSeconds
});




}
/// @nodoc
class _$JobProgressCopyWithImpl<$Res>
    implements $JobProgressCopyWith<$Res> {
  _$JobProgressCopyWithImpl(this._self, this._then);

  final JobProgress _self;
  final $Res Function(JobProgress) _then;

/// Create a copy of JobProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloadedBytes = null,Object? totalBytes = null,Object? percent = null,Object? speedBps = null,Object? etaSeconds = freezed,}) {
  return _then(JobProgress(
downloadedBytes: null == downloadedBytes ? _self.downloadedBytes : downloadedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,speedBps: null == speedBps ? _self.speedBps : speedBps // ignore: cast_nullable_to_non_nullable
as double,etaSeconds: freezed == etaSeconds ? _self.etaSeconds : etaSeconds // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobProgress].
extension JobProgressPatterns on JobProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobProgress value)  $default,){
final _that = this;
switch (_that) {
case _JobProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobProgress value)?  $default,){
final _that = this;
switch (_that) {
case _JobProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'downloaded_bytes')  int downloadedBytes, @JsonKey(name: 'total_bytes')  int totalBytes,  double percent, @JsonKey(name: 'speed_bps')  double speedBps, @JsonKey(name: 'eta_seconds')  double? etaSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobProgress() when $default != null:
return $default(_that.downloadedBytes,_that.totalBytes,_that.percent,_that.speedBps,_that.etaSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'downloaded_bytes')  int downloadedBytes, @JsonKey(name: 'total_bytes')  int totalBytes,  double percent, @JsonKey(name: 'speed_bps')  double speedBps, @JsonKey(name: 'eta_seconds')  double? etaSeconds)  $default,) {final _that = this;
switch (_that) {
case _JobProgress():
return $default(_that.downloadedBytes,_that.totalBytes,_that.percent,_that.speedBps,_that.etaSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'downloaded_bytes')  int downloadedBytes, @JsonKey(name: 'total_bytes')  int totalBytes,  double percent, @JsonKey(name: 'speed_bps')  double speedBps, @JsonKey(name: 'eta_seconds')  double? etaSeconds)?  $default,) {final _that = this;
switch (_that) {
case _JobProgress() when $default != null:
return $default(_that.downloadedBytes,_that.totalBytes,_that.percent,_that.speedBps,_that.etaSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobProgress implements JobProgress {
  const _JobProgress({@JsonKey(name: 'downloaded_bytes') required this.downloadedBytes, @JsonKey(name: 'total_bytes') required this.totalBytes, required this.percent, @JsonKey(name: 'speed_bps') required this.speedBps, @JsonKey(name: 'eta_seconds') this.etaSeconds});
  factory _JobProgress.fromJson(Map<String, dynamic> json) => _$JobProgressFromJson(json);

@override@JsonKey(name: 'downloaded_bytes') final  int downloadedBytes;
@override@JsonKey(name: 'total_bytes') final  int totalBytes;
@override final  double percent;
@override@JsonKey(name: 'speed_bps') final  double speedBps;
@override@JsonKey(name: 'eta_seconds') final  double? etaSeconds;

/// Create a copy of JobProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobProgressCopyWith<_JobProgress> get copyWith => __$JobProgressCopyWithImpl<_JobProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobProgress&&(identical(other.downloadedBytes, downloadedBytes) || other.downloadedBytes == downloadedBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.speedBps, speedBps) || other.speedBps == speedBps)&&(identical(other.etaSeconds, etaSeconds) || other.etaSeconds == etaSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadedBytes,totalBytes,percent,speedBps,etaSeconds);

@override
String toString() {
  return 'JobProgress(downloadedBytes: $downloadedBytes, totalBytes: $totalBytes, percent: $percent, speedBps: $speedBps, etaSeconds: $etaSeconds)';
}


}

/// @nodoc
abstract mixin class _$JobProgressCopyWith<$Res> implements $JobProgressCopyWith<$Res> {
  factory _$JobProgressCopyWith(_JobProgress value, $Res Function(_JobProgress) _then) = __$JobProgressCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'downloaded_bytes') int downloadedBytes,@JsonKey(name: 'total_bytes') int totalBytes, double percent,@JsonKey(name: 'speed_bps') double speedBps,@JsonKey(name: 'eta_seconds') double? etaSeconds
});




}
/// @nodoc
class __$JobProgressCopyWithImpl<$Res>
    implements _$JobProgressCopyWith<$Res> {
  __$JobProgressCopyWithImpl(this._self, this._then);

  final _JobProgress _self;
  final $Res Function(_JobProgress) _then;

/// Create a copy of JobProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloadedBytes = null,Object? totalBytes = null,Object? percent = null,Object? speedBps = null,Object? etaSeconds = freezed,}) {
  return _then(_JobProgress(
downloadedBytes: null == downloadedBytes ? _self.downloadedBytes : downloadedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,speedBps: null == speedBps ? _self.speedBps : speedBps // ignore: cast_nullable_to_non_nullable
as double,etaSeconds: freezed == etaSeconds ? _self.etaSeconds : etaSeconds // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$JobResult {

 String get file;@JsonKey(name: 'radarr_movie_id') int get radarrMovieId;@JsonKey(name: 'tmdb_id') int get tmdbId;
/// Create a copy of JobResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobResultCopyWith<JobResult> get copyWith => _$JobResultCopyWithImpl<JobResult>(this as JobResult, _$identity);

  /// Serializes this JobResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobResult&&(identical(other.file, file) || other.file == file)&&(identical(other.radarrMovieId, radarrMovieId) || other.radarrMovieId == radarrMovieId)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,radarrMovieId,tmdbId);

@override
String toString() {
  return 'JobResult(file: $file, radarrMovieId: $radarrMovieId, tmdbId: $tmdbId)';
}


}

/// @nodoc
abstract mixin class $JobResultCopyWith<$Res>  {
  factory $JobResultCopyWith(JobResult value, $Res Function(JobResult) _then) = _$JobResultCopyWithImpl;
@useResult
$Res call({
 String file,@JsonKey(name: 'radarr_movie_id') int radarrMovieId,@JsonKey(name: 'tmdb_id') int tmdbId
});




}
/// @nodoc
class _$JobResultCopyWithImpl<$Res>
    implements $JobResultCopyWith<$Res> {
  _$JobResultCopyWithImpl(this._self, this._then);

  final JobResult _self;
  final $Res Function(JobResult) _then;

/// Create a copy of JobResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? file = null,Object? radarrMovieId = null,Object? tmdbId = null,}) {
  return _then(JobResult(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,radarrMovieId: null == radarrMovieId ? _self.radarrMovieId : radarrMovieId // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobResult].
extension JobResultPatterns on JobResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobResult value)  $default,){
final _that = this;
switch (_that) {
case _JobResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobResult value)?  $default,){
final _that = this;
switch (_that) {
case _JobResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String file, @JsonKey(name: 'radarr_movie_id')  int radarrMovieId, @JsonKey(name: 'tmdb_id')  int tmdbId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobResult() when $default != null:
return $default(_that.file,_that.radarrMovieId,_that.tmdbId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String file, @JsonKey(name: 'radarr_movie_id')  int radarrMovieId, @JsonKey(name: 'tmdb_id')  int tmdbId)  $default,) {final _that = this;
switch (_that) {
case _JobResult():
return $default(_that.file,_that.radarrMovieId,_that.tmdbId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String file, @JsonKey(name: 'radarr_movie_id')  int radarrMovieId, @JsonKey(name: 'tmdb_id')  int tmdbId)?  $default,) {final _that = this;
switch (_that) {
case _JobResult() when $default != null:
return $default(_that.file,_that.radarrMovieId,_that.tmdbId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobResult implements JobResult {
  const _JobResult({required this.file, @JsonKey(name: 'radarr_movie_id') required this.radarrMovieId, @JsonKey(name: 'tmdb_id') required this.tmdbId});
  factory _JobResult.fromJson(Map<String, dynamic> json) => _$JobResultFromJson(json);

@override final  String file;
@override@JsonKey(name: 'radarr_movie_id') final  int radarrMovieId;
@override@JsonKey(name: 'tmdb_id') final  int tmdbId;

/// Create a copy of JobResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobResultCopyWith<_JobResult> get copyWith => __$JobResultCopyWithImpl<_JobResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobResult&&(identical(other.file, file) || other.file == file)&&(identical(other.radarrMovieId, radarrMovieId) || other.radarrMovieId == radarrMovieId)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,radarrMovieId,tmdbId);

@override
String toString() {
  return 'JobResult(file: $file, radarrMovieId: $radarrMovieId, tmdbId: $tmdbId)';
}


}

/// @nodoc
abstract mixin class _$JobResultCopyWith<$Res> implements $JobResultCopyWith<$Res> {
  factory _$JobResultCopyWith(_JobResult value, $Res Function(_JobResult) _then) = __$JobResultCopyWithImpl;
@override @useResult
$Res call({
 String file,@JsonKey(name: 'radarr_movie_id') int radarrMovieId,@JsonKey(name: 'tmdb_id') int tmdbId
});




}
/// @nodoc
class __$JobResultCopyWithImpl<$Res>
    implements _$JobResultCopyWith<$Res> {
  __$JobResultCopyWithImpl(this._self, this._then);

  final _JobResult _self;
  final $Res Function(_JobResult) _then;

/// Create a copy of JobResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? file = null,Object? radarrMovieId = null,Object? tmdbId = null,}) {
  return _then(_JobResult(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,radarrMovieId: null == radarrMovieId ? _self.radarrMovieId : radarrMovieId // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$JobErrorInfo {

 String get code; String get message;
/// Create a copy of JobErrorInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobErrorInfoCopyWith<JobErrorInfo> get copyWith => _$JobErrorInfoCopyWithImpl<JobErrorInfo>(this as JobErrorInfo, _$identity);

  /// Serializes this JobErrorInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobErrorInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'JobErrorInfo(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $JobErrorInfoCopyWith<$Res>  {
  factory $JobErrorInfoCopyWith(JobErrorInfo value, $Res Function(JobErrorInfo) _then) = _$JobErrorInfoCopyWithImpl;
@useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class _$JobErrorInfoCopyWithImpl<$Res>
    implements $JobErrorInfoCopyWith<$Res> {
  _$JobErrorInfoCopyWithImpl(this._self, this._then);

  final JobErrorInfo _self;
  final $Res Function(JobErrorInfo) _then;

/// Create a copy of JobErrorInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,}) {
  return _then(JobErrorInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JobErrorInfo].
extension JobErrorInfoPatterns on JobErrorInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobErrorInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobErrorInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobErrorInfo value)  $default,){
final _that = this;
switch (_that) {
case _JobErrorInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobErrorInfo value)?  $default,){
final _that = this;
switch (_that) {
case _JobErrorInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobErrorInfo() when $default != null:
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message)  $default,) {final _that = this;
switch (_that) {
case _JobErrorInfo():
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message)?  $default,) {final _that = this;
switch (_that) {
case _JobErrorInfo() when $default != null:
return $default(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobErrorInfo implements JobErrorInfo {
  const _JobErrorInfo({required this.code, required this.message});
  factory _JobErrorInfo.fromJson(Map<String, dynamic> json) => _$JobErrorInfoFromJson(json);

@override final  String code;
@override final  String message;

/// Create a copy of JobErrorInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobErrorInfoCopyWith<_JobErrorInfo> get copyWith => __$JobErrorInfoCopyWithImpl<_JobErrorInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobErrorInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobErrorInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'JobErrorInfo(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$JobErrorInfoCopyWith<$Res> implements $JobErrorInfoCopyWith<$Res> {
  factory _$JobErrorInfoCopyWith(_JobErrorInfo value, $Res Function(_JobErrorInfo) _then) = __$JobErrorInfoCopyWithImpl;
@override @useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class __$JobErrorInfoCopyWithImpl<$Res>
    implements _$JobErrorInfoCopyWith<$Res> {
  __$JobErrorInfoCopyWithImpl(this._self, this._then);

  final _JobErrorInfo _self;
  final $Res Function(_JobErrorInfo) _then;

/// Create a copy of JobErrorInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,}) {
  return _then(_JobErrorInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
