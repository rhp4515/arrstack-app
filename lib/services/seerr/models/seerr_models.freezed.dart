// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seerr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeerrResult {

 int get id; String get mediaType; String? get title; String? get name; String? get posterPath; String? get backdropPath; String? get overview; String? get releaseDate; String? get firstAirDate; double? get voteAverage; SeerrMediaInfo? get mediaInfo;
/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrResultCopyWith<SeerrResult> get copyWith => _$SeerrResultCopyWithImpl<SeerrResult>(this as SeerrResult, _$identity);

  /// Serializes this SeerrResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrResult&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaInfo, mediaInfo) || other.mediaInfo == mediaInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,title,name,posterPath,backdropPath,overview,releaseDate,firstAirDate,voteAverage,mediaInfo);

@override
String toString() {
  return 'SeerrResult(id: $id, mediaType: $mediaType, title: $title, name: $name, posterPath: $posterPath, backdropPath: $backdropPath, overview: $overview, releaseDate: $releaseDate, firstAirDate: $firstAirDate, voteAverage: $voteAverage, mediaInfo: $mediaInfo)';
}


}

/// @nodoc
abstract mixin class $SeerrResultCopyWith<$Res>  {
  factory $SeerrResultCopyWith(SeerrResult value, $Res Function(SeerrResult) _then) = _$SeerrResultCopyWithImpl;
@useResult
$Res call({
 int id, String mediaType, String? title, String? name, String? posterPath, String? backdropPath, String? overview, String? releaseDate, String? firstAirDate, double? voteAverage, SeerrMediaInfo? mediaInfo
});


$SeerrMediaInfoCopyWith<$Res>? get mediaInfo;

}
/// @nodoc
class _$SeerrResultCopyWithImpl<$Res>
    implements $SeerrResultCopyWith<$Res> {
  _$SeerrResultCopyWithImpl(this._self, this._then);

  final SeerrResult _self;
  final $Res Function(SeerrResult) _then;

/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaType = null,Object? title = freezed,Object? name = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? overview = freezed,Object? releaseDate = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? mediaInfo = freezed,}) {
  return _then(SeerrResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,mediaInfo: freezed == mediaInfo ? _self.mediaInfo : mediaInfo // ignore: cast_nullable_to_non_nullable
as SeerrMediaInfo?,
  ));
}
/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrMediaInfoCopyWith<$Res>? get mediaInfo {
    if (_self.mediaInfo == null) {
    return null;
  }

  return $SeerrMediaInfoCopyWith<$Res>(_self.mediaInfo!, (value) {
    return _then(_self.copyWith(mediaInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeerrResult].
extension SeerrResultPatterns on SeerrResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrResult value)  $default,){
final _that = this;
switch (_that) {
case _SeerrResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrResult value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String mediaType,  String? title,  String? name,  String? posterPath,  String? backdropPath,  String? overview,  String? releaseDate,  String? firstAirDate,  double? voteAverage,  SeerrMediaInfo? mediaInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrResult() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.name,_that.posterPath,_that.backdropPath,_that.overview,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String mediaType,  String? title,  String? name,  String? posterPath,  String? backdropPath,  String? overview,  String? releaseDate,  String? firstAirDate,  double? voteAverage,  SeerrMediaInfo? mediaInfo)  $default,) {final _that = this;
switch (_that) {
case _SeerrResult():
return $default(_that.id,_that.mediaType,_that.title,_that.name,_that.posterPath,_that.backdropPath,_that.overview,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String mediaType,  String? title,  String? name,  String? posterPath,  String? backdropPath,  String? overview,  String? releaseDate,  String? firstAirDate,  double? voteAverage,  SeerrMediaInfo? mediaInfo)?  $default,) {final _that = this;
switch (_that) {
case _SeerrResult() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.name,_that.posterPath,_that.backdropPath,_that.overview,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrResult implements SeerrResult {
  const _SeerrResult({required this.id, required this.mediaType, this.title, this.name, this.posterPath, this.backdropPath, this.overview, this.releaseDate, this.firstAirDate, this.voteAverage, this.mediaInfo});
  factory _SeerrResult.fromJson(Map<String, dynamic> json) => _$SeerrResultFromJson(json);

@override final  int id;
@override final  String mediaType;
@override final  String? title;
@override final  String? name;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  String? overview;
@override final  String? releaseDate;
@override final  String? firstAirDate;
@override final  double? voteAverage;
@override final  SeerrMediaInfo? mediaInfo;

/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrResultCopyWith<_SeerrResult> get copyWith => __$SeerrResultCopyWithImpl<_SeerrResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrResult&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaInfo, mediaInfo) || other.mediaInfo == mediaInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,title,name,posterPath,backdropPath,overview,releaseDate,firstAirDate,voteAverage,mediaInfo);

@override
String toString() {
  return 'SeerrResult(id: $id, mediaType: $mediaType, title: $title, name: $name, posterPath: $posterPath, backdropPath: $backdropPath, overview: $overview, releaseDate: $releaseDate, firstAirDate: $firstAirDate, voteAverage: $voteAverage, mediaInfo: $mediaInfo)';
}


}

/// @nodoc
abstract mixin class _$SeerrResultCopyWith<$Res> implements $SeerrResultCopyWith<$Res> {
  factory _$SeerrResultCopyWith(_SeerrResult value, $Res Function(_SeerrResult) _then) = __$SeerrResultCopyWithImpl;
@override @useResult
$Res call({
 int id, String mediaType, String? title, String? name, String? posterPath, String? backdropPath, String? overview, String? releaseDate, String? firstAirDate, double? voteAverage, SeerrMediaInfo? mediaInfo
});


@override $SeerrMediaInfoCopyWith<$Res>? get mediaInfo;

}
/// @nodoc
class __$SeerrResultCopyWithImpl<$Res>
    implements _$SeerrResultCopyWith<$Res> {
  __$SeerrResultCopyWithImpl(this._self, this._then);

  final _SeerrResult _self;
  final $Res Function(_SeerrResult) _then;

/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaType = null,Object? title = freezed,Object? name = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? overview = freezed,Object? releaseDate = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? mediaInfo = freezed,}) {
  return _then(_SeerrResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,mediaInfo: freezed == mediaInfo ? _self.mediaInfo : mediaInfo // ignore: cast_nullable_to_non_nullable
as SeerrMediaInfo?,
  ));
}

/// Create a copy of SeerrResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrMediaInfoCopyWith<$Res>? get mediaInfo {
    if (_self.mediaInfo == null) {
    return null;
  }

  return $SeerrMediaInfoCopyWith<$Res>(_self.mediaInfo!, (value) {
    return _then(_self.copyWith(mediaInfo: value));
  });
}
}


/// @nodoc
mixin _$SeerrMediaInfo {

 int get id; int get tmdbId; int? get tvdbId; int get status; List<SeerrRequest> get requests;
/// Create a copy of SeerrMediaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrMediaInfoCopyWith<SeerrMediaInfo> get copyWith => _$SeerrMediaInfoCopyWithImpl<SeerrMediaInfo>(this as SeerrMediaInfo, _$identity);

  /// Serializes this SeerrMediaInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrMediaInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.requests, requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,tvdbId,status,const DeepCollectionEquality().hash(requests));

@override
String toString() {
  return 'SeerrMediaInfo(id: $id, tmdbId: $tmdbId, tvdbId: $tvdbId, status: $status, requests: $requests)';
}


}

/// @nodoc
abstract mixin class $SeerrMediaInfoCopyWith<$Res>  {
  factory $SeerrMediaInfoCopyWith(SeerrMediaInfo value, $Res Function(SeerrMediaInfo) _then) = _$SeerrMediaInfoCopyWithImpl;
@useResult
$Res call({
 int id, int tmdbId, int? tvdbId, int status, List<SeerrRequest> requests
});




}
/// @nodoc
class _$SeerrMediaInfoCopyWithImpl<$Res>
    implements $SeerrMediaInfoCopyWith<$Res> {
  _$SeerrMediaInfoCopyWithImpl(this._self, this._then);

  final SeerrMediaInfo _self;
  final $Res Function(SeerrMediaInfo) _then;

/// Create a copy of SeerrMediaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbId = null,Object? tvdbId = freezed,Object? status = null,Object? requests = null,}) {
  return _then(SeerrMediaInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<SeerrRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrMediaInfo].
extension SeerrMediaInfoPatterns on SeerrMediaInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrMediaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrMediaInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrMediaInfo value)  $default,){
final _that = this;
switch (_that) {
case _SeerrMediaInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrMediaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrMediaInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrMediaInfo() when $default != null:
return $default(_that.id,_that.tmdbId,_that.tvdbId,_that.status,_that.requests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)  $default,) {final _that = this;
switch (_that) {
case _SeerrMediaInfo():
return $default(_that.id,_that.tmdbId,_that.tvdbId,_that.status,_that.requests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)?  $default,) {final _that = this;
switch (_that) {
case _SeerrMediaInfo() when $default != null:
return $default(_that.id,_that.tmdbId,_that.tvdbId,_that.status,_that.requests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrMediaInfo implements SeerrMediaInfo {
  const _SeerrMediaInfo({required this.id, required this.tmdbId, this.tvdbId, required this.status, required  List<SeerrRequest> requests}): _requests = requests;
  factory _SeerrMediaInfo.fromJson(Map<String, dynamic> json) => _$SeerrMediaInfoFromJson(json);

@override final  int id;
@override final  int tmdbId;
@override final  int? tvdbId;
@override final  int status;
 final  List<SeerrRequest> _requests;
@override List<SeerrRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}


/// Create a copy of SeerrMediaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrMediaInfoCopyWith<_SeerrMediaInfo> get copyWith => __$SeerrMediaInfoCopyWithImpl<_SeerrMediaInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrMediaInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrMediaInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._requests, _requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,tvdbId,status,const DeepCollectionEquality().hash(_requests));

@override
String toString() {
  return 'SeerrMediaInfo(id: $id, tmdbId: $tmdbId, tvdbId: $tvdbId, status: $status, requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$SeerrMediaInfoCopyWith<$Res> implements $SeerrMediaInfoCopyWith<$Res> {
  factory _$SeerrMediaInfoCopyWith(_SeerrMediaInfo value, $Res Function(_SeerrMediaInfo) _then) = __$SeerrMediaInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, int tmdbId, int? tvdbId, int status, List<SeerrRequest> requests
});




}
/// @nodoc
class __$SeerrMediaInfoCopyWithImpl<$Res>
    implements _$SeerrMediaInfoCopyWith<$Res> {
  __$SeerrMediaInfoCopyWithImpl(this._self, this._then);

  final _SeerrMediaInfo _self;
  final $Res Function(_SeerrMediaInfo) _then;

/// Create a copy of SeerrMediaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbId = null,Object? tvdbId = freezed,Object? status = null,Object? requests = null,}) {
  return _then(_SeerrMediaInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<SeerrRequest>,
  ));
}


}


/// @nodoc
mixin _$SeerrRequest {

 int get id; int get status; int get mediaType; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestCopyWith<SeerrRequest> get copyWith => _$SeerrRequestCopyWithImpl<SeerrRequest>(this as SeerrRequest, _$identity);

  /// Serializes this SeerrRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,mediaType,createdAt,updatedAt);

@override
String toString() {
  return 'SeerrRequest(id: $id, status: $status, mediaType: $mediaType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestCopyWith<$Res>  {
  factory $SeerrRequestCopyWith(SeerrRequest value, $Res Function(SeerrRequest) _then) = _$SeerrRequestCopyWithImpl;
@useResult
$Res call({
 int id, int status, int mediaType, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SeerrRequestCopyWithImpl<$Res>
    implements $SeerrRequestCopyWith<$Res> {
  _$SeerrRequestCopyWithImpl(this._self, this._then);

  final SeerrRequest _self;
  final $Res Function(SeerrRequest) _then;

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? mediaType = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(SeerrRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrRequest].
extension SeerrRequestPatterns on SeerrRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrRequest value)  $default,){
final _that = this;
switch (_that) {
case _SeerrRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int status,  int mediaType,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
return $default(_that.id,_that.status,_that.mediaType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int status,  int mediaType,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequest():
return $default(_that.id,_that.status,_that.mediaType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int status,  int mediaType,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
return $default(_that.id,_that.status,_that.mediaType,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequest implements SeerrRequest {
  const _SeerrRequest({required this.id, required this.status, required this.mediaType, required this.createdAt, required this.updatedAt});
  factory _SeerrRequest.fromJson(Map<String, dynamic> json) => _$SeerrRequestFromJson(json);

@override final  int id;
@override final  int status;
@override final  int mediaType;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrRequestCopyWith<_SeerrRequest> get copyWith => __$SeerrRequestCopyWithImpl<_SeerrRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,mediaType,createdAt,updatedAt);

@override
String toString() {
  return 'SeerrRequest(id: $id, status: $status, mediaType: $mediaType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestCopyWith<$Res> implements $SeerrRequestCopyWith<$Res> {
  factory _$SeerrRequestCopyWith(_SeerrRequest value, $Res Function(_SeerrRequest) _then) = __$SeerrRequestCopyWithImpl;
@override @useResult
$Res call({
 int id, int status, int mediaType, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SeerrRequestCopyWithImpl<$Res>
    implements _$SeerrRequestCopyWith<$Res> {
  __$SeerrRequestCopyWithImpl(this._self, this._then);

  final _SeerrRequest _self;
  final $Res Function(_SeerrRequest) _then;

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? mediaType = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SeerrRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SeerrDiscoveryResponse {

 int get page; int get totalPages; int get totalResults; List<SeerrResult> get results;
/// Create a copy of SeerrDiscoveryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrDiscoveryResponseCopyWith<SeerrDiscoveryResponse> get copyWith => _$SeerrDiscoveryResponseCopyWithImpl<SeerrDiscoveryResponse>(this as SeerrDiscoveryResponse, _$identity);

  /// Serializes this SeerrDiscoveryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrDiscoveryResponse&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,totalPages,totalResults,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SeerrDiscoveryResponse(page: $page, totalPages: $totalPages, totalResults: $totalResults, results: $results)';
}


}

/// @nodoc
abstract mixin class $SeerrDiscoveryResponseCopyWith<$Res>  {
  factory $SeerrDiscoveryResponseCopyWith(SeerrDiscoveryResponse value, $Res Function(SeerrDiscoveryResponse) _then) = _$SeerrDiscoveryResponseCopyWithImpl;
@useResult
$Res call({
 int page, int totalPages, int totalResults, List<SeerrResult> results
});




}
/// @nodoc
class _$SeerrDiscoveryResponseCopyWithImpl<$Res>
    implements $SeerrDiscoveryResponseCopyWith<$Res> {
  _$SeerrDiscoveryResponseCopyWithImpl(this._self, this._then);

  final SeerrDiscoveryResponse _self;
  final $Res Function(SeerrDiscoveryResponse) _then;

/// Create a copy of SeerrDiscoveryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? totalPages = null,Object? totalResults = null,Object? results = null,}) {
  return _then(SeerrDiscoveryResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SeerrResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrDiscoveryResponse].
extension SeerrDiscoveryResponsePatterns on SeerrDiscoveryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrDiscoveryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrDiscoveryResponse value)  $default,){
final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrDiscoveryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int totalPages,  int totalResults,  List<SeerrResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse() when $default != null:
return $default(_that.page,_that.totalPages,_that.totalResults,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int totalPages,  int totalResults,  List<SeerrResult> results)  $default,) {final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse():
return $default(_that.page,_that.totalPages,_that.totalResults,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int totalPages,  int totalResults,  List<SeerrResult> results)?  $default,) {final _that = this;
switch (_that) {
case _SeerrDiscoveryResponse() when $default != null:
return $default(_that.page,_that.totalPages,_that.totalResults,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrDiscoveryResponse implements SeerrDiscoveryResponse {
  const _SeerrDiscoveryResponse({required this.page, required this.totalPages, required this.totalResults, required  List<SeerrResult> results}): _results = results;
  factory _SeerrDiscoveryResponse.fromJson(Map<String, dynamic> json) => _$SeerrDiscoveryResponseFromJson(json);

@override final  int page;
@override final  int totalPages;
@override final  int totalResults;
 final  List<SeerrResult> _results;
@override List<SeerrResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SeerrDiscoveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrDiscoveryResponseCopyWith<_SeerrDiscoveryResponse> get copyWith => __$SeerrDiscoveryResponseCopyWithImpl<_SeerrDiscoveryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrDiscoveryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrDiscoveryResponse&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,totalPages,totalResults,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SeerrDiscoveryResponse(page: $page, totalPages: $totalPages, totalResults: $totalResults, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SeerrDiscoveryResponseCopyWith<$Res> implements $SeerrDiscoveryResponseCopyWith<$Res> {
  factory _$SeerrDiscoveryResponseCopyWith(_SeerrDiscoveryResponse value, $Res Function(_SeerrDiscoveryResponse) _then) = __$SeerrDiscoveryResponseCopyWithImpl;
@override @useResult
$Res call({
 int page, int totalPages, int totalResults, List<SeerrResult> results
});




}
/// @nodoc
class __$SeerrDiscoveryResponseCopyWithImpl<$Res>
    implements _$SeerrDiscoveryResponseCopyWith<$Res> {
  __$SeerrDiscoveryResponseCopyWithImpl(this._self, this._then);

  final _SeerrDiscoveryResponse _self;
  final $Res Function(_SeerrDiscoveryResponse) _then;

/// Create a copy of SeerrDiscoveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? totalPages = null,Object? totalResults = null,Object? results = null,}) {
  return _then(_SeerrDiscoveryResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SeerrResult>,
  ));
}


}

// dart format on
