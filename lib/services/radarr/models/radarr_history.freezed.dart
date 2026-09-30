// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radarr_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RadarrHistoryRecord {

 int get id; int? get movieId;/// Raw Radarr event type, e.g. `grabbed`, `downloadFolderImported`,
/// `downloadFailed`, `movieFileDeleted`, `movieFileRenamed`,
/// `downloadIgnored`.
 String get eventType;/// When the event happened (UTC as sent by Radarr).
 DateTime get date;/// The release name the event concerns.
 String? get sourceTitle; String? get downloadId;@JsonKey(fromJson: _qualityFromJson) RadarrQualityInfo? get quality;/// The movie, present when requested with `includeMovie=true`.
@JsonKey(fromJson: _movieFromJson) RadarrHistoryMovie? get movie;
/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrHistoryRecordCopyWith<RadarrHistoryRecord> get copyWith => _$RadarrHistoryRecordCopyWithImpl<RadarrHistoryRecord>(this as RadarrHistoryRecord, _$identity);

  /// Serializes this RadarrHistoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrHistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.movieId, movieId) || other.movieId == movieId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.date, date) || other.date == date)&&(identical(other.sourceTitle, sourceTitle) || other.sourceTitle == sourceTitle)&&(identical(other.downloadId, downloadId) || other.downloadId == downloadId)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.movie, movie) || other.movie == movie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movieId,eventType,date,sourceTitle,downloadId,quality,movie);

@override
String toString() {
  return 'RadarrHistoryRecord(id: $id, movieId: $movieId, eventType: $eventType, date: $date, sourceTitle: $sourceTitle, downloadId: $downloadId, quality: $quality, movie: $movie)';
}


}

/// @nodoc
abstract mixin class $RadarrHistoryRecordCopyWith<$Res>  {
  factory $RadarrHistoryRecordCopyWith(RadarrHistoryRecord value, $Res Function(RadarrHistoryRecord) _then) = _$RadarrHistoryRecordCopyWithImpl;
@useResult
$Res call({
 int id, int? movieId, String eventType, DateTime date, String? sourceTitle, String? downloadId,@JsonKey(fromJson: _qualityFromJson) RadarrQualityInfo? quality,@JsonKey(fromJson: _movieFromJson) RadarrHistoryMovie? movie
});


$RadarrQualityInfoCopyWith<$Res>? get quality;$RadarrHistoryMovieCopyWith<$Res>? get movie;

}
/// @nodoc
class _$RadarrHistoryRecordCopyWithImpl<$Res>
    implements $RadarrHistoryRecordCopyWith<$Res> {
  _$RadarrHistoryRecordCopyWithImpl(this._self, this._then);

  final RadarrHistoryRecord _self;
  final $Res Function(RadarrHistoryRecord) _then;

/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? movieId = freezed,Object? eventType = null,Object? date = null,Object? sourceTitle = freezed,Object? downloadId = freezed,Object? quality = freezed,Object? movie = freezed,}) {
  return _then(RadarrHistoryRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,movieId: freezed == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
as int?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sourceTitle: freezed == sourceTitle ? _self.sourceTitle : sourceTitle // ignore: cast_nullable_to_non_nullable
as String?,downloadId: freezed == downloadId ? _self.downloadId : downloadId // ignore: cast_nullable_to_non_nullable
as String?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQualityInfo?,movie: freezed == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as RadarrHistoryMovie?,
  ));
}
/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrQualityInfoCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $RadarrQualityInfoCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrHistoryMovieCopyWith<$Res>? get movie {
    if (_self.movie == null) {
    return null;
  }

  return $RadarrHistoryMovieCopyWith<$Res>(_self.movie!, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}


/// Adds pattern-matching-related methods to [RadarrHistoryRecord].
extension RadarrHistoryRecordPatterns on RadarrHistoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrHistoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrHistoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrHistoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _RadarrHistoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrHistoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrHistoryRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? movieId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  RadarrQualityInfo? quality, @JsonKey(fromJson: _movieFromJson)  RadarrHistoryMovie? movie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrHistoryRecord() when $default != null:
return $default(_that.id,_that.movieId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.movie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? movieId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  RadarrQualityInfo? quality, @JsonKey(fromJson: _movieFromJson)  RadarrHistoryMovie? movie)  $default,) {final _that = this;
switch (_that) {
case _RadarrHistoryRecord():
return $default(_that.id,_that.movieId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.movie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? movieId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  RadarrQualityInfo? quality, @JsonKey(fromJson: _movieFromJson)  RadarrHistoryMovie? movie)?  $default,) {final _that = this;
switch (_that) {
case _RadarrHistoryRecord() when $default != null:
return $default(_that.id,_that.movieId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.movie);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrHistoryRecord implements RadarrHistoryRecord {
  const _RadarrHistoryRecord({this.id = 0, this.movieId, this.eventType = 'unknown', required this.date, this.sourceTitle, this.downloadId, @JsonKey(fromJson: _qualityFromJson) this.quality, @JsonKey(fromJson: _movieFromJson) this.movie});
  factory _RadarrHistoryRecord.fromJson(Map<String, dynamic> json) => _$RadarrHistoryRecordFromJson(json);

@override@JsonKey() final  int id;
@override final  int? movieId;
/// Raw Radarr event type, e.g. `grabbed`, `downloadFolderImported`,
/// `downloadFailed`, `movieFileDeleted`, `movieFileRenamed`,
/// `downloadIgnored`.
@override@JsonKey() final  String eventType;
/// When the event happened (UTC as sent by Radarr).
@override final  DateTime date;
/// The release name the event concerns.
@override final  String? sourceTitle;
@override final  String? downloadId;
@override@JsonKey(fromJson: _qualityFromJson) final  RadarrQualityInfo? quality;
/// The movie, present when requested with `includeMovie=true`.
@override@JsonKey(fromJson: _movieFromJson) final  RadarrHistoryMovie? movie;

/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrHistoryRecordCopyWith<_RadarrHistoryRecord> get copyWith => __$RadarrHistoryRecordCopyWithImpl<_RadarrHistoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrHistoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrHistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.movieId, movieId) || other.movieId == movieId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.date, date) || other.date == date)&&(identical(other.sourceTitle, sourceTitle) || other.sourceTitle == sourceTitle)&&(identical(other.downloadId, downloadId) || other.downloadId == downloadId)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.movie, movie) || other.movie == movie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movieId,eventType,date,sourceTitle,downloadId,quality,movie);

@override
String toString() {
  return 'RadarrHistoryRecord(id: $id, movieId: $movieId, eventType: $eventType, date: $date, sourceTitle: $sourceTitle, downloadId: $downloadId, quality: $quality, movie: $movie)';
}


}

/// @nodoc
abstract mixin class _$RadarrHistoryRecordCopyWith<$Res> implements $RadarrHistoryRecordCopyWith<$Res> {
  factory _$RadarrHistoryRecordCopyWith(_RadarrHistoryRecord value, $Res Function(_RadarrHistoryRecord) _then) = __$RadarrHistoryRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, int? movieId, String eventType, DateTime date, String? sourceTitle, String? downloadId,@JsonKey(fromJson: _qualityFromJson) RadarrQualityInfo? quality,@JsonKey(fromJson: _movieFromJson) RadarrHistoryMovie? movie
});


@override $RadarrQualityInfoCopyWith<$Res>? get quality;@override $RadarrHistoryMovieCopyWith<$Res>? get movie;

}
/// @nodoc
class __$RadarrHistoryRecordCopyWithImpl<$Res>
    implements _$RadarrHistoryRecordCopyWith<$Res> {
  __$RadarrHistoryRecordCopyWithImpl(this._self, this._then);

  final _RadarrHistoryRecord _self;
  final $Res Function(_RadarrHistoryRecord) _then;

/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? movieId = freezed,Object? eventType = null,Object? date = null,Object? sourceTitle = freezed,Object? downloadId = freezed,Object? quality = freezed,Object? movie = freezed,}) {
  return _then(_RadarrHistoryRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,movieId: freezed == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
as int?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sourceTitle: freezed == sourceTitle ? _self.sourceTitle : sourceTitle // ignore: cast_nullable_to_non_nullable
as String?,downloadId: freezed == downloadId ? _self.downloadId : downloadId // ignore: cast_nullable_to_non_nullable
as String?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQualityInfo?,movie: freezed == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as RadarrHistoryMovie?,
  ));
}

/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrQualityInfoCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $RadarrQualityInfoCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}/// Create a copy of RadarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrHistoryMovieCopyWith<$Res>? get movie {
    if (_self.movie == null) {
    return null;
  }

  return $RadarrHistoryMovieCopyWith<$Res>(_self.movie!, (value) {
    return _then(_self.copyWith(movie: value));
  });
}
}


/// @nodoc
mixin _$RadarrHistoryMovie {

 int? get id; String? get title; int? get year;@JsonKey(fromJson: _imagesFromJson) List<RadarrImage>? get images;
/// Create a copy of RadarrHistoryMovie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrHistoryMovieCopyWith<RadarrHistoryMovie> get copyWith => _$RadarrHistoryMovieCopyWithImpl<RadarrHistoryMovie>(this as RadarrHistoryMovie, _$identity);

  /// Serializes this RadarrHistoryMovie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrHistoryMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'RadarrHistoryMovie(id: $id, title: $title, year: $year, images: $images)';
}


}

/// @nodoc
abstract mixin class $RadarrHistoryMovieCopyWith<$Res>  {
  factory $RadarrHistoryMovieCopyWith(RadarrHistoryMovie value, $Res Function(RadarrHistoryMovie) _then) = _$RadarrHistoryMovieCopyWithImpl;
@useResult
$Res call({
 int? id, String? title, int? year,@JsonKey(fromJson: _imagesFromJson) List<RadarrImage>? images
});




}
/// @nodoc
class _$RadarrHistoryMovieCopyWithImpl<$Res>
    implements $RadarrHistoryMovieCopyWith<$Res> {
  _$RadarrHistoryMovieCopyWithImpl(this._self, this._then);

  final RadarrHistoryMovie _self;
  final $Res Function(RadarrHistoryMovie) _then;

/// Create a copy of RadarrHistoryMovie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? year = freezed,Object? images = freezed,}) {
  return _then(RadarrHistoryMovie(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<RadarrImage>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrHistoryMovie].
extension RadarrHistoryMoviePatterns on RadarrHistoryMovie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrHistoryMovie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrHistoryMovie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrHistoryMovie value)  $default,){
final _that = this;
switch (_that) {
case _RadarrHistoryMovie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrHistoryMovie value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrHistoryMovie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<RadarrImage>? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrHistoryMovie() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<RadarrImage>? images)  $default,) {final _that = this;
switch (_that) {
case _RadarrHistoryMovie():
return $default(_that.id,_that.title,_that.year,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<RadarrImage>? images)?  $default,) {final _that = this;
switch (_that) {
case _RadarrHistoryMovie() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrHistoryMovie implements RadarrHistoryMovie {
  const _RadarrHistoryMovie({this.id, this.title, this.year, @JsonKey(fromJson: _imagesFromJson)  List<RadarrImage>? images}): _images = images;
  factory _RadarrHistoryMovie.fromJson(Map<String, dynamic> json) => _$RadarrHistoryMovieFromJson(json);

@override final  int? id;
@override final  String? title;
@override final  int? year;
 final  List<RadarrImage>? _images;
@override@JsonKey(fromJson: _imagesFromJson) List<RadarrImage>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RadarrHistoryMovie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrHistoryMovieCopyWith<_RadarrHistoryMovie> get copyWith => __$RadarrHistoryMovieCopyWithImpl<_RadarrHistoryMovie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrHistoryMovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrHistoryMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'RadarrHistoryMovie(id: $id, title: $title, year: $year, images: $images)';
}


}

/// @nodoc
abstract mixin class _$RadarrHistoryMovieCopyWith<$Res> implements $RadarrHistoryMovieCopyWith<$Res> {
  factory _$RadarrHistoryMovieCopyWith(_RadarrHistoryMovie value, $Res Function(_RadarrHistoryMovie) _then) = __$RadarrHistoryMovieCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? title, int? year,@JsonKey(fromJson: _imagesFromJson) List<RadarrImage>? images
});




}
/// @nodoc
class __$RadarrHistoryMovieCopyWithImpl<$Res>
    implements _$RadarrHistoryMovieCopyWith<$Res> {
  __$RadarrHistoryMovieCopyWithImpl(this._self, this._then);

  final _RadarrHistoryMovie _self;
  final $Res Function(_RadarrHistoryMovie) _then;

/// Create a copy of RadarrHistoryMovie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? year = freezed,Object? images = freezed,}) {
  return _then(_RadarrHistoryMovie(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<RadarrImage>?,
  ));
}


}

// dart format on
