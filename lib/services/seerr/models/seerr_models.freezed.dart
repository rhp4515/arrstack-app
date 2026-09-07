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
  const _SeerrResult({required this.id, this.mediaType = 'movie', this.title, this.name, this.posterPath, this.backdropPath, this.overview, this.releaseDate, this.firstAirDate, this.voteAverage, this.mediaInfo});
  factory _SeerrResult.fromJson(Map<String, dynamic> json) => _$SeerrResultFromJson(json);

@override final  int id;
@override@JsonKey() final  String mediaType;
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

 int get id; int? get tmdbId; int? get tvdbId; int get status; List<SeerrRequest> get requests;
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
 int id, int? tmdbId, int? tvdbId, int status, List<SeerrRequest> requests
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbId = freezed,Object? tvdbId = freezed,Object? status = null,Object? requests = null,}) {
  return _then(SeerrMediaInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? tmdbId,  int? tvdbId,  int status,  List<SeerrRequest> requests)?  $default,) {final _that = this;
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
  const _SeerrMediaInfo({required this.id, this.tmdbId, this.tvdbId, this.status = SeerrMediaStatus.unknown,  List<SeerrRequest> requests = const []}): _requests = requests;
  factory _SeerrMediaInfo.fromJson(Map<String, dynamic> json) => _$SeerrMediaInfoFromJson(json);

@override final  int id;
@override final  int? tmdbId;
@override final  int? tvdbId;
@override@JsonKey() final  int status;
 final  List<SeerrRequest> _requests;
@override@JsonKey() List<SeerrRequest> get requests {
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
 int id, int? tmdbId, int? tvdbId, int status, List<SeerrRequest> requests
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbId = freezed,Object? tvdbId = freezed,Object? status = null,Object? requests = null,}) {
  return _then(_SeerrMediaInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<SeerrRequest>,
  ));
}


}


/// @nodoc
mixin _$SeerrRequest {

 int get id; int get status; SeerrRequestMedia? get media; SeerrRequestUser? get requestedBy; List<SeerrRequestSeason> get seasons; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestCopyWith<SeerrRequest> get copyWith => _$SeerrRequestCopyWithImpl<SeerrRequest>(this as SeerrRequest, _$identity);

  /// Serializes this SeerrRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.media, media) || other.media == media)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&const DeepCollectionEquality().equals(other.seasons, seasons)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,media,requestedBy,const DeepCollectionEquality().hash(seasons),createdAt,updatedAt);

@override
String toString() {
  return 'SeerrRequest(id: $id, status: $status, media: $media, requestedBy: $requestedBy, seasons: $seasons, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestCopyWith<$Res>  {
  factory $SeerrRequestCopyWith(SeerrRequest value, $Res Function(SeerrRequest) _then) = _$SeerrRequestCopyWithImpl;
@useResult
$Res call({
 int id, int status, SeerrRequestMedia? media, SeerrRequestUser? requestedBy, List<SeerrRequestSeason> seasons, DateTime? createdAt, DateTime? updatedAt
});


$SeerrRequestMediaCopyWith<$Res>? get media;$SeerrRequestUserCopyWith<$Res>? get requestedBy;

}
/// @nodoc
class _$SeerrRequestCopyWithImpl<$Res>
    implements $SeerrRequestCopyWith<$Res> {
  _$SeerrRequestCopyWithImpl(this._self, this._then);

  final SeerrRequest _self;
  final $Res Function(SeerrRequest) _then;

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? media = freezed,Object? requestedBy = freezed,Object? seasons = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(SeerrRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as SeerrRequestMedia?,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as SeerrRequestUser?,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeerrRequestSeason>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrRequestMediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $SeerrRequestMediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrRequestUserCopyWith<$Res>? get requestedBy {
    if (_self.requestedBy == null) {
    return null;
  }

  return $SeerrRequestUserCopyWith<$Res>(_self.requestedBy!, (value) {
    return _then(_self.copyWith(requestedBy: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int status,  SeerrRequestMedia? media,  SeerrRequestUser? requestedBy,  List<SeerrRequestSeason> seasons,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
return $default(_that.id,_that.status,_that.media,_that.requestedBy,_that.seasons,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int status,  SeerrRequestMedia? media,  SeerrRequestUser? requestedBy,  List<SeerrRequestSeason> seasons,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequest():
return $default(_that.id,_that.status,_that.media,_that.requestedBy,_that.seasons,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int status,  SeerrRequestMedia? media,  SeerrRequestUser? requestedBy,  List<SeerrRequestSeason> seasons,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequest() when $default != null:
return $default(_that.id,_that.status,_that.media,_that.requestedBy,_that.seasons,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequest implements SeerrRequest {
  const _SeerrRequest({required this.id, this.status = SeerrRequestStatus.pending, this.media, this.requestedBy,  List<SeerrRequestSeason> seasons = const [], this.createdAt, this.updatedAt}): _seasons = seasons;
  factory _SeerrRequest.fromJson(Map<String, dynamic> json) => _$SeerrRequestFromJson(json);

@override final  int id;
@override@JsonKey() final  int status;
@override final  SeerrRequestMedia? media;
@override final  SeerrRequestUser? requestedBy;
 final  List<SeerrRequestSeason> _seasons;
@override@JsonKey() List<SeerrRequestSeason> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.media, media) || other.media == media)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&const DeepCollectionEquality().equals(other._seasons, _seasons)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,media,requestedBy,const DeepCollectionEquality().hash(_seasons),createdAt,updatedAt);

@override
String toString() {
  return 'SeerrRequest(id: $id, status: $status, media: $media, requestedBy: $requestedBy, seasons: $seasons, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestCopyWith<$Res> implements $SeerrRequestCopyWith<$Res> {
  factory _$SeerrRequestCopyWith(_SeerrRequest value, $Res Function(_SeerrRequest) _then) = __$SeerrRequestCopyWithImpl;
@override @useResult
$Res call({
 int id, int status, SeerrRequestMedia? media, SeerrRequestUser? requestedBy, List<SeerrRequestSeason> seasons, DateTime? createdAt, DateTime? updatedAt
});


@override $SeerrRequestMediaCopyWith<$Res>? get media;@override $SeerrRequestUserCopyWith<$Res>? get requestedBy;

}
/// @nodoc
class __$SeerrRequestCopyWithImpl<$Res>
    implements _$SeerrRequestCopyWith<$Res> {
  __$SeerrRequestCopyWithImpl(this._self, this._then);

  final _SeerrRequest _self;
  final $Res Function(_SeerrRequest) _then;

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? media = freezed,Object? requestedBy = freezed,Object? seasons = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SeerrRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as SeerrRequestMedia?,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as SeerrRequestUser?,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeerrRequestSeason>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrRequestMediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $SeerrRequestMediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of SeerrRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrRequestUserCopyWith<$Res>? get requestedBy {
    if (_self.requestedBy == null) {
    return null;
  }

  return $SeerrRequestUserCopyWith<$Res>(_self.requestedBy!, (value) {
    return _then(_self.copyWith(requestedBy: value));
  });
}
}


/// @nodoc
mixin _$SeerrRequestMedia {

 int get id; int? get tmdbId; String get mediaType; int get status;
/// Create a copy of SeerrRequestMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestMediaCopyWith<SeerrRequestMedia> get copyWith => _$SeerrRequestMediaCopyWithImpl<SeerrRequestMedia>(this as SeerrRequestMedia, _$identity);

  /// Serializes this SeerrRequestMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequestMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,mediaType,status);

@override
String toString() {
  return 'SeerrRequestMedia(id: $id, tmdbId: $tmdbId, mediaType: $mediaType, status: $status)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestMediaCopyWith<$Res>  {
  factory $SeerrRequestMediaCopyWith(SeerrRequestMedia value, $Res Function(SeerrRequestMedia) _then) = _$SeerrRequestMediaCopyWithImpl;
@useResult
$Res call({
 int id, int? tmdbId, String mediaType, int status
});




}
/// @nodoc
class _$SeerrRequestMediaCopyWithImpl<$Res>
    implements $SeerrRequestMediaCopyWith<$Res> {
  _$SeerrRequestMediaCopyWithImpl(this._self, this._then);

  final SeerrRequestMedia _self;
  final $Res Function(SeerrRequestMedia) _then;

/// Create a copy of SeerrRequestMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbId = freezed,Object? mediaType = null,Object? status = null,}) {
  return _then(SeerrRequestMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrRequestMedia].
extension SeerrRequestMediaPatterns on SeerrRequestMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrRequestMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrRequestMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrRequestMedia value)  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrRequestMedia value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  String mediaType,  int status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequestMedia() when $default != null:
return $default(_that.id,_that.tmdbId,_that.mediaType,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  String mediaType,  int status)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestMedia():
return $default(_that.id,_that.tmdbId,_that.mediaType,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? tmdbId,  String mediaType,  int status)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestMedia() when $default != null:
return $default(_that.id,_that.tmdbId,_that.mediaType,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequestMedia implements SeerrRequestMedia {
  const _SeerrRequestMedia({required this.id, this.tmdbId, this.mediaType = 'movie', this.status = SeerrMediaStatus.unknown});
  factory _SeerrRequestMedia.fromJson(Map<String, dynamic> json) => _$SeerrRequestMediaFromJson(json);

@override final  int id;
@override final  int? tmdbId;
@override@JsonKey() final  String mediaType;
@override@JsonKey() final  int status;

/// Create a copy of SeerrRequestMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrRequestMediaCopyWith<_SeerrRequestMedia> get copyWith => __$SeerrRequestMediaCopyWithImpl<_SeerrRequestMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrRequestMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequestMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,mediaType,status);

@override
String toString() {
  return 'SeerrRequestMedia(id: $id, tmdbId: $tmdbId, mediaType: $mediaType, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestMediaCopyWith<$Res> implements $SeerrRequestMediaCopyWith<$Res> {
  factory _$SeerrRequestMediaCopyWith(_SeerrRequestMedia value, $Res Function(_SeerrRequestMedia) _then) = __$SeerrRequestMediaCopyWithImpl;
@override @useResult
$Res call({
 int id, int? tmdbId, String mediaType, int status
});




}
/// @nodoc
class __$SeerrRequestMediaCopyWithImpl<$Res>
    implements _$SeerrRequestMediaCopyWith<$Res> {
  __$SeerrRequestMediaCopyWithImpl(this._self, this._then);

  final _SeerrRequestMedia _self;
  final $Res Function(_SeerrRequestMedia) _then;

/// Create a copy of SeerrRequestMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbId = freezed,Object? mediaType = null,Object? status = null,}) {
  return _then(_SeerrRequestMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SeerrRequestUser {

 String? get displayName; String? get email;
/// Create a copy of SeerrRequestUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestUserCopyWith<SeerrRequestUser> get copyWith => _$SeerrRequestUserCopyWithImpl<SeerrRequestUser>(this as SeerrRequestUser, _$identity);

  /// Serializes this SeerrRequestUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequestUser&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,email);

@override
String toString() {
  return 'SeerrRequestUser(displayName: $displayName, email: $email)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestUserCopyWith<$Res>  {
  factory $SeerrRequestUserCopyWith(SeerrRequestUser value, $Res Function(SeerrRequestUser) _then) = _$SeerrRequestUserCopyWithImpl;
@useResult
$Res call({
 String? displayName, String? email
});




}
/// @nodoc
class _$SeerrRequestUserCopyWithImpl<$Res>
    implements $SeerrRequestUserCopyWith<$Res> {
  _$SeerrRequestUserCopyWithImpl(this._self, this._then);

  final SeerrRequestUser _self;
  final $Res Function(SeerrRequestUser) _then;

/// Create a copy of SeerrRequestUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? email = freezed,}) {
  return _then(SeerrRequestUser(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrRequestUser].
extension SeerrRequestUserPatterns on SeerrRequestUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrRequestUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrRequestUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrRequestUser value)  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrRequestUser value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequestUser() when $default != null:
return $default(_that.displayName,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  String? email)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestUser():
return $default(_that.displayName,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestUser() when $default != null:
return $default(_that.displayName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequestUser implements SeerrRequestUser {
  const _SeerrRequestUser({this.displayName, this.email});
  factory _SeerrRequestUser.fromJson(Map<String, dynamic> json) => _$SeerrRequestUserFromJson(json);

@override final  String? displayName;
@override final  String? email;

/// Create a copy of SeerrRequestUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrRequestUserCopyWith<_SeerrRequestUser> get copyWith => __$SeerrRequestUserCopyWithImpl<_SeerrRequestUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrRequestUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequestUser&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,email);

@override
String toString() {
  return 'SeerrRequestUser(displayName: $displayName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestUserCopyWith<$Res> implements $SeerrRequestUserCopyWith<$Res> {
  factory _$SeerrRequestUserCopyWith(_SeerrRequestUser value, $Res Function(_SeerrRequestUser) _then) = __$SeerrRequestUserCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, String? email
});




}
/// @nodoc
class __$SeerrRequestUserCopyWithImpl<$Res>
    implements _$SeerrRequestUserCopyWith<$Res> {
  __$SeerrRequestUserCopyWithImpl(this._self, this._then);

  final _SeerrRequestUser _self;
  final $Res Function(_SeerrRequestUser) _then;

/// Create a copy of SeerrRequestUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? email = freezed,}) {
  return _then(_SeerrRequestUser(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SeerrRequestSeason {

 int get id; int get seasonNumber; int get status;
/// Create a copy of SeerrRequestSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestSeasonCopyWith<SeerrRequestSeason> get copyWith => _$SeerrRequestSeasonCopyWithImpl<SeerrRequestSeason>(this as SeerrRequestSeason, _$identity);

  /// Serializes this SeerrRequestSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequestSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,status);

@override
String toString() {
  return 'SeerrRequestSeason(id: $id, seasonNumber: $seasonNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestSeasonCopyWith<$Res>  {
  factory $SeerrRequestSeasonCopyWith(SeerrRequestSeason value, $Res Function(SeerrRequestSeason) _then) = _$SeerrRequestSeasonCopyWithImpl;
@useResult
$Res call({
 int id, int seasonNumber, int status
});




}
/// @nodoc
class _$SeerrRequestSeasonCopyWithImpl<$Res>
    implements $SeerrRequestSeasonCopyWith<$Res> {
  _$SeerrRequestSeasonCopyWithImpl(this._self, this._then);

  final SeerrRequestSeason _self;
  final $Res Function(SeerrRequestSeason) _then;

/// Create a copy of SeerrRequestSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonNumber = null,Object? status = null,}) {
  return _then(SeerrRequestSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrRequestSeason].
extension SeerrRequestSeasonPatterns on SeerrRequestSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrRequestSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrRequestSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrRequestSeason value)  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrRequestSeason value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  int status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequestSeason() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  int status)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestSeason():
return $default(_that.id,_that.seasonNumber,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seasonNumber,  int status)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestSeason() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequestSeason implements SeerrRequestSeason {
  const _SeerrRequestSeason({required this.id, required this.seasonNumber, this.status = SeerrRequestStatus.pending});
  factory _SeerrRequestSeason.fromJson(Map<String, dynamic> json) => _$SeerrRequestSeasonFromJson(json);

@override final  int id;
@override final  int seasonNumber;
@override@JsonKey() final  int status;

/// Create a copy of SeerrRequestSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrRequestSeasonCopyWith<_SeerrRequestSeason> get copyWith => __$SeerrRequestSeasonCopyWithImpl<_SeerrRequestSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrRequestSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequestSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,status);

@override
String toString() {
  return 'SeerrRequestSeason(id: $id, seasonNumber: $seasonNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestSeasonCopyWith<$Res> implements $SeerrRequestSeasonCopyWith<$Res> {
  factory _$SeerrRequestSeasonCopyWith(_SeerrRequestSeason value, $Res Function(_SeerrRequestSeason) _then) = __$SeerrRequestSeasonCopyWithImpl;
@override @useResult
$Res call({
 int id, int seasonNumber, int status
});




}
/// @nodoc
class __$SeerrRequestSeasonCopyWithImpl<$Res>
    implements _$SeerrRequestSeasonCopyWith<$Res> {
  __$SeerrRequestSeasonCopyWithImpl(this._self, this._then);

  final _SeerrRequestSeason _self;
  final $Res Function(_SeerrRequestSeason) _then;

/// Create a copy of SeerrRequestSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonNumber = null,Object? status = null,}) {
  return _then(_SeerrRequestSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SeerrPageInfo {

 int get page; int get pages; int get results; int get pageSize;
/// Create a copy of SeerrPageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrPageInfoCopyWith<SeerrPageInfo> get copyWith => _$SeerrPageInfoCopyWithImpl<SeerrPageInfo>(this as SeerrPageInfo, _$identity);

  /// Serializes this SeerrPageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrPageInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.results, results) || other.results == results)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,pages,results,pageSize);

@override
String toString() {
  return 'SeerrPageInfo(page: $page, pages: $pages, results: $results, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $SeerrPageInfoCopyWith<$Res>  {
  factory $SeerrPageInfoCopyWith(SeerrPageInfo value, $Res Function(SeerrPageInfo) _then) = _$SeerrPageInfoCopyWithImpl;
@useResult
$Res call({
 int page, int pages, int results, int pageSize
});




}
/// @nodoc
class _$SeerrPageInfoCopyWithImpl<$Res>
    implements $SeerrPageInfoCopyWith<$Res> {
  _$SeerrPageInfoCopyWithImpl(this._self, this._then);

  final SeerrPageInfo _self;
  final $Res Function(SeerrPageInfo) _then;

/// Create a copy of SeerrPageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? pages = null,Object? results = null,Object? pageSize = null,}) {
  return _then(SeerrPageInfo(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrPageInfo].
extension SeerrPageInfoPatterns on SeerrPageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrPageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrPageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrPageInfo value)  $default,){
final _that = this;
switch (_that) {
case _SeerrPageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrPageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrPageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int pages,  int results,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrPageInfo() when $default != null:
return $default(_that.page,_that.pages,_that.results,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int pages,  int results,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _SeerrPageInfo():
return $default(_that.page,_that.pages,_that.results,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int pages,  int results,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _SeerrPageInfo() when $default != null:
return $default(_that.page,_that.pages,_that.results,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrPageInfo implements SeerrPageInfo {
  const _SeerrPageInfo({this.page = 1, this.pages = 1, this.results = 0, this.pageSize = 20});
  factory _SeerrPageInfo.fromJson(Map<String, dynamic> json) => _$SeerrPageInfoFromJson(json);

@override@JsonKey() final  int page;
@override@JsonKey() final  int pages;
@override@JsonKey() final  int results;
@override@JsonKey() final  int pageSize;

/// Create a copy of SeerrPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrPageInfoCopyWith<_SeerrPageInfo> get copyWith => __$SeerrPageInfoCopyWithImpl<_SeerrPageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrPageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrPageInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.results, results) || other.results == results)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,pages,results,pageSize);

@override
String toString() {
  return 'SeerrPageInfo(page: $page, pages: $pages, results: $results, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$SeerrPageInfoCopyWith<$Res> implements $SeerrPageInfoCopyWith<$Res> {
  factory _$SeerrPageInfoCopyWith(_SeerrPageInfo value, $Res Function(_SeerrPageInfo) _then) = __$SeerrPageInfoCopyWithImpl;
@override @useResult
$Res call({
 int page, int pages, int results, int pageSize
});




}
/// @nodoc
class __$SeerrPageInfoCopyWithImpl<$Res>
    implements _$SeerrPageInfoCopyWith<$Res> {
  __$SeerrPageInfoCopyWithImpl(this._self, this._then);

  final _SeerrPageInfo _self;
  final $Res Function(_SeerrPageInfo) _then;

/// Create a copy of SeerrPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? pages = null,Object? results = null,Object? pageSize = null,}) {
  return _then(_SeerrPageInfo(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SeerrRequestsResponse {

 SeerrPageInfo get pageInfo; List<SeerrRequest> get results;
/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrRequestsResponseCopyWith<SeerrRequestsResponse> get copyWith => _$SeerrRequestsResponseCopyWithImpl<SeerrRequestsResponse>(this as SeerrRequestsResponse, _$identity);

  /// Serializes this SeerrRequestsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrRequestsResponse&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageInfo,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SeerrRequestsResponse(pageInfo: $pageInfo, results: $results)';
}


}

/// @nodoc
abstract mixin class $SeerrRequestsResponseCopyWith<$Res>  {
  factory $SeerrRequestsResponseCopyWith(SeerrRequestsResponse value, $Res Function(SeerrRequestsResponse) _then) = _$SeerrRequestsResponseCopyWithImpl;
@useResult
$Res call({
 SeerrPageInfo pageInfo, List<SeerrRequest> results
});


$SeerrPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class _$SeerrRequestsResponseCopyWithImpl<$Res>
    implements $SeerrRequestsResponseCopyWith<$Res> {
  _$SeerrRequestsResponseCopyWithImpl(this._self, this._then);

  final SeerrRequestsResponse _self;
  final $Res Function(SeerrRequestsResponse) _then;

/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageInfo = null,Object? results = null,}) {
  return _then(SeerrRequestsResponse(
pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as SeerrPageInfo,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SeerrRequest>,
  ));
}
/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrPageInfoCopyWith<$Res> get pageInfo {
  
  return $SeerrPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeerrRequestsResponse].
extension SeerrRequestsResponsePatterns on SeerrRequestsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrRequestsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrRequestsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrRequestsResponse value)  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrRequestsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrRequestsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SeerrPageInfo pageInfo,  List<SeerrRequest> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrRequestsResponse() when $default != null:
return $default(_that.pageInfo,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SeerrPageInfo pageInfo,  List<SeerrRequest> results)  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestsResponse():
return $default(_that.pageInfo,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SeerrPageInfo pageInfo,  List<SeerrRequest> results)?  $default,) {final _that = this;
switch (_that) {
case _SeerrRequestsResponse() when $default != null:
return $default(_that.pageInfo,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrRequestsResponse implements SeerrRequestsResponse {
  const _SeerrRequestsResponse({required this.pageInfo,  List<SeerrRequest> results = const []}): _results = results;
  factory _SeerrRequestsResponse.fromJson(Map<String, dynamic> json) => _$SeerrRequestsResponseFromJson(json);

@override final  SeerrPageInfo pageInfo;
 final  List<SeerrRequest> _results;
@override@JsonKey() List<SeerrRequest> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrRequestsResponseCopyWith<_SeerrRequestsResponse> get copyWith => __$SeerrRequestsResponseCopyWithImpl<_SeerrRequestsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrRequestsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrRequestsResponse&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageInfo,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SeerrRequestsResponse(pageInfo: $pageInfo, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SeerrRequestsResponseCopyWith<$Res> implements $SeerrRequestsResponseCopyWith<$Res> {
  factory _$SeerrRequestsResponseCopyWith(_SeerrRequestsResponse value, $Res Function(_SeerrRequestsResponse) _then) = __$SeerrRequestsResponseCopyWithImpl;
@override @useResult
$Res call({
 SeerrPageInfo pageInfo, List<SeerrRequest> results
});


@override $SeerrPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class __$SeerrRequestsResponseCopyWithImpl<$Res>
    implements _$SeerrRequestsResponseCopyWith<$Res> {
  __$SeerrRequestsResponseCopyWithImpl(this._self, this._then);

  final _SeerrRequestsResponse _self;
  final $Res Function(_SeerrRequestsResponse) _then;

/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageInfo = null,Object? results = null,}) {
  return _then(_SeerrRequestsResponse(
pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as SeerrPageInfo,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SeerrRequest>,
  ));
}

/// Create a copy of SeerrRequestsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeerrPageInfoCopyWith<$Res> get pageInfo {
  
  return $SeerrPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
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
  const _SeerrDiscoveryResponse({this.page = 1, this.totalPages = 1, this.totalResults = 0,  List<SeerrResult> results = const []}): _results = results;
  factory _SeerrDiscoveryResponse.fromJson(Map<String, dynamic> json) => _$SeerrDiscoveryResponseFromJson(json);

@override@JsonKey() final  int page;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int totalResults;
 final  List<SeerrResult> _results;
@override@JsonKey() List<SeerrResult> get results {
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


/// @nodoc
mixin _$SeerrGenre {

 int get id; String get name;
/// Create a copy of SeerrGenre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeerrGenreCopyWith<SeerrGenre> get copyWith => _$SeerrGenreCopyWithImpl<SeerrGenre>(this as SeerrGenre, _$identity);

  /// Serializes this SeerrGenre to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeerrGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SeerrGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SeerrGenreCopyWith<$Res>  {
  factory $SeerrGenreCopyWith(SeerrGenre value, $Res Function(SeerrGenre) _then) = _$SeerrGenreCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$SeerrGenreCopyWithImpl<$Res>
    implements $SeerrGenreCopyWith<$Res> {
  _$SeerrGenreCopyWithImpl(this._self, this._then);

  final SeerrGenre _self;
  final $Res Function(SeerrGenre) _then;

/// Create a copy of SeerrGenre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(SeerrGenre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SeerrGenre].
extension SeerrGenrePatterns on SeerrGenre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeerrGenre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeerrGenre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeerrGenre value)  $default,){
final _that = this;
switch (_that) {
case _SeerrGenre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeerrGenre value)?  $default,){
final _that = this;
switch (_that) {
case _SeerrGenre() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeerrGenre() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SeerrGenre():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SeerrGenre() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeerrGenre implements SeerrGenre {
  const _SeerrGenre({required this.id, required this.name});
  factory _SeerrGenre.fromJson(Map<String, dynamic> json) => _$SeerrGenreFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of SeerrGenre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeerrGenreCopyWith<_SeerrGenre> get copyWith => __$SeerrGenreCopyWithImpl<_SeerrGenre>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeerrGenreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeerrGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SeerrGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SeerrGenreCopyWith<$Res> implements $SeerrGenreCopyWith<$Res> {
  factory _$SeerrGenreCopyWith(_SeerrGenre value, $Res Function(_SeerrGenre) _then) = __$SeerrGenreCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$SeerrGenreCopyWithImpl<$Res>
    implements _$SeerrGenreCopyWith<$Res> {
  __$SeerrGenreCopyWithImpl(this._self, this._then);

  final _SeerrGenre _self;
  final $Res Function(_SeerrGenre) _then;

/// Create a copy of SeerrGenre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SeerrGenre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
