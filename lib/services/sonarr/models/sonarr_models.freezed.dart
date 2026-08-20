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
 int? get id; String get title; String? get sortTitle; String? get status; String? get overview; List<SonarrImage>? get images; List<SonarrSeason>? get seasons; int? get year; String? get path; String? get rootFolderPath; int? get qualityProfileId; bool get monitored; bool get useSceneNumbering; int? get runtime; int? get tvdbId; int? get tvMazeId; String get seriesType; String? get cleanTitle; String? get titleSlug; String? get imdbId; String? get network; String? get certification; DateTime? get firstAired; SonarrRatings? get ratings; DateTime? get added; List<String>? get genres; List<int>? get tags; SonarrStatistics? get statistics; SonarrAddOptions? get addOptions;
/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrSeriesCopyWith<SonarrSeries> get copyWith => _$SonarrSeriesCopyWithImpl<SonarrSeries>(this as SonarrSeries, _$identity);

  /// Serializes this SonarrSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.seasons, seasons)&&(identical(other.year, year) || other.year == year)&&(identical(other.path, path) || other.path == path)&&(identical(other.rootFolderPath, rootFolderPath) || other.rootFolderPath == rootFolderPath)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.useSceneNumbering, useSceneNumbering) || other.useSceneNumbering == useSceneNumbering)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvMazeId, tvMazeId) || other.tvMazeId == tvMazeId)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.cleanTitle, cleanTitle) || other.cleanTitle == cleanTitle)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.network, network) || other.network == network)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.firstAired, firstAired) || other.firstAired == firstAired)&&(identical(other.ratings, ratings) || other.ratings == ratings)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&(identical(other.addOptions, addOptions) || other.addOptions == addOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,sortTitle,status,overview,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(seasons),year,path,rootFolderPath,qualityProfileId,monitored,useSceneNumbering,runtime,tvdbId,tvMazeId,seriesType,cleanTitle,titleSlug,imdbId,network,certification,firstAired,ratings,added,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),statistics,addOptions]);

@override
String toString() {
  return 'SonarrSeries(id: $id, title: $title, sortTitle: $sortTitle, status: $status, overview: $overview, images: $images, seasons: $seasons, year: $year, path: $path, rootFolderPath: $rootFolderPath, qualityProfileId: $qualityProfileId, monitored: $monitored, useSceneNumbering: $useSceneNumbering, runtime: $runtime, tvdbId: $tvdbId, tvMazeId: $tvMazeId, seriesType: $seriesType, cleanTitle: $cleanTitle, titleSlug: $titleSlug, imdbId: $imdbId, network: $network, certification: $certification, firstAired: $firstAired, ratings: $ratings, added: $added, genres: $genres, tags: $tags, statistics: $statistics, addOptions: $addOptions)';
}


}

/// @nodoc
abstract mixin class $SonarrSeriesCopyWith<$Res>  {
  factory $SonarrSeriesCopyWith(SonarrSeries value, $Res Function(SonarrSeries) _then) = _$SonarrSeriesCopyWithImpl;
@useResult
$Res call({
 int? id, String title, String? sortTitle, String? status, String? overview, List<SonarrImage>? images, List<SonarrSeason>? seasons, int? year, String? path, String? rootFolderPath, int? qualityProfileId, bool monitored, bool useSceneNumbering, int? runtime, int? tvdbId, int? tvMazeId, String seriesType, String? cleanTitle, String? titleSlug, String? imdbId, String? network, String? certification, DateTime? firstAired, SonarrRatings? ratings, DateTime? added, List<String>? genres, List<int>? tags, SonarrStatistics? statistics, SonarrAddOptions? addOptions
});


$SonarrRatingsCopyWith<$Res>? get ratings;$SonarrStatisticsCopyWith<$Res>? get statistics;$SonarrAddOptionsCopyWith<$Res>? get addOptions;

}
/// @nodoc
class _$SonarrSeriesCopyWithImpl<$Res>
    implements $SonarrSeriesCopyWith<$Res> {
  _$SonarrSeriesCopyWithImpl(this._self, this._then);

  final SonarrSeries _self;
  final $Res Function(SonarrSeries) _then;

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? sortTitle = freezed,Object? status = freezed,Object? overview = freezed,Object? images = freezed,Object? seasons = freezed,Object? year = freezed,Object? path = freezed,Object? rootFolderPath = freezed,Object? qualityProfileId = freezed,Object? monitored = null,Object? useSceneNumbering = null,Object? runtime = freezed,Object? tvdbId = freezed,Object? tvMazeId = freezed,Object? seriesType = null,Object? cleanTitle = freezed,Object? titleSlug = freezed,Object? imdbId = freezed,Object? network = freezed,Object? certification = freezed,Object? firstAired = freezed,Object? ratings = freezed,Object? added = freezed,Object? genres = freezed,Object? tags = freezed,Object? statistics = freezed,Object? addOptions = freezed,}) {
  return _then(SonarrSeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortTitle: freezed == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>?,seasons: freezed == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SonarrSeason>?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,rootFolderPath: freezed == rootFolderPath ? _self.rootFolderPath : rootFolderPath // ignore: cast_nullable_to_non_nullable
as String?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,useSceneNumbering: null == useSceneNumbering ? _self.useSceneNumbering : useSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int?,tvMazeId: freezed == tvMazeId ? _self.tvMazeId : tvMazeId // ignore: cast_nullable_to_non_nullable
as int?,seriesType: null == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String,cleanTitle: freezed == cleanTitle ? _self.cleanTitle : cleanTitle // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,firstAired: freezed == firstAired ? _self.firstAired : firstAired // ignore: cast_nullable_to_non_nullable
as DateTime?,ratings: freezed == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as SonarrRatings?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<int>?,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,addOptions: freezed == addOptions ? _self.addOptions : addOptions // ignore: cast_nullable_to_non_nullable
as SonarrAddOptions?,
  ));
}
/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrRatingsCopyWith<$Res>? get ratings {
    if (_self.ratings == null) {
    return null;
  }

  return $SonarrRatingsCopyWith<$Res>(_self.ratings!, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}/// Create a copy of SonarrSeries
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
}/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrAddOptionsCopyWith<$Res>? get addOptions {
    if (_self.addOptions == null) {
    return null;
  }

  return $SonarrAddOptionsCopyWith<$Res>(_self.addOptions!, (value) {
    return _then(_self.copyWith(addOptions: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String title,  String? sortTitle,  String? status,  String? overview,  List<SonarrImage>? images,  List<SonarrSeason>? seasons,  int? year,  String? path,  String? rootFolderPath,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  int? runtime,  int? tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  String? imdbId,  String? network,  String? certification,  DateTime? firstAired,  SonarrRatings? ratings,  DateTime? added,  List<String>? genres,  List<int>? tags,  SonarrStatistics? statistics,  SonarrAddOptions? addOptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.rootFolderPath,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.imdbId,_that.network,_that.certification,_that.firstAired,_that.ratings,_that.added,_that.genres,_that.tags,_that.statistics,_that.addOptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String title,  String? sortTitle,  String? status,  String? overview,  List<SonarrImage>? images,  List<SonarrSeason>? seasons,  int? year,  String? path,  String? rootFolderPath,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  int? runtime,  int? tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  String? imdbId,  String? network,  String? certification,  DateTime? firstAired,  SonarrRatings? ratings,  DateTime? added,  List<String>? genres,  List<int>? tags,  SonarrStatistics? statistics,  SonarrAddOptions? addOptions)  $default,) {final _that = this;
switch (_that) {
case _SonarrSeries():
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.rootFolderPath,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.imdbId,_that.network,_that.certification,_that.firstAired,_that.ratings,_that.added,_that.genres,_that.tags,_that.statistics,_that.addOptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String title,  String? sortTitle,  String? status,  String? overview,  List<SonarrImage>? images,  List<SonarrSeason>? seasons,  int? year,  String? path,  String? rootFolderPath,  int? qualityProfileId,  bool monitored,  bool useSceneNumbering,  int? runtime,  int? tvdbId,  int? tvMazeId,  String seriesType,  String? cleanTitle,  String? titleSlug,  String? imdbId,  String? network,  String? certification,  DateTime? firstAired,  SonarrRatings? ratings,  DateTime? added,  List<String>? genres,  List<int>? tags,  SonarrStatistics? statistics,  SonarrAddOptions? addOptions)?  $default,) {final _that = this;
switch (_that) {
case _SonarrSeries() when $default != null:
return $default(_that.id,_that.title,_that.sortTitle,_that.status,_that.overview,_that.images,_that.seasons,_that.year,_that.path,_that.rootFolderPath,_that.qualityProfileId,_that.monitored,_that.useSceneNumbering,_that.runtime,_that.tvdbId,_that.tvMazeId,_that.seriesType,_that.cleanTitle,_that.titleSlug,_that.imdbId,_that.network,_that.certification,_that.firstAired,_that.ratings,_that.added,_that.genres,_that.tags,_that.statistics,_that.addOptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrSeries implements SonarrSeries {
  const _SonarrSeries({this.id, this.title = 'Unknown', this.sortTitle, this.status, this.overview,  List<SonarrImage>? images,  List<SonarrSeason>? seasons, this.year, this.path, this.rootFolderPath, this.qualityProfileId, this.monitored = true, this.useSceneNumbering = false, this.runtime, this.tvdbId, this.tvMazeId, this.seriesType = 'program', this.cleanTitle, this.titleSlug, this.imdbId, this.network, this.certification, this.firstAired, this.ratings, this.added,  List<String>? genres,  List<int>? tags, this.statistics, this.addOptions}): _images = images,_seasons = seasons,_genres = genres,_tags = tags;
  factory _SonarrSeries.fromJson(Map<String, dynamic> json) => _$SonarrSeriesFromJson(json);

/// Unique ID in the Sonarr database (null for lookup results).
@override final  int? id;
@override@JsonKey() final  String title;
@override final  String? sortTitle;
@override final  String? status;
@override final  String? overview;
 final  List<SonarrImage>? _images;
@override List<SonarrImage>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SonarrSeason>? _seasons;
@override List<SonarrSeason>? get seasons {
  final value = _seasons;
  if (value == null) return null;
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? year;
@override final  String? path;
@override final  String? rootFolderPath;
@override final  int? qualityProfileId;
@override@JsonKey() final  bool monitored;
@override@JsonKey() final  bool useSceneNumbering;
@override final  int? runtime;
@override final  int? tvdbId;
@override final  int? tvMazeId;
@override@JsonKey() final  String seriesType;
@override final  String? cleanTitle;
@override final  String? titleSlug;
@override final  String? imdbId;
@override final  String? network;
@override final  String? certification;
@override final  DateTime? firstAired;
@override final  SonarrRatings? ratings;
@override final  DateTime? added;
 final  List<String>? _genres;
@override List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _tags;
@override List<int>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  SonarrStatistics? statistics;
@override final  SonarrAddOptions? addOptions;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._seasons, _seasons)&&(identical(other.year, year) || other.year == year)&&(identical(other.path, path) || other.path == path)&&(identical(other.rootFolderPath, rootFolderPath) || other.rootFolderPath == rootFolderPath)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.useSceneNumbering, useSceneNumbering) || other.useSceneNumbering == useSceneNumbering)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvMazeId, tvMazeId) || other.tvMazeId == tvMazeId)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.cleanTitle, cleanTitle) || other.cleanTitle == cleanTitle)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.network, network) || other.network == network)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.firstAired, firstAired) || other.firstAired == firstAired)&&(identical(other.ratings, ratings) || other.ratings == ratings)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&(identical(other.addOptions, addOptions) || other.addOptions == addOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,sortTitle,status,overview,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_seasons),year,path,rootFolderPath,qualityProfileId,monitored,useSceneNumbering,runtime,tvdbId,tvMazeId,seriesType,cleanTitle,titleSlug,imdbId,network,certification,firstAired,ratings,added,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),statistics,addOptions]);

@override
String toString() {
  return 'SonarrSeries(id: $id, title: $title, sortTitle: $sortTitle, status: $status, overview: $overview, images: $images, seasons: $seasons, year: $year, path: $path, rootFolderPath: $rootFolderPath, qualityProfileId: $qualityProfileId, monitored: $monitored, useSceneNumbering: $useSceneNumbering, runtime: $runtime, tvdbId: $tvdbId, tvMazeId: $tvMazeId, seriesType: $seriesType, cleanTitle: $cleanTitle, titleSlug: $titleSlug, imdbId: $imdbId, network: $network, certification: $certification, firstAired: $firstAired, ratings: $ratings, added: $added, genres: $genres, tags: $tags, statistics: $statistics, addOptions: $addOptions)';
}


}

/// @nodoc
abstract mixin class _$SonarrSeriesCopyWith<$Res> implements $SonarrSeriesCopyWith<$Res> {
  factory _$SonarrSeriesCopyWith(_SonarrSeries value, $Res Function(_SonarrSeries) _then) = __$SonarrSeriesCopyWithImpl;
@override @useResult
$Res call({
 int? id, String title, String? sortTitle, String? status, String? overview, List<SonarrImage>? images, List<SonarrSeason>? seasons, int? year, String? path, String? rootFolderPath, int? qualityProfileId, bool monitored, bool useSceneNumbering, int? runtime, int? tvdbId, int? tvMazeId, String seriesType, String? cleanTitle, String? titleSlug, String? imdbId, String? network, String? certification, DateTime? firstAired, SonarrRatings? ratings, DateTime? added, List<String>? genres, List<int>? tags, SonarrStatistics? statistics, SonarrAddOptions? addOptions
});


@override $SonarrRatingsCopyWith<$Res>? get ratings;@override $SonarrStatisticsCopyWith<$Res>? get statistics;@override $SonarrAddOptionsCopyWith<$Res>? get addOptions;

}
/// @nodoc
class __$SonarrSeriesCopyWithImpl<$Res>
    implements _$SonarrSeriesCopyWith<$Res> {
  __$SonarrSeriesCopyWithImpl(this._self, this._then);

  final _SonarrSeries _self;
  final $Res Function(_SonarrSeries) _then;

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? sortTitle = freezed,Object? status = freezed,Object? overview = freezed,Object? images = freezed,Object? seasons = freezed,Object? year = freezed,Object? path = freezed,Object? rootFolderPath = freezed,Object? qualityProfileId = freezed,Object? monitored = null,Object? useSceneNumbering = null,Object? runtime = freezed,Object? tvdbId = freezed,Object? tvMazeId = freezed,Object? seriesType = null,Object? cleanTitle = freezed,Object? titleSlug = freezed,Object? imdbId = freezed,Object? network = freezed,Object? certification = freezed,Object? firstAired = freezed,Object? ratings = freezed,Object? added = freezed,Object? genres = freezed,Object? tags = freezed,Object? statistics = freezed,Object? addOptions = freezed,}) {
  return _then(_SonarrSeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortTitle: freezed == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>?,seasons: freezed == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SonarrSeason>?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,rootFolderPath: freezed == rootFolderPath ? _self.rootFolderPath : rootFolderPath // ignore: cast_nullable_to_non_nullable
as String?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,useSceneNumbering: null == useSceneNumbering ? _self.useSceneNumbering : useSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as int?,tvMazeId: freezed == tvMazeId ? _self.tvMazeId : tvMazeId // ignore: cast_nullable_to_non_nullable
as int?,seriesType: null == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String,cleanTitle: freezed == cleanTitle ? _self.cleanTitle : cleanTitle // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,firstAired: freezed == firstAired ? _self.firstAired : firstAired // ignore: cast_nullable_to_non_nullable
as DateTime?,ratings: freezed == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as SonarrRatings?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<int>?,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as SonarrStatistics?,addOptions: freezed == addOptions ? _self.addOptions : addOptions // ignore: cast_nullable_to_non_nullable
as SonarrAddOptions?,
  ));
}

/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrRatingsCopyWith<$Res>? get ratings {
    if (_self.ratings == null) {
    return null;
  }

  return $SonarrRatingsCopyWith<$Res>(_self.ratings!, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}/// Create a copy of SonarrSeries
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
}/// Create a copy of SonarrSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrAddOptionsCopyWith<$Res>? get addOptions {
    if (_self.addOptions == null) {
    return null;
  }

  return $SonarrAddOptionsCopyWith<$Res>(_self.addOptions!, (value) {
    return _then(_self.copyWith(addOptions: value));
  });
}
}


/// @nodoc
mixin _$SonarrAddOptions {

 String get monitor; bool get searchForMissingEpisodes;
/// Create a copy of SonarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrAddOptionsCopyWith<SonarrAddOptions> get copyWith => _$SonarrAddOptionsCopyWithImpl<SonarrAddOptions>(this as SonarrAddOptions, _$identity);

  /// Serializes this SonarrAddOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrAddOptions&&(identical(other.monitor, monitor) || other.monitor == monitor)&&(identical(other.searchForMissingEpisodes, searchForMissingEpisodes) || other.searchForMissingEpisodes == searchForMissingEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monitor,searchForMissingEpisodes);

@override
String toString() {
  return 'SonarrAddOptions(monitor: $monitor, searchForMissingEpisodes: $searchForMissingEpisodes)';
}


}

/// @nodoc
abstract mixin class $SonarrAddOptionsCopyWith<$Res>  {
  factory $SonarrAddOptionsCopyWith(SonarrAddOptions value, $Res Function(SonarrAddOptions) _then) = _$SonarrAddOptionsCopyWithImpl;
@useResult
$Res call({
 String monitor, bool searchForMissingEpisodes
});




}
/// @nodoc
class _$SonarrAddOptionsCopyWithImpl<$Res>
    implements $SonarrAddOptionsCopyWith<$Res> {
  _$SonarrAddOptionsCopyWithImpl(this._self, this._then);

  final SonarrAddOptions _self;
  final $Res Function(SonarrAddOptions) _then;

/// Create a copy of SonarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monitor = null,Object? searchForMissingEpisodes = null,}) {
  return _then(SonarrAddOptions(
monitor: null == monitor ? _self.monitor : monitor // ignore: cast_nullable_to_non_nullable
as String,searchForMissingEpisodes: null == searchForMissingEpisodes ? _self.searchForMissingEpisodes : searchForMissingEpisodes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrAddOptions].
extension SonarrAddOptionsPatterns on SonarrAddOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrAddOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrAddOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrAddOptions value)  $default,){
final _that = this;
switch (_that) {
case _SonarrAddOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrAddOptions value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrAddOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monitor,  bool searchForMissingEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrAddOptions() when $default != null:
return $default(_that.monitor,_that.searchForMissingEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monitor,  bool searchForMissingEpisodes)  $default,) {final _that = this;
switch (_that) {
case _SonarrAddOptions():
return $default(_that.monitor,_that.searchForMissingEpisodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monitor,  bool searchForMissingEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _SonarrAddOptions() when $default != null:
return $default(_that.monitor,_that.searchForMissingEpisodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrAddOptions implements SonarrAddOptions {
  const _SonarrAddOptions({this.monitor = 'all', this.searchForMissingEpisodes = false});
  factory _SonarrAddOptions.fromJson(Map<String, dynamic> json) => _$SonarrAddOptionsFromJson(json);

@override@JsonKey() final  String monitor;
@override@JsonKey() final  bool searchForMissingEpisodes;

/// Create a copy of SonarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrAddOptionsCopyWith<_SonarrAddOptions> get copyWith => __$SonarrAddOptionsCopyWithImpl<_SonarrAddOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrAddOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrAddOptions&&(identical(other.monitor, monitor) || other.monitor == monitor)&&(identical(other.searchForMissingEpisodes, searchForMissingEpisodes) || other.searchForMissingEpisodes == searchForMissingEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monitor,searchForMissingEpisodes);

@override
String toString() {
  return 'SonarrAddOptions(monitor: $monitor, searchForMissingEpisodes: $searchForMissingEpisodes)';
}


}

/// @nodoc
abstract mixin class _$SonarrAddOptionsCopyWith<$Res> implements $SonarrAddOptionsCopyWith<$Res> {
  factory _$SonarrAddOptionsCopyWith(_SonarrAddOptions value, $Res Function(_SonarrAddOptions) _then) = __$SonarrAddOptionsCopyWithImpl;
@override @useResult
$Res call({
 String monitor, bool searchForMissingEpisodes
});




}
/// @nodoc
class __$SonarrAddOptionsCopyWithImpl<$Res>
    implements _$SonarrAddOptionsCopyWith<$Res> {
  __$SonarrAddOptionsCopyWithImpl(this._self, this._then);

  final _SonarrAddOptions _self;
  final $Res Function(_SonarrAddOptions) _then;

/// Create a copy of SonarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monitor = null,Object? searchForMissingEpisodes = null,}) {
  return _then(_SonarrAddOptions(
monitor: null == monitor ? _self.monitor : monitor // ignore: cast_nullable_to_non_nullable
as String,searchForMissingEpisodes: null == searchForMissingEpisodes ? _self.searchForMissingEpisodes : searchForMissingEpisodes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SonarrImage {

 String? get coverType; String? get url; String? get remoteUrl;
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
 String? coverType, String? url, String? remoteUrl
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
@pragma('vm:prefer-inline') @override $Res call({Object? coverType = freezed,Object? url = freezed,Object? remoteUrl = freezed,}) {
  return _then(SonarrImage(
coverType: freezed == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? coverType,  String? url,  String? remoteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? coverType,  String? url,  String? remoteUrl)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? coverType,  String? url,  String? remoteUrl)?  $default,) {final _that = this;
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
  const _SonarrImage({this.coverType, this.url, this.remoteUrl});
  factory _SonarrImage.fromJson(Map<String, dynamic> json) => _$SonarrImageFromJson(json);

@override final  String? coverType;
@override final  String? url;
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
 String? coverType, String? url, String? remoteUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? coverType = freezed,Object? url = freezed,Object? remoteUrl = freezed,}) {
  return _then(_SonarrImage(
coverType: freezed == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SonarrSeason {

 int? get seasonNumber; bool get monitored; SonarrStatistics? get statistics;
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
 int? seasonNumber, bool monitored, SonarrStatistics? statistics
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
@pragma('vm:prefer-inline') @override $Res call({Object? seasonNumber = freezed,Object? monitored = null,Object? statistics = freezed,}) {
  return _then(SonarrSeason(
seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? seasonNumber,  bool monitored,  SonarrStatistics? statistics)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? seasonNumber,  bool monitored,  SonarrStatistics? statistics)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? seasonNumber,  bool monitored,  SonarrStatistics? statistics)?  $default,) {final _that = this;
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
  const _SonarrSeason({this.seasonNumber, this.monitored = true, this.statistics});
  factory _SonarrSeason.fromJson(Map<String, dynamic> json) => _$SonarrSeasonFromJson(json);

@override final  int? seasonNumber;
@override@JsonKey() final  bool monitored;
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
 int? seasonNumber, bool monitored, SonarrStatistics? statistics
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
@override @pragma('vm:prefer-inline') $Res call({Object? seasonNumber = freezed,Object? monitored = null,Object? statistics = freezed,}) {
  return _then(_SonarrSeason(
seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
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

 int? get seasonCount; int? get episodeFileCount; int? get episodeCount; int? get totalEpisodeCount; int? get sizeOnDisk; double? get percentOfEpisodes;
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
 int? seasonCount, int? episodeFileCount, int? episodeCount, int? totalEpisodeCount, int? sizeOnDisk, double? percentOfEpisodes
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
@pragma('vm:prefer-inline') @override $Res call({Object? seasonCount = freezed,Object? episodeFileCount = freezed,Object? episodeCount = freezed,Object? totalEpisodeCount = freezed,Object? sizeOnDisk = freezed,Object? percentOfEpisodes = freezed,}) {
  return _then(SonarrStatistics(
seasonCount: freezed == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int?,episodeFileCount: freezed == episodeFileCount ? _self.episodeFileCount : episodeFileCount // ignore: cast_nullable_to_non_nullable
as int?,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,totalEpisodeCount: freezed == totalEpisodeCount ? _self.totalEpisodeCount : totalEpisodeCount // ignore: cast_nullable_to_non_nullable
as int?,sizeOnDisk: freezed == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int?,percentOfEpisodes: freezed == percentOfEpisodes ? _self.percentOfEpisodes : percentOfEpisodes // ignore: cast_nullable_to_non_nullable
as double?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? seasonCount,  int? episodeFileCount,  int? episodeCount,  int? totalEpisodeCount,  int? sizeOnDisk,  double? percentOfEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? seasonCount,  int? episodeFileCount,  int? episodeCount,  int? totalEpisodeCount,  int? sizeOnDisk,  double? percentOfEpisodes)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? seasonCount,  int? episodeFileCount,  int? episodeCount,  int? totalEpisodeCount,  int? sizeOnDisk,  double? percentOfEpisodes)?  $default,) {final _that = this;
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
  const _SonarrStatistics({this.seasonCount, this.episodeFileCount, this.episodeCount, this.totalEpisodeCount, this.sizeOnDisk, this.percentOfEpisodes});
  factory _SonarrStatistics.fromJson(Map<String, dynamic> json) => _$SonarrStatisticsFromJson(json);

@override final  int? seasonCount;
@override final  int? episodeFileCount;
@override final  int? episodeCount;
@override final  int? totalEpisodeCount;
@override final  int? sizeOnDisk;
@override final  double? percentOfEpisodes;

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
 int? seasonCount, int? episodeFileCount, int? episodeCount, int? totalEpisodeCount, int? sizeOnDisk, double? percentOfEpisodes
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
@override @pragma('vm:prefer-inline') $Res call({Object? seasonCount = freezed,Object? episodeFileCount = freezed,Object? episodeCount = freezed,Object? totalEpisodeCount = freezed,Object? sizeOnDisk = freezed,Object? percentOfEpisodes = freezed,}) {
  return _then(_SonarrStatistics(
seasonCount: freezed == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int?,episodeFileCount: freezed == episodeFileCount ? _self.episodeFileCount : episodeFileCount // ignore: cast_nullable_to_non_nullable
as int?,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,totalEpisodeCount: freezed == totalEpisodeCount ? _self.totalEpisodeCount : totalEpisodeCount // ignore: cast_nullable_to_non_nullable
as int?,sizeOnDisk: freezed == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int?,percentOfEpisodes: freezed == percentOfEpisodes ? _self.percentOfEpisodes : percentOfEpisodes // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SonarrEpisode {

 int get id; int? get seriesId; int? get seasonNumber; int? get episodeNumber; String? get title; String? get overview; bool get hasFile; bool get monitored; DateTime? get airDateUtc; int? get runtime; int? get episodeFileId; SonarrEpisodeFile? get episodeFile; int? get absoluteEpisodeNumber; int? get sceneEpisodeNumber; int? get sceneSeasonNumber; bool get unverifiedSceneNumbering;
/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrEpisodeCopyWith<SonarrEpisode> get copyWith => _$SonarrEpisodeCopyWithImpl<SonarrEpisode>(this as SonarrEpisode, _$identity);

  /// Serializes this SonarrEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.airDateUtc, airDateUtc) || other.airDateUtc == airDateUtc)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.episodeFileId, episodeFileId) || other.episodeFileId == episodeFileId)&&(identical(other.episodeFile, episodeFile) || other.episodeFile == episodeFile)&&(identical(other.absoluteEpisodeNumber, absoluteEpisodeNumber) || other.absoluteEpisodeNumber == absoluteEpisodeNumber)&&(identical(other.sceneEpisodeNumber, sceneEpisodeNumber) || other.sceneEpisodeNumber == sceneEpisodeNumber)&&(identical(other.sceneSeasonNumber, sceneSeasonNumber) || other.sceneSeasonNumber == sceneSeasonNumber)&&(identical(other.unverifiedSceneNumbering, unverifiedSceneNumbering) || other.unverifiedSceneNumbering == unverifiedSceneNumbering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,overview,hasFile,monitored,airDateUtc,runtime,episodeFileId,episodeFile,absoluteEpisodeNumber,sceneEpisodeNumber,sceneSeasonNumber,unverifiedSceneNumbering);

@override
String toString() {
  return 'SonarrEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, overview: $overview, hasFile: $hasFile, monitored: $monitored, airDateUtc: $airDateUtc, runtime: $runtime, episodeFileId: $episodeFileId, episodeFile: $episodeFile, absoluteEpisodeNumber: $absoluteEpisodeNumber, sceneEpisodeNumber: $sceneEpisodeNumber, sceneSeasonNumber: $sceneSeasonNumber, unverifiedSceneNumbering: $unverifiedSceneNumbering)';
}


}

/// @nodoc
abstract mixin class $SonarrEpisodeCopyWith<$Res>  {
  factory $SonarrEpisodeCopyWith(SonarrEpisode value, $Res Function(SonarrEpisode) _then) = _$SonarrEpisodeCopyWithImpl;
@useResult
$Res call({
 int id, int? seriesId, int? seasonNumber, int? episodeNumber, String? title, String? overview, bool hasFile, bool monitored, DateTime? airDateUtc, int? runtime, int? episodeFileId, SonarrEpisodeFile? episodeFile, int? absoluteEpisodeNumber, int? sceneEpisodeNumber, int? sceneSeasonNumber, bool unverifiedSceneNumbering
});


$SonarrEpisodeFileCopyWith<$Res>? get episodeFile;

}
/// @nodoc
class _$SonarrEpisodeCopyWithImpl<$Res>
    implements $SonarrEpisodeCopyWith<$Res> {
  _$SonarrEpisodeCopyWithImpl(this._self, this._then);

  final SonarrEpisode _self;
  final $Res Function(SonarrEpisode) _then;

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,Object? overview = freezed,Object? hasFile = null,Object? monitored = null,Object? airDateUtc = freezed,Object? runtime = freezed,Object? episodeFileId = freezed,Object? episodeFile = freezed,Object? absoluteEpisodeNumber = freezed,Object? sceneEpisodeNumber = freezed,Object? sceneSeasonNumber = freezed,Object? unverifiedSceneNumbering = null,}) {
  return _then(SonarrEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,airDateUtc: freezed == airDateUtc ? _self.airDateUtc : airDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,episodeFileId: freezed == episodeFileId ? _self.episodeFileId : episodeFileId // ignore: cast_nullable_to_non_nullable
as int?,episodeFile: freezed == episodeFile ? _self.episodeFile : episodeFile // ignore: cast_nullable_to_non_nullable
as SonarrEpisodeFile?,absoluteEpisodeNumber: freezed == absoluteEpisodeNumber ? _self.absoluteEpisodeNumber : absoluteEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneEpisodeNumber: freezed == sceneEpisodeNumber ? _self.sceneEpisodeNumber : sceneEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneSeasonNumber: freezed == sceneSeasonNumber ? _self.sceneSeasonNumber : sceneSeasonNumber // ignore: cast_nullable_to_non_nullable
as int?,unverifiedSceneNumbering: null == unverifiedSceneNumbering ? _self.unverifiedSceneNumbering : unverifiedSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrEpisodeFileCopyWith<$Res>? get episodeFile {
    if (_self.episodeFile == null) {
    return null;
  }

  return $SonarrEpisodeFileCopyWith<$Res>(_self.episodeFile!, (value) {
    return _then(_self.copyWith(episodeFile: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  String? overview,  bool hasFile,  bool monitored,  DateTime? airDateUtc,  int? runtime,  int? episodeFileId,  SonarrEpisodeFile? episodeFile,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.airDateUtc,_that.runtime,_that.episodeFileId,_that.episodeFile,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  String? overview,  bool hasFile,  bool monitored,  DateTime? airDateUtc,  int? runtime,  int? episodeFileId,  SonarrEpisodeFile? episodeFile,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisode():
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.airDateUtc,_that.runtime,_that.episodeFileId,_that.episodeFile,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  String? overview,  bool hasFile,  bool monitored,  DateTime? airDateUtc,  int? runtime,  int? episodeFileId,  SonarrEpisodeFile? episodeFile,  int? absoluteEpisodeNumber,  int? sceneEpisodeNumber,  int? sceneSeasonNumber,  bool unverifiedSceneNumbering)?  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.overview,_that.hasFile,_that.monitored,_that.airDateUtc,_that.runtime,_that.episodeFileId,_that.episodeFile,_that.absoluteEpisodeNumber,_that.sceneEpisodeNumber,_that.sceneSeasonNumber,_that.unverifiedSceneNumbering);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrEpisode implements SonarrEpisode {
  const _SonarrEpisode({required this.id, this.seriesId, this.seasonNumber, this.episodeNumber, this.title, this.overview, this.hasFile = false, this.monitored = true, this.airDateUtc, this.runtime, this.episodeFileId, this.episodeFile, this.absoluteEpisodeNumber, this.sceneEpisodeNumber, this.sceneSeasonNumber, this.unverifiedSceneNumbering = false});
  factory _SonarrEpisode.fromJson(Map<String, dynamic> json) => _$SonarrEpisodeFromJson(json);

@override final  int id;
@override final  int? seriesId;
@override final  int? seasonNumber;
@override final  int? episodeNumber;
@override final  String? title;
@override final  String? overview;
@override@JsonKey() final  bool hasFile;
@override@JsonKey() final  bool monitored;
@override final  DateTime? airDateUtc;
@override final  int? runtime;
@override final  int? episodeFileId;
@override final  SonarrEpisodeFile? episodeFile;
@override final  int? absoluteEpisodeNumber;
@override final  int? sceneEpisodeNumber;
@override final  int? sceneSeasonNumber;
@override@JsonKey() final  bool unverifiedSceneNumbering;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.airDateUtc, airDateUtc) || other.airDateUtc == airDateUtc)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.episodeFileId, episodeFileId) || other.episodeFileId == episodeFileId)&&(identical(other.episodeFile, episodeFile) || other.episodeFile == episodeFile)&&(identical(other.absoluteEpisodeNumber, absoluteEpisodeNumber) || other.absoluteEpisodeNumber == absoluteEpisodeNumber)&&(identical(other.sceneEpisodeNumber, sceneEpisodeNumber) || other.sceneEpisodeNumber == sceneEpisodeNumber)&&(identical(other.sceneSeasonNumber, sceneSeasonNumber) || other.sceneSeasonNumber == sceneSeasonNumber)&&(identical(other.unverifiedSceneNumbering, unverifiedSceneNumbering) || other.unverifiedSceneNumbering == unverifiedSceneNumbering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,overview,hasFile,monitored,airDateUtc,runtime,episodeFileId,episodeFile,absoluteEpisodeNumber,sceneEpisodeNumber,sceneSeasonNumber,unverifiedSceneNumbering);

@override
String toString() {
  return 'SonarrEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, overview: $overview, hasFile: $hasFile, monitored: $monitored, airDateUtc: $airDateUtc, runtime: $runtime, episodeFileId: $episodeFileId, episodeFile: $episodeFile, absoluteEpisodeNumber: $absoluteEpisodeNumber, sceneEpisodeNumber: $sceneEpisodeNumber, sceneSeasonNumber: $sceneSeasonNumber, unverifiedSceneNumbering: $unverifiedSceneNumbering)';
}


}

/// @nodoc
abstract mixin class _$SonarrEpisodeCopyWith<$Res> implements $SonarrEpisodeCopyWith<$Res> {
  factory _$SonarrEpisodeCopyWith(_SonarrEpisode value, $Res Function(_SonarrEpisode) _then) = __$SonarrEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int id, int? seriesId, int? seasonNumber, int? episodeNumber, String? title, String? overview, bool hasFile, bool monitored, DateTime? airDateUtc, int? runtime, int? episodeFileId, SonarrEpisodeFile? episodeFile, int? absoluteEpisodeNumber, int? sceneEpisodeNumber, int? sceneSeasonNumber, bool unverifiedSceneNumbering
});


@override $SonarrEpisodeFileCopyWith<$Res>? get episodeFile;

}
/// @nodoc
class __$SonarrEpisodeCopyWithImpl<$Res>
    implements _$SonarrEpisodeCopyWith<$Res> {
  __$SonarrEpisodeCopyWithImpl(this._self, this._then);

  final _SonarrEpisode _self;
  final $Res Function(_SonarrEpisode) _then;

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,Object? overview = freezed,Object? hasFile = null,Object? monitored = null,Object? airDateUtc = freezed,Object? runtime = freezed,Object? episodeFileId = freezed,Object? episodeFile = freezed,Object? absoluteEpisodeNumber = freezed,Object? sceneEpisodeNumber = freezed,Object? sceneSeasonNumber = freezed,Object? unverifiedSceneNumbering = null,}) {
  return _then(_SonarrEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,airDateUtc: freezed == airDateUtc ? _self.airDateUtc : airDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,episodeFileId: freezed == episodeFileId ? _self.episodeFileId : episodeFileId // ignore: cast_nullable_to_non_nullable
as int?,episodeFile: freezed == episodeFile ? _self.episodeFile : episodeFile // ignore: cast_nullable_to_non_nullable
as SonarrEpisodeFile?,absoluteEpisodeNumber: freezed == absoluteEpisodeNumber ? _self.absoluteEpisodeNumber : absoluteEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneEpisodeNumber: freezed == sceneEpisodeNumber ? _self.sceneEpisodeNumber : sceneEpisodeNumber // ignore: cast_nullable_to_non_nullable
as int?,sceneSeasonNumber: freezed == sceneSeasonNumber ? _self.sceneSeasonNumber : sceneSeasonNumber // ignore: cast_nullable_to_non_nullable
as int?,unverifiedSceneNumbering: null == unverifiedSceneNumbering ? _self.unverifiedSceneNumbering : unverifiedSceneNumbering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SonarrEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrEpisodeFileCopyWith<$Res>? get episodeFile {
    if (_self.episodeFile == null) {
    return null;
  }

  return $SonarrEpisodeFileCopyWith<$Res>(_self.episodeFile!, (value) {
    return _then(_self.copyWith(episodeFile: value));
  });
}
}


/// @nodoc
mixin _$SonarrEpisodeFile {

 int get id; String? get relativePath; int get size; DateTime? get dateAdded; SonarrQualityInfo? get quality;
/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrEpisodeFileCopyWith<SonarrEpisodeFile> get copyWith => _$SonarrEpisodeFileCopyWithImpl<SonarrEpisodeFile>(this as SonarrEpisodeFile, _$identity);

  /// Serializes this SonarrEpisodeFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrEpisodeFile&&(identical(other.id, id) || other.id == id)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.size, size) || other.size == size)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relativePath,size,dateAdded,quality);

@override
String toString() {
  return 'SonarrEpisodeFile(id: $id, relativePath: $relativePath, size: $size, dateAdded: $dateAdded, quality: $quality)';
}


}

/// @nodoc
abstract mixin class $SonarrEpisodeFileCopyWith<$Res>  {
  factory $SonarrEpisodeFileCopyWith(SonarrEpisodeFile value, $Res Function(SonarrEpisodeFile) _then) = _$SonarrEpisodeFileCopyWithImpl;
@useResult
$Res call({
 int id, String? relativePath, int size, DateTime? dateAdded, SonarrQualityInfo? quality
});


$SonarrQualityInfoCopyWith<$Res>? get quality;

}
/// @nodoc
class _$SonarrEpisodeFileCopyWithImpl<$Res>
    implements $SonarrEpisodeFileCopyWith<$Res> {
  _$SonarrEpisodeFileCopyWithImpl(this._self, this._then);

  final SonarrEpisodeFile _self;
  final $Res Function(SonarrEpisodeFile) _then;

/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? relativePath = freezed,Object? size = null,Object? dateAdded = freezed,Object? quality = freezed,}) {
  return _then(SonarrEpisodeFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,relativePath: freezed == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQualityInfo?,
  ));
}
/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrQualityInfoCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $SonarrQualityInfoCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrEpisodeFile].
extension SonarrEpisodeFilePatterns on SonarrEpisodeFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrEpisodeFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrEpisodeFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrEpisodeFile value)  $default,){
final _that = this;
switch (_that) {
case _SonarrEpisodeFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrEpisodeFile value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrEpisodeFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? relativePath,  int size,  DateTime? dateAdded,  SonarrQualityInfo? quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrEpisodeFile() when $default != null:
return $default(_that.id,_that.relativePath,_that.size,_that.dateAdded,_that.quality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? relativePath,  int size,  DateTime? dateAdded,  SonarrQualityInfo? quality)  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisodeFile():
return $default(_that.id,_that.relativePath,_that.size,_that.dateAdded,_that.quality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? relativePath,  int size,  DateTime? dateAdded,  SonarrQualityInfo? quality)?  $default,) {final _that = this;
switch (_that) {
case _SonarrEpisodeFile() when $default != null:
return $default(_that.id,_that.relativePath,_that.size,_that.dateAdded,_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrEpisodeFile implements SonarrEpisodeFile {
  const _SonarrEpisodeFile({required this.id, this.relativePath, this.size = 0, this.dateAdded, this.quality});
  factory _SonarrEpisodeFile.fromJson(Map<String, dynamic> json) => _$SonarrEpisodeFileFromJson(json);

@override final  int id;
@override final  String? relativePath;
@override@JsonKey() final  int size;
@override final  DateTime? dateAdded;
@override final  SonarrQualityInfo? quality;

/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrEpisodeFileCopyWith<_SonarrEpisodeFile> get copyWith => __$SonarrEpisodeFileCopyWithImpl<_SonarrEpisodeFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrEpisodeFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrEpisodeFile&&(identical(other.id, id) || other.id == id)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.size, size) || other.size == size)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relativePath,size,dateAdded,quality);

@override
String toString() {
  return 'SonarrEpisodeFile(id: $id, relativePath: $relativePath, size: $size, dateAdded: $dateAdded, quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$SonarrEpisodeFileCopyWith<$Res> implements $SonarrEpisodeFileCopyWith<$Res> {
  factory _$SonarrEpisodeFileCopyWith(_SonarrEpisodeFile value, $Res Function(_SonarrEpisodeFile) _then) = __$SonarrEpisodeFileCopyWithImpl;
@override @useResult
$Res call({
 int id, String? relativePath, int size, DateTime? dateAdded, SonarrQualityInfo? quality
});


@override $SonarrQualityInfoCopyWith<$Res>? get quality;

}
/// @nodoc
class __$SonarrEpisodeFileCopyWithImpl<$Res>
    implements _$SonarrEpisodeFileCopyWith<$Res> {
  __$SonarrEpisodeFileCopyWithImpl(this._self, this._then);

  final _SonarrEpisodeFile _self;
  final $Res Function(_SonarrEpisodeFile) _then;

/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? relativePath = freezed,Object? size = null,Object? dateAdded = freezed,Object? quality = freezed,}) {
  return _then(_SonarrEpisodeFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,relativePath: freezed == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQualityInfo?,
  ));
}

/// Create a copy of SonarrEpisodeFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrQualityInfoCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $SonarrQualityInfoCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// @nodoc
mixin _$SonarrQualityInfo {

 SonarrQuality? get quality;
/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrQualityInfoCopyWith<SonarrQualityInfo> get copyWith => _$SonarrQualityInfoCopyWithImpl<SonarrQualityInfo>(this as SonarrQualityInfo, _$identity);

  /// Serializes this SonarrQualityInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrQualityInfo&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality);

@override
String toString() {
  return 'SonarrQualityInfo(quality: $quality)';
}


}

/// @nodoc
abstract mixin class $SonarrQualityInfoCopyWith<$Res>  {
  factory $SonarrQualityInfoCopyWith(SonarrQualityInfo value, $Res Function(SonarrQualityInfo) _then) = _$SonarrQualityInfoCopyWithImpl;
@useResult
$Res call({
 SonarrQuality? quality
});


$SonarrQualityCopyWith<$Res>? get quality;

}
/// @nodoc
class _$SonarrQualityInfoCopyWithImpl<$Res>
    implements $SonarrQualityInfoCopyWith<$Res> {
  _$SonarrQualityInfoCopyWithImpl(this._self, this._then);

  final SonarrQualityInfo _self;
  final $Res Function(SonarrQualityInfo) _then;

/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quality = freezed,}) {
  return _then(SonarrQualityInfo(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQuality?,
  ));
}
/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrQualityCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $SonarrQualityCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrQualityInfo].
extension SonarrQualityInfoPatterns on SonarrQualityInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrQualityInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrQualityInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrQualityInfo value)  $default,){
final _that = this;
switch (_that) {
case _SonarrQualityInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrQualityInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrQualityInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SonarrQuality? quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrQualityInfo() when $default != null:
return $default(_that.quality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SonarrQuality? quality)  $default,) {final _that = this;
switch (_that) {
case _SonarrQualityInfo():
return $default(_that.quality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SonarrQuality? quality)?  $default,) {final _that = this;
switch (_that) {
case _SonarrQualityInfo() when $default != null:
return $default(_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrQualityInfo implements SonarrQualityInfo {
  const _SonarrQualityInfo({this.quality});
  factory _SonarrQualityInfo.fromJson(Map<String, dynamic> json) => _$SonarrQualityInfoFromJson(json);

@override final  SonarrQuality? quality;

/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrQualityInfoCopyWith<_SonarrQualityInfo> get copyWith => __$SonarrQualityInfoCopyWithImpl<_SonarrQualityInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrQualityInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrQualityInfo&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality);

@override
String toString() {
  return 'SonarrQualityInfo(quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$SonarrQualityInfoCopyWith<$Res> implements $SonarrQualityInfoCopyWith<$Res> {
  factory _$SonarrQualityInfoCopyWith(_SonarrQualityInfo value, $Res Function(_SonarrQualityInfo) _then) = __$SonarrQualityInfoCopyWithImpl;
@override @useResult
$Res call({
 SonarrQuality? quality
});


@override $SonarrQualityCopyWith<$Res>? get quality;

}
/// @nodoc
class __$SonarrQualityInfoCopyWithImpl<$Res>
    implements _$SonarrQualityInfoCopyWith<$Res> {
  __$SonarrQualityInfoCopyWithImpl(this._self, this._then);

  final _SonarrQualityInfo _self;
  final $Res Function(_SonarrQualityInfo) _then;

/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quality = freezed,}) {
  return _then(_SonarrQualityInfo(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQuality?,
  ));
}

/// Create a copy of SonarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrQualityCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $SonarrQualityCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// @nodoc
mixin _$SonarrQuality {

 int? get id; String? get name;
/// Create a copy of SonarrQuality
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrQualityCopyWith<SonarrQuality> get copyWith => _$SonarrQualityCopyWithImpl<SonarrQuality>(this as SonarrQuality, _$identity);

  /// Serializes this SonarrQuality to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrQuality&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SonarrQuality(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SonarrQualityCopyWith<$Res>  {
  factory $SonarrQualityCopyWith(SonarrQuality value, $Res Function(SonarrQuality) _then) = _$SonarrQualityCopyWithImpl;
@useResult
$Res call({
 int? id, String? name
});




}
/// @nodoc
class _$SonarrQualityCopyWithImpl<$Res>
    implements $SonarrQualityCopyWith<$Res> {
  _$SonarrQualityCopyWithImpl(this._self, this._then);

  final SonarrQuality _self;
  final $Res Function(SonarrQuality) _then;

/// Create a copy of SonarrQuality
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(SonarrQuality(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrQuality].
extension SonarrQualityPatterns on SonarrQuality {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrQuality value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrQuality() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrQuality value)  $default,){
final _that = this;
switch (_that) {
case _SonarrQuality():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrQuality value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrQuality() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrQuality() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name)  $default,) {final _that = this;
switch (_that) {
case _SonarrQuality():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _SonarrQuality() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrQuality implements SonarrQuality {
  const _SonarrQuality({this.id, this.name});
  factory _SonarrQuality.fromJson(Map<String, dynamic> json) => _$SonarrQualityFromJson(json);

@override final  int? id;
@override final  String? name;

/// Create a copy of SonarrQuality
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrQualityCopyWith<_SonarrQuality> get copyWith => __$SonarrQualityCopyWithImpl<_SonarrQuality>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrQualityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrQuality&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SonarrQuality(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SonarrQualityCopyWith<$Res> implements $SonarrQualityCopyWith<$Res> {
  factory _$SonarrQualityCopyWith(_SonarrQuality value, $Res Function(_SonarrQuality) _then) = __$SonarrQualityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name
});




}
/// @nodoc
class __$SonarrQualityCopyWithImpl<$Res>
    implements _$SonarrQualityCopyWith<$Res> {
  __$SonarrQualityCopyWithImpl(this._self, this._then);

  final _SonarrQuality _self;
  final $Res Function(_SonarrQuality) _then;

/// Create a copy of SonarrQuality
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_SonarrQuality(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SonarrRatings {

 int get votes; double get value;
/// Create a copy of SonarrRatings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrRatingsCopyWith<SonarrRatings> get copyWith => _$SonarrRatingsCopyWithImpl<SonarrRatings>(this as SonarrRatings, _$identity);

  /// Serializes this SonarrRatings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrRatings&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,votes,value);

@override
String toString() {
  return 'SonarrRatings(votes: $votes, value: $value)';
}


}

/// @nodoc
abstract mixin class $SonarrRatingsCopyWith<$Res>  {
  factory $SonarrRatingsCopyWith(SonarrRatings value, $Res Function(SonarrRatings) _then) = _$SonarrRatingsCopyWithImpl;
@useResult
$Res call({
 int votes, double value
});




}
/// @nodoc
class _$SonarrRatingsCopyWithImpl<$Res>
    implements $SonarrRatingsCopyWith<$Res> {
  _$SonarrRatingsCopyWithImpl(this._self, this._then);

  final SonarrRatings _self;
  final $Res Function(SonarrRatings) _then;

/// Create a copy of SonarrRatings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? votes = null,Object? value = null,}) {
  return _then(SonarrRatings(
votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrRatings].
extension SonarrRatingsPatterns on SonarrRatings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrRatings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrRatings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrRatings value)  $default,){
final _that = this;
switch (_that) {
case _SonarrRatings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrRatings value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrRatings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int votes,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrRatings() when $default != null:
return $default(_that.votes,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int votes,  double value)  $default,) {final _that = this;
switch (_that) {
case _SonarrRatings():
return $default(_that.votes,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int votes,  double value)?  $default,) {final _that = this;
switch (_that) {
case _SonarrRatings() when $default != null:
return $default(_that.votes,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrRatings implements SonarrRatings {
  const _SonarrRatings({this.votes = 0, this.value = 0});
  factory _SonarrRatings.fromJson(Map<String, dynamic> json) => _$SonarrRatingsFromJson(json);

@override@JsonKey() final  int votes;
@override@JsonKey() final  double value;

/// Create a copy of SonarrRatings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrRatingsCopyWith<_SonarrRatings> get copyWith => __$SonarrRatingsCopyWithImpl<_SonarrRatings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrRatingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrRatings&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,votes,value);

@override
String toString() {
  return 'SonarrRatings(votes: $votes, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SonarrRatingsCopyWith<$Res> implements $SonarrRatingsCopyWith<$Res> {
  factory _$SonarrRatingsCopyWith(_SonarrRatings value, $Res Function(_SonarrRatings) _then) = __$SonarrRatingsCopyWithImpl;
@override @useResult
$Res call({
 int votes, double value
});




}
/// @nodoc
class __$SonarrRatingsCopyWithImpl<$Res>
    implements _$SonarrRatingsCopyWith<$Res> {
  __$SonarrRatingsCopyWithImpl(this._self, this._then);

  final _SonarrRatings _self;
  final $Res Function(_SonarrRatings) _then;

/// Create a copy of SonarrRatings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? votes = null,Object? value = null,}) {
  return _then(_SonarrRatings(
votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SonarrCalendarEpisode {

 int get id; int? get seriesId; int? get seasonNumber; int? get episodeNumber; String? get title; DateTime? get airDateUtc; bool get hasFile; bool get monitored; SonarrSeries? get series;
/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrCalendarEpisodeCopyWith<SonarrCalendarEpisode> get copyWith => _$SonarrCalendarEpisodeCopyWithImpl<SonarrCalendarEpisode>(this as SonarrCalendarEpisode, _$identity);

  /// Serializes this SonarrCalendarEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrCalendarEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.airDateUtc, airDateUtc) || other.airDateUtc == airDateUtc)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.series, series) || other.series == series));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,airDateUtc,hasFile,monitored,series);

@override
String toString() {
  return 'SonarrCalendarEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, airDateUtc: $airDateUtc, hasFile: $hasFile, monitored: $monitored, series: $series)';
}


}

/// @nodoc
abstract mixin class $SonarrCalendarEpisodeCopyWith<$Res>  {
  factory $SonarrCalendarEpisodeCopyWith(SonarrCalendarEpisode value, $Res Function(SonarrCalendarEpisode) _then) = _$SonarrCalendarEpisodeCopyWithImpl;
@useResult
$Res call({
 int id, int? seriesId, int? seasonNumber, int? episodeNumber, String? title, DateTime? airDateUtc, bool hasFile, bool monitored, SonarrSeries? series
});


$SonarrSeriesCopyWith<$Res>? get series;

}
/// @nodoc
class _$SonarrCalendarEpisodeCopyWithImpl<$Res>
    implements $SonarrCalendarEpisodeCopyWith<$Res> {
  _$SonarrCalendarEpisodeCopyWithImpl(this._self, this._then);

  final SonarrCalendarEpisode _self;
  final $Res Function(SonarrCalendarEpisode) _then;

/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,Object? airDateUtc = freezed,Object? hasFile = null,Object? monitored = null,Object? series = freezed,}) {
  return _then(SonarrCalendarEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,airDateUtc: freezed == airDateUtc ? _self.airDateUtc : airDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as SonarrSeries?,
  ));
}
/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrSeriesCopyWith<$Res>? get series {
    if (_self.series == null) {
    return null;
  }

  return $SonarrSeriesCopyWith<$Res>(_self.series!, (value) {
    return _then(_self.copyWith(series: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrCalendarEpisode].
extension SonarrCalendarEpisodePatterns on SonarrCalendarEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrCalendarEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrCalendarEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrCalendarEpisode value)  $default,){
final _that = this;
switch (_that) {
case _SonarrCalendarEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrCalendarEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrCalendarEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  DateTime? airDateUtc,  bool hasFile,  bool monitored,  SonarrSeries? series)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrCalendarEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.airDateUtc,_that.hasFile,_that.monitored,_that.series);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  DateTime? airDateUtc,  bool hasFile,  bool monitored,  SonarrSeries? series)  $default,) {final _that = this;
switch (_that) {
case _SonarrCalendarEpisode():
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.airDateUtc,_that.hasFile,_that.monitored,_that.series);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? seriesId,  int? seasonNumber,  int? episodeNumber,  String? title,  DateTime? airDateUtc,  bool hasFile,  bool monitored,  SonarrSeries? series)?  $default,) {final _that = this;
switch (_that) {
case _SonarrCalendarEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.title,_that.airDateUtc,_that.hasFile,_that.monitored,_that.series);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrCalendarEpisode implements SonarrCalendarEpisode {
  const _SonarrCalendarEpisode({required this.id, this.seriesId, this.seasonNumber, this.episodeNumber, this.title, this.airDateUtc, this.hasFile = false, this.monitored = true, this.series});
  factory _SonarrCalendarEpisode.fromJson(Map<String, dynamic> json) => _$SonarrCalendarEpisodeFromJson(json);

@override final  int id;
@override final  int? seriesId;
@override final  int? seasonNumber;
@override final  int? episodeNumber;
@override final  String? title;
@override final  DateTime? airDateUtc;
@override@JsonKey() final  bool hasFile;
@override@JsonKey() final  bool monitored;
@override final  SonarrSeries? series;

/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrCalendarEpisodeCopyWith<_SonarrCalendarEpisode> get copyWith => __$SonarrCalendarEpisodeCopyWithImpl<_SonarrCalendarEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrCalendarEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrCalendarEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.airDateUtc, airDateUtc) || other.airDateUtc == airDateUtc)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.series, series) || other.series == series));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seasonNumber,episodeNumber,title,airDateUtc,hasFile,monitored,series);

@override
String toString() {
  return 'SonarrCalendarEpisode(id: $id, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title, airDateUtc: $airDateUtc, hasFile: $hasFile, monitored: $monitored, series: $series)';
}


}

/// @nodoc
abstract mixin class _$SonarrCalendarEpisodeCopyWith<$Res> implements $SonarrCalendarEpisodeCopyWith<$Res> {
  factory _$SonarrCalendarEpisodeCopyWith(_SonarrCalendarEpisode value, $Res Function(_SonarrCalendarEpisode) _then) = __$SonarrCalendarEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int id, int? seriesId, int? seasonNumber, int? episodeNumber, String? title, DateTime? airDateUtc, bool hasFile, bool monitored, SonarrSeries? series
});


@override $SonarrSeriesCopyWith<$Res>? get series;

}
/// @nodoc
class __$SonarrCalendarEpisodeCopyWithImpl<$Res>
    implements _$SonarrCalendarEpisodeCopyWith<$Res> {
  __$SonarrCalendarEpisodeCopyWithImpl(this._self, this._then);

  final _SonarrCalendarEpisode _self;
  final $Res Function(_SonarrCalendarEpisode) _then;

/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,Object? airDateUtc = freezed,Object? hasFile = null,Object? monitored = null,Object? series = freezed,}) {
  return _then(_SonarrCalendarEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,airDateUtc: freezed == airDateUtc ? _self.airDateUtc : airDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as SonarrSeries?,
  ));
}

/// Create a copy of SonarrCalendarEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrSeriesCopyWith<$Res>? get series {
    if (_self.series == null) {
    return null;
  }

  return $SonarrSeriesCopyWith<$Res>(_self.series!, (value) {
    return _then(_self.copyWith(series: value));
  });
}
}


/// @nodoc
mixin _$SonarrQualityProfile {

 int get id; String? get name;
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
 int id, String? name
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(SonarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? name)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? name)?  $default,) {final _that = this;
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
  const _SonarrQualityProfile({required this.id, this.name});
  factory _SonarrQualityProfile.fromJson(Map<String, dynamic> json) => _$SonarrQualityProfileFromJson(json);

@override final  int id;
@override final  String? name;

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
 int id, String? name
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(_SonarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SonarrRootFolder {

 int get id; String? get path; int? get freeSpace;
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
 int id, String? path, int? freeSpace
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = freezed,Object? freeSpace = freezed,}) {
  return _then(SonarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,freeSpace: freezed == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? path,  int? freeSpace)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? path,  int? freeSpace)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? path,  int? freeSpace)?  $default,) {final _that = this;
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
  const _SonarrRootFolder({required this.id, this.path, this.freeSpace});
  factory _SonarrRootFolder.fromJson(Map<String, dynamic> json) => _$SonarrRootFolderFromJson(json);

@override final  int id;
@override final  String? path;
@override final  int? freeSpace;

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
 int id, String? path, int? freeSpace
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = freezed,Object? freeSpace = freezed,}) {
  return _then(_SonarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,freeSpace: freezed == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SonarrQueueItem {

 int get id; int? get seriesId; int? get episodeId; String? get status; int get size; int get sizeleft; String? get title; String? get timeleft; DateTime? get estimatedCompletionTime;
/// Create a copy of SonarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrQueueItemCopyWith<SonarrQueueItem> get copyWith => _$SonarrQueueItemCopyWithImpl<SonarrQueueItem>(this as SonarrQueueItem, _$identity);

  /// Serializes this SonarrQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeleft, sizeleft) || other.sizeleft == sizeleft)&&(identical(other.title, title) || other.title == title)&&(identical(other.timeleft, timeleft) || other.timeleft == timeleft)&&(identical(other.estimatedCompletionTime, estimatedCompletionTime) || other.estimatedCompletionTime == estimatedCompletionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeId,status,size,sizeleft,title,timeleft,estimatedCompletionTime);

@override
String toString() {
  return 'SonarrQueueItem(id: $id, seriesId: $seriesId, episodeId: $episodeId, status: $status, size: $size, sizeleft: $sizeleft, title: $title, timeleft: $timeleft, estimatedCompletionTime: $estimatedCompletionTime)';
}


}

/// @nodoc
abstract mixin class $SonarrQueueItemCopyWith<$Res>  {
  factory $SonarrQueueItemCopyWith(SonarrQueueItem value, $Res Function(SonarrQueueItem) _then) = _$SonarrQueueItemCopyWithImpl;
@useResult
$Res call({
 int id, int? seriesId, int? episodeId, String? status, int size, int sizeleft, String? title, String? timeleft, DateTime? estimatedCompletionTime
});




}
/// @nodoc
class _$SonarrQueueItemCopyWithImpl<$Res>
    implements $SonarrQueueItemCopyWith<$Res> {
  _$SonarrQueueItemCopyWithImpl(this._self, this._then);

  final SonarrQueueItem _self;
  final $Res Function(SonarrQueueItem) _then;

/// Create a copy of SonarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = freezed,Object? episodeId = freezed,Object? status = freezed,Object? size = null,Object? sizeleft = null,Object? title = freezed,Object? timeleft = freezed,Object? estimatedCompletionTime = freezed,}) {
  return _then(SonarrQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sizeleft: null == sizeleft ? _self.sizeleft : sizeleft // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,timeleft: freezed == timeleft ? _self.timeleft : timeleft // ignore: cast_nullable_to_non_nullable
as String?,estimatedCompletionTime: freezed == estimatedCompletionTime ? _self.estimatedCompletionTime : estimatedCompletionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrQueueItem].
extension SonarrQueueItemPatterns on SonarrQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _SonarrQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? episodeId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrQueueItem() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? episodeId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)  $default,) {final _that = this;
switch (_that) {
case _SonarrQueueItem():
return $default(_that.id,_that.seriesId,_that.episodeId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? seriesId,  int? episodeId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)?  $default,) {final _that = this;
switch (_that) {
case _SonarrQueueItem() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrQueueItem implements SonarrQueueItem {
  const _SonarrQueueItem({required this.id, this.seriesId, this.episodeId, this.status, this.size = 0, this.sizeleft = 0, this.title, this.timeleft, this.estimatedCompletionTime});
  factory _SonarrQueueItem.fromJson(Map<String, dynamic> json) => _$SonarrQueueItemFromJson(json);

@override final  int id;
@override final  int? seriesId;
@override final  int? episodeId;
@override final  String? status;
@override@JsonKey() final  int size;
@override@JsonKey() final  int sizeleft;
@override final  String? title;
@override final  String? timeleft;
@override final  DateTime? estimatedCompletionTime;

/// Create a copy of SonarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrQueueItemCopyWith<_SonarrQueueItem> get copyWith => __$SonarrQueueItemCopyWithImpl<_SonarrQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeleft, sizeleft) || other.sizeleft == sizeleft)&&(identical(other.title, title) || other.title == title)&&(identical(other.timeleft, timeleft) || other.timeleft == timeleft)&&(identical(other.estimatedCompletionTime, estimatedCompletionTime) || other.estimatedCompletionTime == estimatedCompletionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeId,status,size,sizeleft,title,timeleft,estimatedCompletionTime);

@override
String toString() {
  return 'SonarrQueueItem(id: $id, seriesId: $seriesId, episodeId: $episodeId, status: $status, size: $size, sizeleft: $sizeleft, title: $title, timeleft: $timeleft, estimatedCompletionTime: $estimatedCompletionTime)';
}


}

/// @nodoc
abstract mixin class _$SonarrQueueItemCopyWith<$Res> implements $SonarrQueueItemCopyWith<$Res> {
  factory _$SonarrQueueItemCopyWith(_SonarrQueueItem value, $Res Function(_SonarrQueueItem) _then) = __$SonarrQueueItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int? seriesId, int? episodeId, String? status, int size, int sizeleft, String? title, String? timeleft, DateTime? estimatedCompletionTime
});




}
/// @nodoc
class __$SonarrQueueItemCopyWithImpl<$Res>
    implements _$SonarrQueueItemCopyWith<$Res> {
  __$SonarrQueueItemCopyWithImpl(this._self, this._then);

  final _SonarrQueueItem _self;
  final $Res Function(_SonarrQueueItem) _then;

/// Create a copy of SonarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = freezed,Object? episodeId = freezed,Object? status = freezed,Object? size = null,Object? sizeleft = null,Object? title = freezed,Object? timeleft = freezed,Object? estimatedCompletionTime = freezed,}) {
  return _then(_SonarrQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sizeleft: null == sizeleft ? _self.sizeleft : sizeleft // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,timeleft: freezed == timeleft ? _self.timeleft : timeleft // ignore: cast_nullable_to_non_nullable
as String?,estimatedCompletionTime: freezed == estimatedCompletionTime ? _self.estimatedCompletionTime : estimatedCompletionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
