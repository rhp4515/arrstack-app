// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sonarr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SonarrSeries {

/// Unique ID in the Sonarr database (null for lookup results).
 int? get id; String get title; String get sortTitle; String get status; String get overview; List<SonarrImage> get images; List<SonarrSeason> get seasons; int get year; String? get path; int? get qualityProfileId; bool get monitored; bool get useSceneNumbering; String? get runtime; int get tvdbId; int? get tvMazeId; String get seriesType; String? get cleanTitle; String? get titleSlug; DateTime? get added; List<String> get genres; List<String> get tags; SonarrStatistics? get statistics;
/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrSeriesCopyWith<SonarrSeries> get copyWith => _$SonarrSeriesCopyWithImpl<SonarrSeries>(this as SonarrSeries, _$identity);

  /// Serializes this SonarrSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.seasons, seasons)&&(identical(other.year, year) || other.year == year)&&(identical(other.path, path) || other.path == path)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.useSceneNumbering, useSceneNumbering) || other.useSceneNumbering == useSceneNumbering)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvMazeId, tvMazeId) || other.tvMazeId == tvMazeId)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.cleanTitle, cleanTitle) || other.cleanTitle == cleanTitle)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,sortTitle,status,overview,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(seasons),year,path,qualityProfileId,monitored,useSceneNumbering,runtime,tvdbId,tvMazeId,seriesType,cleanTitle,titleSlug,added,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),statistics]);

@override
String toString() {
  return 'SonarrSeries(id: $id, title: $title, sortTitle: $sortTitle, status: $status, overview: $overview, images: $images, seasons: $seasons, year: $year, path: $path, qualityProfileId: $qualityProfileId, monitored: $monitored, useSceneNumbering: $useSceneNumbering, runtime: $runtime, tvdbId: $tvdbId, tvMazeId: $tvMazeId, seriesType: $seriesType, cleanTitle: $cleanTitle, titleSlug: $titleSlug, added: $added, genres: $genres, tags: $tags, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class $SonarrSeriesCopyWith<$Res>  {
  factory $SonarrSeriesCopyWith(SonarrSeries value, $Res Function(SonarrSeries) _then) = _$SonarrSeriesCopyWithImpl;
@useResult
$Res call({
 int? id, String title, String sortTitle, String status, String overview, List<SonarrImage> images, List<SonarrSeason> seasons, int year, String? path, int? qualityProfileId, bool monitored, bool useSceneNumbering, String? runtime, int tvdbId, int? tvMazeId, String seriesType, String? cleanTitle, String? titleSlug, DateTime? added, List<String> genres, List<String> tags, SonarrStatistics? statistics
});


$SonarrStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class _$SonarrSeriesCopyWithImpl<$Res>
    implements $SonarrSeriesCopyWith<$Res> {
  _$SonarrSeriesCopyWithImpl(this._self, this._then);

  final SonarrSeries _self;
  final $Res Function(SonarrSeries) _then;

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? sortTitle = null,Object? status = null,Object? overview = null,Object? images = null,Object? seasons = null,Object? year = null,Object? path = freezed,Object? qualityProfileId = freezed,Object? monitored = null,Object? useSceneNumbering = null,Object? runtime = freezed,Object? tvdbId = null,Object? tvMazeId = freezed,Object? seriesType = null,Object? cleanTitle = freezed,Object? titleSlug = freezed,Object? added = freezed,Object? genres = null,Object? tags = null,Object? statistics = freezed,}) {
  return _then(SonarrSeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortTitle: null == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SonarrSeason>,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,useSceneNumbering: null == useSceneNumbering ? _self.useSceneNumbering : useSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as String?,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int,tvMazeId: freezed == tvMazeId ? _self.tvMazeId : tvMazeId // ignore: cast_nullable_to_non_nullable
as int?,seriesType: null == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String,cleanTitle: freezed == cleanTitle ? _self.cleanTitle : cleanTitle // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,
  ));
}
/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $SonarrStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrSeries].
extension SonarrSeriesPatterns on SonarrSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrSeries value)  $default,){
final _that = this;
switch (_that) {
case _SonarrSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrSeries value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String title,  String sortTitle,  String status,  String overview,  List<SonarrImage> images,  List<SonarrSeason> seasons,  int year,  String? path,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  String? runtime,  int tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  DateTime? added,  List<String> genres,  List<String> tags,  SonarrStatistics? statistics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.added,_that.genres,_that.tags,_that.statistics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String title,  String sortTitle,  String status,  String overview,  List<SonarrImage> images,  List<SonarrSeason> seasons,  int year,  String? path,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  String? runtime,  int tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  DateTime? added,  List<String> genres,  List<String> tags,  SonarrStatistics? statistics)  $default,) {final _that = this;
switch (_that) {
case _SonarrSeries():
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.added,_that.genres,_that.tags,_that.statistics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String title,  String sortTitle,  String status,  String overview,  List<SonarrImage> images,  List<SonarrSeason> seasons,  int year,  String? path,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  String? runtime,  int tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  DateTime? added,  List<String> genres,  List<String> tags,  SonarrStatistics? statistics)?  $default,) {final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.added,_that.genres,_that.tags,_that.statistics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrSeries implements SonarrSeries {
  const _SonarrSeries({this.id, required this.title, required this.sortTitle, required this.status, required this.overview, required  List<SonarrImage> images, required  List<SonarrSeason> seasons, required this.year, this.path, this.qualityProfileId, required this.monitored, this.useSceneNumbering = false, this.runtime, required this.tvdbId, this.tvMazeId, required this.seriesType, this.cleanTitle, this.titleSlug, this.added,  List<String> genres = const [],  List<String> tags = const [], this.statistics}): _images = images,_seasons = seasons,_genres = genres,_tags = tags;
  factory _SonarrSeries.fromJson(Map<String, dynamic> json) => _$SonarrSeriesFromJson(json);

/// Unique ID in the Sonarr database (null for lookup results).
@override final  int? id;
@override final  String title;
@override final  String sortTitle;
@override final  String status;
@override final  String overview;
 final  List<SonarrImage> _images;
@override List<SonarrImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<SonarrSeason> _seasons;
@override List<SonarrSeason> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}

@override final  int year;
@override final  String? path;
@override final  int? qualityProfileId;
@override final  bool monitored;
@override@JsonKey() final  bool useSceneNumbering;
@override final  String? runtime;
@override final  int tvdbId;
@override final  int? tvMazeId;
@override final  String seriesType;
@override final  String? cleanTitle;
@override final  String? titleSlug;
@override final  DateTime? added;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  SonarrStatistics? statistics;

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrSeriesCopyWith<_SonarrSeries> get copyWith => __$SonarrSeriesCopyWithImpl<_SonarrSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._seasons, _seasons)&&(identical(other.year, year) || other.year == year)&&(identical(other.path, path) || other.path == path)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.useSceneNumbering, useSceneNumbering) || other.useSceneNumbering == useSceneNumbering)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvMazeId, tvMazeId) || other.tvMazeId == tvMazeId)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.cleanTitle, cleanTitle) || other.cleanTitle == cleanTitle)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,sortTitle,status,overview,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_seasons),year,path,qualityProfileId,monitored,useSceneNumbering,runtime,tvdbId,tvMazeId,seriesType,cleanTitle,titleSlug,added,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),statistics]);

@override
String toString() {
  return 'SonarrSeries(id: $id, title: $title, sortTitle: $sortTitle, status: $status, overview: $overview, images: $images, seasons: $seasons, year: $year, path: $path, qualityProfileId: $qualityProfileId, monitored: $monitored, useSceneNumbering: $useSceneNumbering, runtime: $runtime, tvdbId: $tvdbId, tvMazeId: $tvMazeId, seriesType: $seriesType, cleanTitle: $cleanTitle, titleSlug: $titleSlug, added: $added, genres: $genres, tags: $tags, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class _$SonarrSeriesCopyWith<$Res> implements $SonarrSeriesCopyWith<$Res> {
  factory _$SonarrSeriesCopyWith(_SonarrSeries value, $Res Function(_SonarrSeries) _then) = __$SonarrSeriesCopyWithImpl;
@override @useResult
$Res call({
 int? id, String title, String sortTitle, String status, String overview, List<SonarrImage> images, List<SonarrSeason> seasons, int year, String? path, int? qualityProfileId, bool monitored, bool useSceneNumbering, String? runtime, int tvdbId, int? tvMazeId, String seriesType, String? cleanTitle, String? titleSlug, DateTime? added, List<String> genres, List<String> tags, SonarrStatistics? statistics
});


@override $SonarrStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class __$SonarrSeriesCopyWithImpl<$Res>
    implements _$SonarrSeriesCopyWith<$Res> {
  __$SonarrSeriesCopyWithImpl(this._self, this._then);

  final _SonarrSeries _self;
  final $Res Function(_SonarrSeries) _then;

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? sortTitle = null,Object? status = null,Object? overview = null,Object? images = null,Object? seasons = null,Object? year = null,Object? path = freezed,Object? qualityProfileId = freezed,Object? monitored = null,Object? useSceneNumbering = null,Object? runtime = freezed,Object? tvdbId = null,Object? tvMazeId = freezed,Object? seriesType = null,Object? cleanTitle = freezed,Object? titleSlug = freezed,Object? added = freezed,Object? genres = null,Object? tags = null,Object? statistics = freezed,}) {
  return _then(_SonarrSeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortTitle: null == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SonarrSeason>,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,useSceneNumbering: null == useSceneNumbering ? _self.useSceneNumbering : useSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as String?,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int,tvMazeId: freezed == tvMazeId ? _self.tvMazeId : tvMazeId // ignore: cast_nullable_to_non_nullable
as int?,seriesType: null == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String,cleanTitle: freezed == cleanTitle ? _self.cleanTitle : cleanTitle // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,
  ));
}

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $SonarrStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// @nodoc
mixin _$SonarrImage {

 String get coverType; String get url; String? get remoteUrl;
/// Create a copy of SonarrImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrImageCopyWith<SonarrImage> get copyWith => _$SonarrImageCopyWithImpl<SonarrImage>(this as SonarrImage, _$identity);

  /// Serializes this SonarrImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrImage&&(identical(other.coverType, coverType) || other.coverType == coverType)&&(identical(other.url, url) || other.url == url)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverType,url,remoteUrl);

@override
String toString() {
  return 'SonarrImage(coverType: $coverType, url: $url, remoteUrl: $remoteUrl)';
}


}

/// @nodoc
abstract mixin class $SonarrImageCopyWith<$Res>  {
  factory $SonarrImageCopyWith(SonarrImage value, $Res Function(SonarrImage) _then) = _$SonarrImageCopyWithImpl;
@useResult
$Res call({
 String coverType, String url, String? remoteUrl
});




}
/// @nodoc
class _$SonarrImageCopyWithImpl<$Res>
    implements $SonarrImageCopyWith<$Res> {
  _$SonarrImageCopyWithImpl(this._self, this._then);

  final SonarrImage _self;
  final $Res Function(SonarrImage) _then;

/// Create a copy of SonarrImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverType = null,Object? url = null,Object? remoteUrl = freezed,}) {
  return _then(SonarrImage(
coverType: null == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrImage].
extension SonarrImagePatterns on SonarrImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrImage value)  $default,){
final _that = this;
switch (_that) {
case _SonarrImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrImage value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coverType,  String url,  String? remoteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrImage() when $default != null:
return $default(_that.coverType,_that.url,_that.remoteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coverType,  String url,  String? remoteUrl)  $default,) {final _that = this;
switch (_that) {
case _SonarrImage():
return $default(_that.coverType,_that.url,_that.remoteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coverType,  String url,  String? remoteUrl)?  $default,) {final _that = this;
switch (_that) {
case _SonarrImage() when $default != null:
return $default(_that.coverType,_that.url,_that.remoteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrImage implements SonarrImage {
  const _SonarrImage({required this.coverType, required this.url, this.remoteUrl});
  factory _SonarrImage.fromJson(Map<String, dynamic> json) => _$SonarrImageFromJson(json);

@override final  String coverType;
@override final  String url;
@override final  String? remoteUrl;

/// Create a copy of SonarrImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrImageCopyWith<_SonarrImage> get copyWith => __$SonarrImageCopyWithImpl<_SonarrImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrImage&&(identical(other.coverType, coverType) || other.coverType == coverType)&&(identical(other.url, url) || other.url == url)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverType,url,remoteUrl);

@override
String toString() {
  return 'SonarrImage(coverType: $coverType, url: $url, remoteUrl: $remoteUrl)';
}


}

/// @nodoc
abstract mixin class _$SonarrImageCopyWith<$Res> implements $SonarrImageCopyWith<$Res> {
  factory _$SonarrImageCopyWith(_SonarrImage value, $Res Function(_SonarrImage) _then) = __$SonarrImageCopyWithImpl;
@override @useResult
$Res call({
 String coverType, String url, String? remoteUrl
});




}
/// @nodoc
class __$SonarrImageCopyWithImpl<$Res>
    implements _$SonarrImageCopyWith<$Res> {
  __$SonarrImageCopyWithImpl(this._self, this._then);

  final _SonarrImage _self;
  final $Res Function(_SonarrImage) _then;

/// Create a copy of SonarrImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverType = null,Object? url = null,Object? remoteUrl = freezed,}) {
  return _then(_SonarrImage(
coverType: null == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SonarrSeason {

 int get seasonNumber; bool get monitored; SonarrStatistics? get statistics;
/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrSeasonCopyWith<SonarrSeason> get copyWith => _$SonarrSeasonCopyWithImpl<SonarrSeason>(this as SonarrSeason, _$identity);

  /// Serializes this SonarrSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrSeason&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonNumber,monitored,statistics);

@override
String toString() {
  return 'SonarrSeason(seasonNumber: $seasonNumber, monitored: $monitored, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class $SonarrSeasonCopyWith<$Res>  {
  factory $SonarrSeasonCopyWith(SonarrSeason value, $Res Function(SonarrSeason) _then) = _$SonarrSeasonCopyWithImpl;
@useResult
$Res call({
 int seasonNumber, bool monitored, SonarrStatistics? statistics
});


$SonarrStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class _$SonarrSeasonCopyWithImpl<$Res>
    implements $SonarrSeasonCopyWith<$Res> {
  _$SonarrSeasonCopyWithImpl(this._self, this._then);

  final SonarrSeason _self;
  final $Res Function(SonarrSeason) _then;

/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonNumber = null,Object? monitored = null,Object? statistics = freezed,}) {
  return _then(SonarrSeason(
seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,
  ));
}
/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $SonarrStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrSeason].
extension SonarrSeasonPatterns on SonarrSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrSeason value)  $default,){
final _that = this;
switch (_that) {
case _SonarrSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrSeason value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seasonNumber,  bool monitored,  SonarrStatistics? statistics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrSeason() when $default != null:
return $default(_that.seasonNumber,_that.monitored,_that.statistics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seasonNumber,  bool monitored,  SonarrStatistics? statistics)  $default,) {final _that = this;
switch (_that) {
case _SonarrSeason():
return $default(_that.seasonNumber,_that.monitored,_that.statistics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seasonNumber,  bool monitored,  SonarrStatistics? statistics)?  $default,) {final _that = this;
switch (_that) {
case _SonarrSeason() when $default != null:
return $default(_that.seasonNumber,_that.monitored,_that.statistics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrSeason implements SonarrSeason {
  const _SonarrSeason({required this.seasonNumber, required this.monitored, this.statistics});
  factory _SonarrSeason.fromJson(Map<String, dynamic> json) => _$SonarrSeasonFromJson(json);

@override final  int seasonNumber;
@override final  bool monitored;
@override final  SonarrStatistics? statistics;

/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrSeasonCopyWith<_SonarrSeason> get copyWith => __$SonarrSeasonCopyWithImpl<_SonarrSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrSeason&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonNumber,monitored,statistics);

@override
String toString() {
  return 'SonarrSeason(seasonNumber: $seasonNumber, monitored: $monitored, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class _$SonarrSeasonCopyWith<$Res> implements $SonarrSeasonCopyWith<$Res> {
  factory _$SonarrSeasonCopyWith(_SonarrSeason value, $Res Function(_SonarrSeason) _then) = __$SonarrSeasonCopyWithImpl;
@override @useResult
$Res call({
 int seasonNumber, bool monitored, SonarrStatistics? statistics
});


@override $SonarrStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class __$SonarrSeasonCopyWithImpl<$Res>
    implements _$SonarrSeasonCopyWith<$Res> {
  __$SonarrSeasonCopyWithImpl(this._self, this._then);

  final _SonarrSeason _self;
  final $Res Function(_SonarrSeason) _then;

/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonNumber = null,Object? monitored = null,Object? statistics = freezed,}) {
  return _then(_SonarrSeason(
seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,
  ));
}

/// Create a copy of SonarrSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $SonarrStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// @nodoc
mixin _$SonarrStatistics {

 int get seasonCount; int get episodeFileCount; int get episodeCount; int get totalEpisodeCount; int get sizeOnDisk; double get percentOfEpisodes;
/// Create a copy of SonarrStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrStatisticsCopyWith<SonarrStatistics> get copyWith => _$SonarrStatisticsCopyWithImpl<SonarrStatistics>(this as SonarrStatistics, _$identity);

  /// Serializes this SonarrStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrStatistics&&(identical(other.seasonCount, seasonCount) || other.seasonCount == seasonCount)&&(identical(other.episodeFileCount, episodeFileCount) || other.episodeFileCount == episodeFileCount)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.totalEpisodeCount, totalEpisodeCount) || other.totalEpisodeCount == totalEpisodeCount)&&(identical(other.sizeOnDisk, sizeOnDisk) || other.sizeOnDisk == sizeOnDisk)&&(identical(other.percentOfEpisodes, percentOfEpisodes) || other.percentOfEpisodes == percentOfEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonCount,episodeFileCount,episodeCount,totalEpisodeCount,sizeOnDisk,percentOfEpisodes);

@override
String toString() {
  return 'SonarrStatistics(seasonCount: $seasonCount, episodeFileCount: $episodeFileCount, episodeCount: $episodeCount, totalEpisodeCount: $totalEpisodeCount, sizeOnDisk: $sizeOnDisk, percentOfEpisodes: $percentOfEpisodes)';
}


}

/// @nodoc
abstract mixin class $SonarrStatisticsCopyWith<$Res>  {
  factory $SonarrStatisticsCopyWith(SonarrStatistics value, $Res Function(SonarrStatistics) _then) = _$SonarrStatisticsCopyWithImpl;
@useResult
$Res call({
 int seasonCount, int episodeFileCount, int episodeCount, int totalEpisodeCount, int sizeOnDisk, double percentOfEpisodes
});




}
/// @nodoc
class _$SonarrStatisticsCopyWithImpl<$Res>
    implements $SonarrStatisticsCopyWith<$Res> {
  _$SonarrStatisticsCopyWithImpl(this._self, this._then);

  final SonarrStatistics _self;
  final $Res Function(SonarrStatistics) _then;

/// Create a copy of SonarrStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonCount = null,Object? episodeFileCount = null,Object? episodeCount = null,Object? totalEpisodeCount = null,Object? sizeOnDisk = null,Object? percentOfEpisodes = null,}) {
  return _then(SonarrStatistics(
seasonCount: null == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int,episodeFileCount: null == episodeFileCount ? _self.episodeFileCount : episodeFileCount // ignore: cast_nullable_to_non_nullable
as int,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,totalEpisodeCount: null == totalEpisodeCount ? _self.totalEpisodeCount : totalEpisodeCount // ignore: cast_nullable_to_non_nullable
as int,sizeOnDisk: null == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int,percentOfEpisodes: null == percentOfEpisodes ? _self.percentOfEpisodes : percentOfEpisodes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrStatistics].
extension SonarrStatisticsPatterns on SonarrStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrStatistics value)  $default,){
final _that = this;
switch (_that) {
case _SonarrStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seasonCount,  int episodeFileCount,  int episodeCount,  int totalEpisodeCount,  int sizeOnDisk,  double percentOfEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrStatistics() when $default != null:
return $default(_that.seasonCount,_that.episodeFileCount,_that.episodeCount,_that.totalEpisodeCount,_that.sizeOnDisk,_that.percentOfEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seasonCount,  int episodeFileCount,  int episodeCount,  int totalEpisodeCount,  int sizeOnDisk,  double percentOfEpisodes)  $default,) {final _that = this;
switch (_that) {
case _SonarrStatistics():
return $default(_that.seasonCount,_that.episodeFileCount,_that.episodeCount,_that.totalEpisodeCount,_that.sizeOnDisk,_that.percentOfEpisodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seasonCount,  int episodeFileCount,  int episodeCount,  int totalEpisodeCount,  int sizeOnDisk,  double percentOfEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _SonarrStatistics() when $default != null:
return $default(_that.seasonCount,_that.episodeFileCount,_that.episodeCount,_that.totalEpisodeCount,_that.sizeOnDisk,_that.percentOfEpisodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrStatistics implements SonarrStatistics {
  const _SonarrStatistics({required this.seasonCount, required this.episodeFileCount, required this.episodeCount, required this.totalEpisodeCount, required this.sizeOnDisk, required this.percentOfEpisodes});
  factory _SonarrStatistics.fromJson(Map<String, dynamic> json) => _$SonarrStatisticsFromJson(json);

@override final  int seasonCount;
@override final  int episodeFileCount;
@override final  int episodeCount;
@override final  int totalEpisodeCount;
@override final  int sizeOnDisk;
@override final  double percentOfEpisodes;

/// Create a copy of SonarrStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrStatisticsCopyWith<_SonarrStatistics> get copyWith => __$SonarrStatisticsCopyWithImpl<_SonarrStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrStatistics&&(identical(other.seasonCount, seasonCount) || other.seasonCount == seasonCount)&&(identical(other.episodeFileCount, episodeFileCount) || other.episodeFileCount == episodeFileCount)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.totalEpisodeCount, totalEpisodeCount) || other.totalEpisodeCount == totalEpisodeCount)&&(identical(other.sizeOnDisk, sizeOnDisk) || other.sizeOnDisk == sizeOnDisk)&&(identical(other.percentOfEpisodes, percentOfEpisodes) || other.percentOfEpisodes == percentOfEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonCount,episodeFileCount,episodeCount,totalEpisodeCount,sizeOnDisk,percentOfEpisodes);

@override
String toString() {
  return 'SonarrStatistics(seasonCount: $seasonCount, episodeFileCount: $episodeFileCount, episodeCount: $episodeCount, totalEpisodeCount: $totalEpisodeCount, sizeOnDisk: $sizeOnDisk, percentOfEpisodes: $percentOfEpisodes)';
}


}

/// @nodoc
abstract mixin class _$SonarrStatisticsCopyWith<$Res> implements $SonarrStatisticsCopyWith<$Res> {
  factory _$SonarrStatisticsCopyWith(_SonarrStatistics value, $Res Function(_SonarrStatistics) _then) = __$SonarrStatisticsCopyWithImpl;
@override @useResult
$Res call({
 int seasonCount, int episodeFileCount, int episodeCount, int totalEpisodeCount, int sizeOnDisk, double percentOfEpisodes
});




}
/// @nodoc
class __$SonarrStatisticsCopyWithImpl<$Res>
    implements _$SonarrStatisticsCopyWith<$Res> {
  __$SonarrStatisticsCopyWithImpl(this._self, this._then);

  final _SonarrStatistics _self;
  final $Res Function(_SonarrStatistics) _then;

/// Create a copy of SonarrStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonCount = null,Object? episodeFileCount = null,Object? episodeCount = null,Object? totalEpisodeCount = null,Object? sizeOnDisk = null,Object? percentOfEpisodes = null,}) {
  return _then(_SonarrStatistics(
seasonCount: null == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int,episodeFileCount: null == episodeFileCount ? _self.episodeFileCount : episodeFileCount // ignore: cast_nullable_to_non_nullable
as int,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,totalEpisodeCount: null == totalEpisodeCount ? _self.totalEpisodeCount : totalEpisodeCount // ignore: cast_nullable_to_non_nullable
as int,sizeOnDisk: null == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int,percentOfEpisodes: null == percentOfEpisodes ? _self.percentOfEpisodes : percentOfEpisodes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SonarrEpisode {

 int get id; int get seriesId; int get seasonNumber; int get episodeNumber; String get title; String? get overview; bool get hasFile; bool get monitored; int? get absoluteEpisodeNumber; int? get sceneEpisodeNumber; int? get sceneSeasonNumber; bool get unverifiedSceneNumbering;
/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrEpisodeCopyWith<SonarrEpisode> get copyWith => _$SonarrEpisodeCopyWithImpl<SonarrEpisode>(this as SonarrEpisode, _$identity);

  /// Serializes this SonarrEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.absoluteEpisodeNumber, absoluteEpisodeNumber) || other.absoluteEpisodeNumber == absoluteEpisodeNumber)&&(identical(other.sceneEpisodeNumber, sceneEpisodeNumber) || other.sceneEpisodeNumber == sceneEpisodeNumber)&&(identical(other.sceneSeasonNumber, sceneSeasonNumber) || other.sceneSeasonNumber == sceneSeasonNumber)&&(identical(other.unverifiedSceneNumbering, unverifiedSceneNumbering) || other.unverifiedSceneNumbering == unverifiedSceneNumbering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,overview,hasFile,monitored,absoluteEpisodeNumber,sceneEpisodeNumber,sceneSeasonNumber,unverifiedSceneNumbering);

@override
String toString() {
  return 'SonarrEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, overview: $overview, hasFile: $hasFile, monitored: $monitored, absoluteEpisodeNumber: $absoluteEpisodeNumber, sceneEpisodeNumber: $sceneEpisodeNumber, sceneSeasonNumber: $sceneSeasonNumber, unverifiedSceneNumbering: $unverifiedSceneNumbering)';
}


}

/// @nodoc
abstract mixin class $SonarrEpisodeCopyWith<$Res>  {
  factory $SonarrEpisodeCopyWith(SonarrEpisode value, $Res Function(SonarrEpisode) _then) = _$SonarrEpisodeCopyWithImpl;
@useResult
$Res call({
 int id, int seriesId, int seasonNumber, int episodeNumber, String title, String? overview, bool hasFile, bool monitored, int? absoluteEpisodeNumber, int? sceneEpisodeNumber, int? sceneSeasonNumber, bool unverifiedSceneNumbering
});




}
/// @nodoc
class _$SonarrEpisodeCopyWithImpl<$Res>
    implements $SonarrEpisodeCopyWith<$Res> {
  _$SonarrEpisodeCopyWithImpl(this._self, this._then);

  final SonarrEpisode _self;
  final $Res Function(SonarrEpisode) _then;

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? title = null,Object? overview = freezed,Object? hasFile = null,Object? monitored = null,Object? absoluteEpisodeNumber = freezed,Object? sceneEpisodeNumber = freezed,Object? sceneSeasonNumber = freezed,Object? unverifiedSceneNumbering = null,}) {
  return _then(SonarrEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,absoluteEpisodeNumber: freezed == absoluteEpisodeNumber ? _self.absoluteEpisodeNumber : absoluteEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneEpisodeNumber: freezed == sceneEpisodeNumber ? _self.sceneEpisodeNumber : sceneEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneSeasonNumber: freezed == sceneSeasonNumber ? _self.sceneSeasonNumber : sceneSeasonNumber // ignore: cast_nullable_to_non_nullable
as int?,unverifiedSceneNumbering: null == unverifiedSceneNumbering ? _self.unverifiedSceneNumbering : unverifiedSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrEpisode].
extension SonarrEpisodePatterns on SonarrEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrEpisode value)  $default,){
final _that = this;
switch (_that) {
case _SonarrEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seriesId,  int seasonNumber,  int episodeNumber,  String title,  String? overview,  bool hasFile,  bool monitored,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seriesId,  int seasonNumber,  int episodeNumber,  String title,  String? overview,  bool hasFile,  bool monitored,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisode():
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seriesId,  int seasonNumber,  int episodeNumber,  String title,  String? overview,  bool hasFile,  bool monitored,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)?  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrEpisode implements SonarrEpisode {
  const _SonarrEpisode({required this.id, required this.seriesId, required this.seasonNumber, required this.episodeNumber, required this.title, this.overview, required this.hasFile, required this.monitored, this.absoluteEpisodeNumber, this.sceneEpisodeNumber, this.sceneSeasonNumber, required this.unverifiedSceneNumbering});
  factory _SonarrEpisode.fromJson(Map<String, dynamic> json) => _$SonarrEpisodeFromJson(json);

@override final  int id;
@override final  int seriesId;
@override final  int seasonNumber;
@override final  int episodeNumber;
@override final  String title;
@override final  String? overview;
@override final  bool hasFile;
@override final  bool monitored;
@override final  int? absoluteEpisodeNumber;
@override final  int? sceneEpisodeNumber;
@override final  int? sceneSeasonNumber;
@override final  bool unverifiedSceneNumbering;

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrEpisodeCopyWith<_SonarrEpisode> get copyWith => __$SonarrEpisodeCopyWithImpl<_SonarrEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.absoluteEpisodeNumber, absoluteEpisodeNumber) || other.absoluteEpisodeNumber == absoluteEpisodeNumber)&&(identical(other.sceneEpisodeNumber, sceneEpisodeNumber) || other.sceneEpisodeNumber == sceneEpisodeNumber)&&(identical(other.sceneSeasonNumber, sceneSeasonNumber) || other.sceneSeasonNumber == sceneSeasonNumber)&&(identical(other.unverifiedSceneNumbering, unverifiedSceneNumbering) || other.unverifiedSceneNumbering == unverifiedSceneNumbering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,overview,hasFile,monitored,absoluteEpisodeNumber,sceneEpisodeNumber,sceneSeasonNumber,unverifiedSceneNumbering);

@override
String toString() {
  return 'SonarrEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, overview: $overview, hasFile: $hasFile, monitored: $monitored, absoluteEpisodeNumber: $absoluteEpisodeNumber, sceneEpisodeNumber: $sceneEpisodeNumber, sceneSeasonNumber: $sceneSeasonNumber, unverifiedSceneNumbering: $unverifiedSceneNumbering)';
}


}

/// @nodoc
abstract mixin class _$SonarrEpisodeCopyWith<$Res> implements $SonarrEpisodeCopyWith<$Res> {
  factory _$SonarrEpisodeCopyWith(_SonarrEpisode value, $Res Function(_SonarrEpisode) _then) = __$SonarrEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int id, int seriesId, int seasonNumber, int episodeNumber, String title, String? overview, bool hasFile, bool monitored, int? absoluteEpisodeNumber, int? sceneEpisodeNumber, int? sceneSeasonNumber, bool unverifiedSceneNumbering
});




}
/// @nodoc
class __$SonarrEpisodeCopyWithImpl<$Res>
    implements _$SonarrEpisodeCopyWith<$Res> {
  __$SonarrEpisodeCopyWithImpl(this._self, this._then);

  final _SonarrEpisode _self;
  final $Res Function(_SonarrEpisode) _then;

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? title = null,Object? overview = freezed,Object? hasFile = null,Object? monitored = null,Object? absoluteEpisodeNumber = freezed,Object? sceneEpisodeNumber = freezed,Object? sceneSeasonNumber = freezed,Object? unverifiedSceneNumbering = null,}) {
  return _then(_SonarrEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,absoluteEpisodeNumber: freezed == absoluteEpisodeNumber ? _self.absoluteEpisodeNumber : absoluteEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneEpisodeNumber: freezed == sceneEpisodeNumber ? _self.sceneEpisodeNumber : sceneEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneSeasonNumber: freezed == sceneSeasonNumber ? _self.sceneSeasonNumber : sceneSeasonNumber // ignore: cast_nullable_to_non_nullable
as int?,unverifiedSceneNumbering: null == unverifiedSceneNumbering ? _self.unverifiedSceneNumbering : unverifiedSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SonarrQualityProfile {

 int get id; String get name;
/// Create a copy of SonarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrQualityProfileCopyWith<SonarrQualityProfile> get copyWith => _$SonarrQualityProfileCopyWithImpl<SonarrQualityProfile>(this as SonarrQualityProfile, _$identity);

  /// Serializes this SonarrQualityProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrQualityProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SonarrQualityProfile(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SonarrQualityProfileCopyWith<$Res>  {
  factory $SonarrQualityProfileCopyWith(SonarrQualityProfile value, $Res Function(SonarrQualityProfile) _then) = _$SonarrQualityProfileCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$SonarrQualityProfileCopyWithImpl<$Res>
    implements $SonarrQualityProfileCopyWith<$Res> {
  _$SonarrQualityProfileCopyWithImpl(this._self, this._then);

  final SonarrQualityProfile _self;
  final $Res Function(SonarrQualityProfile) _then;

/// Create a copy of SonarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(SonarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrQualityProfile].
extension SonarrQualityProfilePatterns on SonarrQualityProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrQualityProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrQualityProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrQualityProfile value)  $default,){
final _that = this;
switch (_that) {
case _SonarrQualityProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrQualityProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrQualityProfile() when $default != null:
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
case _SonarrQualityProfile() when $default != null:
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
case _SonarrQualityProfile():
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
case _SonarrQualityProfile() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrQualityProfile implements SonarrQualityProfile {
  const _SonarrQualityProfile({required this.id, required this.name});
  factory _SonarrQualityProfile.fromJson(Map<String, dynamic> json) => _$SonarrQualityProfileFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of SonarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrQualityProfileCopyWith<_SonarrQualityProfile> get copyWith => __$SonarrQualityProfileCopyWithImpl<_SonarrQualityProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrQualityProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrQualityProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SonarrQualityProfile(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SonarrQualityProfileCopyWith<$Res> implements $SonarrQualityProfileCopyWith<$Res> {
  factory _$SonarrQualityProfileCopyWith(_SonarrQualityProfile value, $Res Function(_SonarrQualityProfile) _then) = __$SonarrQualityProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$SonarrQualityProfileCopyWithImpl<$Res>
    implements _$SonarrQualityProfileCopyWith<$Res> {
  __$SonarrQualityProfileCopyWithImpl(this._self, this._then);

  final _SonarrQualityProfile _self;
  final $Res Function(_SonarrQualityProfile) _then;

/// Create a copy of SonarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SonarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SonarrRootFolder {

 int get id; String get path; int get freeSpace;
/// Create a copy of SonarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrRootFolderCopyWith<SonarrRootFolder> get copyWith => _$SonarrRootFolderCopyWithImpl<SonarrRootFolder>(this as SonarrRootFolder, _$identity);

  /// Serializes this SonarrRootFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrRootFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.freeSpace, freeSpace) || other.freeSpace == freeSpace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,freeSpace);

@override
String toString() {
  return 'SonarrRootFolder(id: $id, path: $path, freeSpace: $freeSpace)';
}


}

/// @nodoc
abstract mixin class $SonarrRootFolderCopyWith<$Res>  {
  factory $SonarrRootFolderCopyWith(SonarrRootFolder value, $Res Function(SonarrRootFolder) _then) = _$SonarrRootFolderCopyWithImpl;
@useResult
$Res call({
 int id, String path, int freeSpace
});




}
/// @nodoc
class _$SonarrRootFolderCopyWithImpl<$Res>
    implements $SonarrRootFolderCopyWith<$Res> {
  _$SonarrRootFolderCopyWithImpl(this._self, this._then);

  final SonarrRootFolder _self;
  final $Res Function(SonarrRootFolder) _then;

/// Create a copy of SonarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? freeSpace = null,}) {
  return _then(SonarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,freeSpace: null == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrRootFolder].
extension SonarrRootFolderPatterns on SonarrRootFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrRootFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrRootFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrRootFolder value)  $default,){
final _that = this;
switch (_that) {
case _SonarrRootFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrRootFolder value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrRootFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String path,  int freeSpace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrRootFolder() when $default != null:
return $default(_that.id,_that.path,_that.freeSpace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String path,  int freeSpace)  $default,) {final _that = this;
switch (_that) {
case _SonarrRootFolder():
return $default(_that.id,_that.path,_that.freeSpace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String path,  int freeSpace)?  $default,) {final _that = this;
switch (_that) {
case _SonarrRootFolder() when $default != null:
return $default(_that.id,_that.path,_that.freeSpace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrRootFolder implements SonarrRootFolder {
  const _SonarrRootFolder({required this.id, required this.path, required this.freeSpace});
  factory _SonarrRootFolder.fromJson(Map<String, dynamic> json) => _$SonarrRootFolderFromJson(json);

@override final  int id;
@override final  String path;
@override final  int freeSpace;

/// Create a copy of SonarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrRootFolderCopyWith<_SonarrRootFolder> get copyWith => __$SonarrRootFolderCopyWithImpl<_SonarrRootFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrRootFolderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrRootFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.freeSpace, freeSpace) || other.freeSpace == freeSpace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,freeSpace);

@override
String toString() {
  return 'SonarrRootFolder(id: $id, path: $path, freeSpace: $freeSpace)';
}


}

/// @nodoc
abstract mixin class _$SonarrRootFolderCopyWith<$Res> implements $SonarrRootFolderCopyWith<$Res> {
  factory _$SonarrRootFolderCopyWith(_SonarrRootFolder value, $Res Function(_SonarrRootFolder) _then) = __$SonarrRootFolderCopyWithImpl;
@override @useResult
$Res call({
 int id, String path, int freeSpace
});




}
/// @nodoc
class __$SonarrRootFolderCopyWithImpl<$Res>
    implements _$SonarrRootFolderCopyWith<$Res> {
  __$SonarrRootFolderCopyWithImpl(this._self, this._then);

  final _SonarrRootFolder _self;
  final $Res Function(_SonarrRootFolder) _then;

/// Create a copy of SonarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? freeSpace = null,}) {
  return _then(_SonarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,freeSpace: null == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
