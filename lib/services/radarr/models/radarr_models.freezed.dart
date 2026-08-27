// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radarr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RadarrMovie {

/// Unique ID in the Radarr database (null for lookup results).
 int? get id; String get title; int? get year; bool get monitored; String? get status; String? get overview; String? get sortTitle; DateTime? get added; List<RadarrImage>? get images; int? get qualityProfileId; String? get rootFolderPath; String? get path; RadarrMovieFile? get movieFile; int? get tmdbId; String? get imdbId; String? get titleSlug; String? get studio; String? get certification; int? get runtime; List<String>? get genres; RadarrRatings? get ratings; String get minimumAvailability; DateTime? get inCinemas; DateTime? get physicalRelease; DateTime? get digitalRelease; bool get hasFile; int get sizeOnDisk; RadarrAddOptions? get addOptions;
/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrMovieCopyWith<RadarrMovie> get copyWith => _$RadarrMovieCopyWithImpl<RadarrMovie>(this as RadarrMovie, _$identity);

  /// Serializes this RadarrMovie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.rootFolderPath, rootFolderPath) || other.rootFolderPath == rootFolderPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.movieFile, movieFile) || other.movieFile == movieFile)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.studio, studio) || other.studio == studio)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.ratings, ratings) || other.ratings == ratings)&&(identical(other.minimumAvailability, minimumAvailability) || other.minimumAvailability == minimumAvailability)&&(identical(other.inCinemas, inCinemas) || other.inCinemas == inCinemas)&&(identical(other.physicalRelease, physicalRelease) || other.physicalRelease == physicalRelease)&&(identical(other.digitalRelease, digitalRelease) || other.digitalRelease == digitalRelease)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.sizeOnDisk, sizeOnDisk) || other.sizeOnDisk == sizeOnDisk)&&(identical(other.addOptions, addOptions) || other.addOptions == addOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,year,monitored,status,overview,sortTitle,added,const DeepCollectionEquality().hash(images),qualityProfileId,rootFolderPath,path,movieFile,tmdbId,imdbId,titleSlug,studio,certification,runtime,const DeepCollectionEquality().hash(genres),ratings,minimumAvailability,inCinemas,physicalRelease,digitalRelease,hasFile,sizeOnDisk,addOptions]);

@override
String toString() {
  return 'RadarrMovie(id: $id, title: $title, year: $year, monitored: $monitored, status: $status, overview: $overview, sortTitle: $sortTitle, added: $added, images: $images, qualityProfileId: $qualityProfileId, rootFolderPath: $rootFolderPath, path: $path, movieFile: $movieFile, tmdbId: $tmdbId, imdbId: $imdbId, titleSlug: $titleSlug, studio: $studio, certification: $certification, runtime: $runtime, genres: $genres, ratings: $ratings, minimumAvailability: $minimumAvailability, inCinemas: $inCinemas, physicalRelease: $physicalRelease, digitalRelease: $digitalRelease, hasFile: $hasFile, sizeOnDisk: $sizeOnDisk, addOptions: $addOptions)';
}


}

/// @nodoc
abstract mixin class $RadarrMovieCopyWith<$Res>  {
  factory $RadarrMovieCopyWith(RadarrMovie value, $Res Function(RadarrMovie) _then) = _$RadarrMovieCopyWithImpl;
@useResult
$Res call({
 int? id, String title, int? year, bool monitored, String? status, String? overview, String? sortTitle, DateTime? added, List<RadarrImage>? images, int? qualityProfileId, String? rootFolderPath, String? path, RadarrMovieFile? movieFile, int? tmdbId, String? imdbId, String? titleSlug, String? studio, String? certification, int? runtime, List<String>? genres, RadarrRatings? ratings, String minimumAvailability, DateTime? inCinemas, DateTime? physicalRelease, DateTime? digitalRelease, bool hasFile, int sizeOnDisk, RadarrAddOptions? addOptions
});


$RadarrMovieFileCopyWith<$Res>? get movieFile;$RadarrRatingsCopyWith<$Res>? get ratings;$RadarrAddOptionsCopyWith<$Res>? get addOptions;

}
/// @nodoc
class _$RadarrMovieCopyWithImpl<$Res>
    implements $RadarrMovieCopyWith<$Res> {
  _$RadarrMovieCopyWithImpl(this._self, this._then);

  final RadarrMovie _self;
  final $Res Function(RadarrMovie) _then;

/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? year = freezed,Object? monitored = null,Object? status = freezed,Object? overview = freezed,Object? sortTitle = freezed,Object? added = freezed,Object? images = freezed,Object? qualityProfileId = freezed,Object? rootFolderPath = freezed,Object? path = freezed,Object? movieFile = freezed,Object? tmdbId = freezed,Object? imdbId = freezed,Object? titleSlug = freezed,Object? studio = freezed,Object? certification = freezed,Object? runtime = freezed,Object? genres = freezed,Object? ratings = freezed,Object? minimumAvailability = null,Object? inCinemas = freezed,Object? physicalRelease = freezed,Object? digitalRelease = freezed,Object? hasFile = null,Object? sizeOnDisk = null,Object? addOptions = freezed,}) {
  return _then(RadarrMovie(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,sortTitle: freezed == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<RadarrImage>?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,rootFolderPath: freezed == rootFolderPath ? _self.rootFolderPath : rootFolderPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,movieFile: freezed == movieFile ? _self.movieFile : movieFile // ignore: cast_nullable_to_non_nullable
as RadarrMovieFile?,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,studio: freezed == studio ? _self.studio : studio // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,ratings: freezed == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as RadarrRatings?,minimumAvailability: null == minimumAvailability ? _self.minimumAvailability : minimumAvailability // ignore: cast_nullable_to_non_nullable
as String,inCinemas: freezed == inCinemas ? _self.inCinemas : inCinemas // ignore: cast_nullable_to_non_nullable
as DateTime?,physicalRelease: freezed == physicalRelease ? _self.physicalRelease : physicalRelease // ignore: cast_nullable_to_non_nullable
as DateTime?,digitalRelease: freezed == digitalRelease ? _self.digitalRelease : digitalRelease // ignore: cast_nullable_to_non_nullable
as DateTime?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,sizeOnDisk: null == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int,addOptions: freezed == addOptions ? _self.addOptions : addOptions // ignore: cast_nullable_to_non_nullable
as RadarrAddOptions?,
  ));
}
/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrMovieFileCopyWith<$Res>? get movieFile {
    if (_self.movieFile == null) {
    return null;
  }

  return $RadarrMovieFileCopyWith<$Res>(_self.movieFile!, (value) {
    return _then(_self.copyWith(movieFile: value));
  });
}/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingsCopyWith<$Res>? get ratings {
    if (_self.ratings == null) {
    return null;
  }

  return $RadarrRatingsCopyWith<$Res>(_self.ratings!, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrAddOptionsCopyWith<$Res>? get addOptions {
    if (_self.addOptions == null) {
    return null;
  }

  return $RadarrAddOptionsCopyWith<$Res>(_self.addOptions!, (value) {
    return _then(_self.copyWith(addOptions: value));
  });
}
}


/// Adds pattern-matching-related methods to [RadarrMovie].
extension RadarrMoviePatterns on RadarrMovie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrMovie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrMovie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrMovie value)  $default,){
final _that = this;
switch (_that) {
case _RadarrMovie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrMovie value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrMovie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String title,  int? year,  bool monitored,  String? status,  String? overview,  String? sortTitle,  DateTime? added,  List<RadarrImage>? images,  int? qualityProfileId,  String? rootFolderPath,  String? path,  RadarrMovieFile? movieFile,  int? tmdbId,  String? imdbId,  String? titleSlug,  String? studio,  String? certification,  int? runtime,  List<String>? genres,  RadarrRatings? ratings,  String minimumAvailability,  DateTime? inCinemas,  DateTime? physicalRelease,  DateTime? digitalRelease,  bool hasFile,  int sizeOnDisk,  RadarrAddOptions? addOptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrMovie() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.monitored,_that.status,_that.overview,_that.sortTitle,_that.added,_that.images,_that.qualityProfileId,_that.rootFolderPath,_that.path,_that.movieFile,_that.tmdbId,_that.imdbId,_that.titleSlug,_that.studio,_that.certification,_that.runtime,_that.genres,_that.ratings,_that.minimumAvailability,_that.inCinemas,_that.physicalRelease,_that.digitalRelease,_that.hasFile,_that.sizeOnDisk,_that.addOptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String title,  int? year,  bool monitored,  String? status,  String? overview,  String? sortTitle,  DateTime? added,  List<RadarrImage>? images,  int? qualityProfileId,  String? rootFolderPath,  String? path,  RadarrMovieFile? movieFile,  int? tmdbId,  String? imdbId,  String? titleSlug,  String? studio,  String? certification,  int? runtime,  List<String>? genres,  RadarrRatings? ratings,  String minimumAvailability,  DateTime? inCinemas,  DateTime? physicalRelease,  DateTime? digitalRelease,  bool hasFile,  int sizeOnDisk,  RadarrAddOptions? addOptions)  $default,) {final _that = this;
switch (_that) {
case _RadarrMovie():
return $default(_that.id,_that.title,_that.year,_that.monitored,_that.status,_that.overview,_that.sortTitle,_that.added,_that.images,_that.qualityProfileId,_that.rootFolderPath,_that.path,_that.movieFile,_that.tmdbId,_that.imdbId,_that.titleSlug,_that.studio,_that.certification,_that.runtime,_that.genres,_that.ratings,_that.minimumAvailability,_that.inCinemas,_that.physicalRelease,_that.digitalRelease,_that.hasFile,_that.sizeOnDisk,_that.addOptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String title,  int? year,  bool monitored,  String? status,  String? overview,  String? sortTitle,  DateTime? added,  List<RadarrImage>? images,  int? qualityProfileId,  String? rootFolderPath,  String? path,  RadarrMovieFile? movieFile,  int? tmdbId,  String? imdbId,  String? titleSlug,  String? studio,  String? certification,  int? runtime,  List<String>? genres,  RadarrRatings? ratings,  String minimumAvailability,  DateTime? inCinemas,  DateTime? physicalRelease,  DateTime? digitalRelease,  bool hasFile,  int sizeOnDisk,  RadarrAddOptions? addOptions)?  $default,) {final _that = this;
switch (_that) {
case _RadarrMovie() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.monitored,_that.status,_that.overview,_that.sortTitle,_that.added,_that.images,_that.qualityProfileId,_that.rootFolderPath,_that.path,_that.movieFile,_that.tmdbId,_that.imdbId,_that.titleSlug,_that.studio,_that.certification,_that.runtime,_that.genres,_that.ratings,_that.minimumAvailability,_that.inCinemas,_that.physicalRelease,_that.digitalRelease,_that.hasFile,_that.sizeOnDisk,_that.addOptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrMovie implements RadarrMovie {
  const _RadarrMovie({this.id, this.title = 'Unknown', this.year, this.monitored = true, this.status, this.overview, this.sortTitle, this.added,  List<RadarrImage>? images, this.qualityProfileId, this.rootFolderPath, this.path, this.movieFile, this.tmdbId, this.imdbId, this.titleSlug, this.studio, this.certification, this.runtime,  List<String>? genres, this.ratings, this.minimumAvailability = 'announced', this.inCinemas, this.physicalRelease, this.digitalRelease, this.hasFile = false, this.sizeOnDisk = 0, this.addOptions}): _images = images,_genres = genres;
  factory _RadarrMovie.fromJson(Map<String, dynamic> json) => _$RadarrMovieFromJson(json);

/// Unique ID in the Radarr database (null for lookup results).
@override final  int? id;
@override@JsonKey() final  String title;
@override final  int? year;
@override@JsonKey() final  bool monitored;
@override final  String? status;
@override final  String? overview;
@override final  String? sortTitle;
@override final  DateTime? added;
 final  List<RadarrImage>? _images;
@override List<RadarrImage>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? qualityProfileId;
@override final  String? rootFolderPath;
@override final  String? path;
@override final  RadarrMovieFile? movieFile;
@override final  int? tmdbId;
@override final  String? imdbId;
@override final  String? titleSlug;
@override final  String? studio;
@override final  String? certification;
@override final  int? runtime;
 final  List<String>? _genres;
@override List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  RadarrRatings? ratings;
@override@JsonKey() final  String minimumAvailability;
@override final  DateTime? inCinemas;
@override final  DateTime? physicalRelease;
@override final  DateTime? digitalRelease;
@override@JsonKey() final  bool hasFile;
@override@JsonKey() final  int sizeOnDisk;
@override final  RadarrAddOptions? addOptions;

/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrMovieCopyWith<_RadarrMovie> get copyWith => __$RadarrMovieCopyWithImpl<_RadarrMovie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrMovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.monitored, monitored) || other.monitored == monitored)&&(identical(other.status, status) || other.status == status)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.sortTitle, sortTitle) || other.sortTitle == sortTitle)&&(identical(other.added, added) || other.added == added)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.qualityProfileId, qualityProfileId) || other.qualityProfileId == qualityProfileId)&&(identical(other.rootFolderPath, rootFolderPath) || other.rootFolderPath == rootFolderPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.movieFile, movieFile) || other.movieFile == movieFile)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.titleSlug, titleSlug) || other.titleSlug == titleSlug)&&(identical(other.studio, studio) || other.studio == studio)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.ratings, ratings) || other.ratings == ratings)&&(identical(other.minimumAvailability, minimumAvailability) || other.minimumAvailability == minimumAvailability)&&(identical(other.inCinemas, inCinemas) || other.inCinemas == inCinemas)&&(identical(other.physicalRelease, physicalRelease) || other.physicalRelease == physicalRelease)&&(identical(other.digitalRelease, digitalRelease) || other.digitalRelease == digitalRelease)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.sizeOnDisk, sizeOnDisk) || other.sizeOnDisk == sizeOnDisk)&&(identical(other.addOptions, addOptions) || other.addOptions == addOptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,year,monitored,status,overview,sortTitle,added,const DeepCollectionEquality().hash(_images),qualityProfileId,rootFolderPath,path,movieFile,tmdbId,imdbId,titleSlug,studio,certification,runtime,const DeepCollectionEquality().hash(_genres),ratings,minimumAvailability,inCinemas,physicalRelease,digitalRelease,hasFile,sizeOnDisk,addOptions]);

@override
String toString() {
  return 'RadarrMovie(id: $id, title: $title, year: $year, monitored: $monitored, status: $status, overview: $overview, sortTitle: $sortTitle, added: $added, images: $images, qualityProfileId: $qualityProfileId, rootFolderPath: $rootFolderPath, path: $path, movieFile: $movieFile, tmdbId: $tmdbId, imdbId: $imdbId, titleSlug: $titleSlug, studio: $studio, certification: $certification, runtime: $runtime, genres: $genres, ratings: $ratings, minimumAvailability: $minimumAvailability, inCinemas: $inCinemas, physicalRelease: $physicalRelease, digitalRelease: $digitalRelease, hasFile: $hasFile, sizeOnDisk: $sizeOnDisk, addOptions: $addOptions)';
}


}

/// @nodoc
abstract mixin class _$RadarrMovieCopyWith<$Res> implements $RadarrMovieCopyWith<$Res> {
  factory _$RadarrMovieCopyWith(_RadarrMovie value, $Res Function(_RadarrMovie) _then) = __$RadarrMovieCopyWithImpl;
@override @useResult
$Res call({
 int? id, String title, int? year, bool monitored, String? status, String? overview, String? sortTitle, DateTime? added, List<RadarrImage>? images, int? qualityProfileId, String? rootFolderPath, String? path, RadarrMovieFile? movieFile, int? tmdbId, String? imdbId, String? titleSlug, String? studio, String? certification, int? runtime, List<String>? genres, RadarrRatings? ratings, String minimumAvailability, DateTime? inCinemas, DateTime? physicalRelease, DateTime? digitalRelease, bool hasFile, int sizeOnDisk, RadarrAddOptions? addOptions
});


@override $RadarrMovieFileCopyWith<$Res>? get movieFile;@override $RadarrRatingsCopyWith<$Res>? get ratings;@override $RadarrAddOptionsCopyWith<$Res>? get addOptions;

}
/// @nodoc
class __$RadarrMovieCopyWithImpl<$Res>
    implements _$RadarrMovieCopyWith<$Res> {
  __$RadarrMovieCopyWithImpl(this._self, this._then);

  final _RadarrMovie _self;
  final $Res Function(_RadarrMovie) _then;

/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? year = freezed,Object? monitored = null,Object? status = freezed,Object? overview = freezed,Object? sortTitle = freezed,Object? added = freezed,Object? images = freezed,Object? qualityProfileId = freezed,Object? rootFolderPath = freezed,Object? path = freezed,Object? movieFile = freezed,Object? tmdbId = freezed,Object? imdbId = freezed,Object? titleSlug = freezed,Object? studio = freezed,Object? certification = freezed,Object? runtime = freezed,Object? genres = freezed,Object? ratings = freezed,Object? minimumAvailability = null,Object? inCinemas = freezed,Object? physicalRelease = freezed,Object? digitalRelease = freezed,Object? hasFile = null,Object? sizeOnDisk = null,Object? addOptions = freezed,}) {
  return _then(_RadarrMovie(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,monitored: null == monitored ? _self.monitored : monitored // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,sortTitle: freezed == sortTitle ? _self.sortTitle : sortTitle // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<RadarrImage>?,qualityProfileId: freezed == qualityProfileId ? _self.qualityProfileId : qualityProfileId // ignore: cast_nullable_to_non_nullable
as int?,rootFolderPath: freezed == rootFolderPath ? _self.rootFolderPath : rootFolderPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,movieFile: freezed == movieFile ? _self.movieFile : movieFile // ignore: cast_nullable_to_non_nullable
as RadarrMovieFile?,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,titleSlug: freezed == titleSlug ? _self.titleSlug : titleSlug // ignore: cast_nullable_to_non_nullable
as String?,studio: freezed == studio ? _self.studio : studio // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,ratings: freezed == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as RadarrRatings?,minimumAvailability: null == minimumAvailability ? _self.minimumAvailability : minimumAvailability // ignore: cast_nullable_to_non_nullable
as String,inCinemas: freezed == inCinemas ? _self.inCinemas : inCinemas // ignore: cast_nullable_to_non_nullable
as DateTime?,physicalRelease: freezed == physicalRelease ? _self.physicalRelease : physicalRelease // ignore: cast_nullable_to_non_nullable
as DateTime?,digitalRelease: freezed == digitalRelease ? _self.digitalRelease : digitalRelease // ignore: cast_nullable_to_non_nullable
as DateTime?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,sizeOnDisk: null == sizeOnDisk ? _self.sizeOnDisk : sizeOnDisk // ignore: cast_nullable_to_non_nullable
as int,addOptions: freezed == addOptions ? _self.addOptions : addOptions // ignore: cast_nullable_to_non_nullable
as RadarrAddOptions?,
  ));
}

/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrMovieFileCopyWith<$Res>? get movieFile {
    if (_self.movieFile == null) {
    return null;
  }

  return $RadarrMovieFileCopyWith<$Res>(_self.movieFile!, (value) {
    return _then(_self.copyWith(movieFile: value));
  });
}/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingsCopyWith<$Res>? get ratings {
    if (_self.ratings == null) {
    return null;
  }

  return $RadarrRatingsCopyWith<$Res>(_self.ratings!, (value) {
    return _then(_self.copyWith(ratings: value));
  });
}/// Create a copy of RadarrMovie
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrAddOptionsCopyWith<$Res>? get addOptions {
    if (_self.addOptions == null) {
    return null;
  }

  return $RadarrAddOptionsCopyWith<$Res>(_self.addOptions!, (value) {
    return _then(_self.copyWith(addOptions: value));
  });
}
}


/// @nodoc
mixin _$RadarrAddOptions {

 bool get searchForMovie; String get monitor;
/// Create a copy of RadarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrAddOptionsCopyWith<RadarrAddOptions> get copyWith => _$RadarrAddOptionsCopyWithImpl<RadarrAddOptions>(this as RadarrAddOptions, _$identity);

  /// Serializes this RadarrAddOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrAddOptions&&(identical(other.searchForMovie, searchForMovie) || other.searchForMovie == searchForMovie)&&(identical(other.monitor, monitor) || other.monitor == monitor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchForMovie,monitor);

@override
String toString() {
  return 'RadarrAddOptions(searchForMovie: $searchForMovie, monitor: $monitor)';
}


}

/// @nodoc
abstract mixin class $RadarrAddOptionsCopyWith<$Res>  {
  factory $RadarrAddOptionsCopyWith(RadarrAddOptions value, $Res Function(RadarrAddOptions) _then) = _$RadarrAddOptionsCopyWithImpl;
@useResult
$Res call({
 bool searchForMovie, String monitor
});




}
/// @nodoc
class _$RadarrAddOptionsCopyWithImpl<$Res>
    implements $RadarrAddOptionsCopyWith<$Res> {
  _$RadarrAddOptionsCopyWithImpl(this._self, this._then);

  final RadarrAddOptions _self;
  final $Res Function(RadarrAddOptions) _then;

/// Create a copy of RadarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchForMovie = null,Object? monitor = null,}) {
  return _then(RadarrAddOptions(
searchForMovie: null == searchForMovie ? _self.searchForMovie : searchForMovie // ignore: cast_nullable_to_non_nullable
as bool,monitor: null == monitor ? _self.monitor : monitor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrAddOptions].
extension RadarrAddOptionsPatterns on RadarrAddOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrAddOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrAddOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrAddOptions value)  $default,){
final _that = this;
switch (_that) {
case _RadarrAddOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrAddOptions value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrAddOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool searchForMovie,  String monitor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrAddOptions() when $default != null:
return $default(_that.searchForMovie,_that.monitor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool searchForMovie,  String monitor)  $default,) {final _that = this;
switch (_that) {
case _RadarrAddOptions():
return $default(_that.searchForMovie,_that.monitor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool searchForMovie,  String monitor)?  $default,) {final _that = this;
switch (_that) {
case _RadarrAddOptions() when $default != null:
return $default(_that.searchForMovie,_that.monitor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrAddOptions implements RadarrAddOptions {
  const _RadarrAddOptions({this.searchForMovie = false, this.monitor = 'movieOnly'});
  factory _RadarrAddOptions.fromJson(Map<String, dynamic> json) => _$RadarrAddOptionsFromJson(json);

@override@JsonKey() final  bool searchForMovie;
@override@JsonKey() final  String monitor;

/// Create a copy of RadarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrAddOptionsCopyWith<_RadarrAddOptions> get copyWith => __$RadarrAddOptionsCopyWithImpl<_RadarrAddOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrAddOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrAddOptions&&(identical(other.searchForMovie, searchForMovie) || other.searchForMovie == searchForMovie)&&(identical(other.monitor, monitor) || other.monitor == monitor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchForMovie,monitor);

@override
String toString() {
  return 'RadarrAddOptions(searchForMovie: $searchForMovie, monitor: $monitor)';
}


}

/// @nodoc
abstract mixin class _$RadarrAddOptionsCopyWith<$Res> implements $RadarrAddOptionsCopyWith<$Res> {
  factory _$RadarrAddOptionsCopyWith(_RadarrAddOptions value, $Res Function(_RadarrAddOptions) _then) = __$RadarrAddOptionsCopyWithImpl;
@override @useResult
$Res call({
 bool searchForMovie, String monitor
});




}
/// @nodoc
class __$RadarrAddOptionsCopyWithImpl<$Res>
    implements _$RadarrAddOptionsCopyWith<$Res> {
  __$RadarrAddOptionsCopyWithImpl(this._self, this._then);

  final _RadarrAddOptions _self;
  final $Res Function(_RadarrAddOptions) _then;

/// Create a copy of RadarrAddOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchForMovie = null,Object? monitor = null,}) {
  return _then(_RadarrAddOptions(
searchForMovie: null == searchForMovie ? _self.searchForMovie : searchForMovie // ignore: cast_nullable_to_non_nullable
as bool,monitor: null == monitor ? _self.monitor : monitor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RadarrImage {

 String? get coverType; String? get url; String? get remoteUrl;
/// Create a copy of RadarrImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrImageCopyWith<RadarrImage> get copyWith => _$RadarrImageCopyWithImpl<RadarrImage>(this as RadarrImage, _$identity);

  /// Serializes this RadarrImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrImage&&(identical(other.coverType, coverType) || other.coverType == coverType)&&(identical(other.url, url) || other.url == url)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverType,url,remoteUrl);

@override
String toString() {
  return 'RadarrImage(coverType: $coverType, url: $url, remoteUrl: $remoteUrl)';
}


}

/// @nodoc
abstract mixin class $RadarrImageCopyWith<$Res>  {
  factory $RadarrImageCopyWith(RadarrImage value, $Res Function(RadarrImage) _then) = _$RadarrImageCopyWithImpl;
@useResult
$Res call({
 String? coverType, String? url, String? remoteUrl
});




}
/// @nodoc
class _$RadarrImageCopyWithImpl<$Res>
    implements $RadarrImageCopyWith<$Res> {
  _$RadarrImageCopyWithImpl(this._self, this._then);

  final RadarrImage _self;
  final $Res Function(RadarrImage) _then;

/// Create a copy of RadarrImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverType = freezed,Object? url = freezed,Object? remoteUrl = freezed,}) {
  return _then(RadarrImage(
coverType: freezed == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrImage].
extension RadarrImagePatterns on RadarrImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrImage value)  $default,){
final _that = this;
switch (_that) {
case _RadarrImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrImage value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrImage() when $default != null:
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
case _RadarrImage() when $default != null:
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
case _RadarrImage():
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
case _RadarrImage() when $default != null:
return $default(_that.coverType,_that.url,_that.remoteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrImage implements RadarrImage {
  const _RadarrImage({this.coverType, this.url, this.remoteUrl});
  factory _RadarrImage.fromJson(Map<String, dynamic> json) => _$RadarrImageFromJson(json);

@override final  String? coverType;
@override final  String? url;
@override final  String? remoteUrl;

/// Create a copy of RadarrImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrImageCopyWith<_RadarrImage> get copyWith => __$RadarrImageCopyWithImpl<_RadarrImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrImage&&(identical(other.coverType, coverType) || other.coverType == coverType)&&(identical(other.url, url) || other.url == url)&&(identical(other.remoteUrl, remoteUrl) || other.remoteUrl == remoteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverType,url,remoteUrl);

@override
String toString() {
  return 'RadarrImage(coverType: $coverType, url: $url, remoteUrl: $remoteUrl)';
}


}

/// @nodoc
abstract mixin class _$RadarrImageCopyWith<$Res> implements $RadarrImageCopyWith<$Res> {
  factory _$RadarrImageCopyWith(_RadarrImage value, $Res Function(_RadarrImage) _then) = __$RadarrImageCopyWithImpl;
@override @useResult
$Res call({
 String? coverType, String? url, String? remoteUrl
});




}
/// @nodoc
class __$RadarrImageCopyWithImpl<$Res>
    implements _$RadarrImageCopyWith<$Res> {
  __$RadarrImageCopyWithImpl(this._self, this._then);

  final _RadarrImage _self;
  final $Res Function(_RadarrImage) _then;

/// Create a copy of RadarrImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverType = freezed,Object? url = freezed,Object? remoteUrl = freezed,}) {
  return _then(_RadarrImage(
coverType: freezed == coverType ? _self.coverType : coverType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,remoteUrl: freezed == remoteUrl ? _self.remoteUrl : remoteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RadarrMovieFile {

 int get id; String? get relativePath; int? get size; DateTime? get dateAdded; RadarrQualityInfo? get quality;
/// Create a copy of RadarrMovieFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrMovieFileCopyWith<RadarrMovieFile> get copyWith => _$RadarrMovieFileCopyWithImpl<RadarrMovieFile>(this as RadarrMovieFile, _$identity);

  /// Serializes this RadarrMovieFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrMovieFile&&(identical(other.id, id) || other.id == id)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.size, size) || other.size == size)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relativePath,size,dateAdded,quality);

@override
String toString() {
  return 'RadarrMovieFile(id: $id, relativePath: $relativePath, size: $size, dateAdded: $dateAdded, quality: $quality)';
}


}

/// @nodoc
abstract mixin class $RadarrMovieFileCopyWith<$Res>  {
  factory $RadarrMovieFileCopyWith(RadarrMovieFile value, $Res Function(RadarrMovieFile) _then) = _$RadarrMovieFileCopyWithImpl;
@useResult
$Res call({
 int id, String? relativePath, int? size, DateTime? dateAdded, RadarrQualityInfo? quality
});


$RadarrQualityInfoCopyWith<$Res>? get quality;

}
/// @nodoc
class _$RadarrMovieFileCopyWithImpl<$Res>
    implements $RadarrMovieFileCopyWith<$Res> {
  _$RadarrMovieFileCopyWithImpl(this._self, this._then);

  final RadarrMovieFile _self;
  final $Res Function(RadarrMovieFile) _then;

/// Create a copy of RadarrMovieFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? relativePath = freezed,Object? size = freezed,Object? dateAdded = freezed,Object? quality = freezed,}) {
  return _then(RadarrMovieFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,relativePath: freezed == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQualityInfo?,
  ));
}
/// Create a copy of RadarrMovieFile
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
}
}


/// Adds pattern-matching-related methods to [RadarrMovieFile].
extension RadarrMovieFilePatterns on RadarrMovieFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrMovieFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrMovieFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrMovieFile value)  $default,){
final _that = this;
switch (_that) {
case _RadarrMovieFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrMovieFile value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrMovieFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? relativePath,  int? size,  DateTime? dateAdded,  RadarrQualityInfo? quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrMovieFile() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? relativePath,  int? size,  DateTime? dateAdded,  RadarrQualityInfo? quality)  $default,) {final _that = this;
switch (_that) {
case _RadarrMovieFile():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? relativePath,  int? size,  DateTime? dateAdded,  RadarrQualityInfo? quality)?  $default,) {final _that = this;
switch (_that) {
case _RadarrMovieFile() when $default != null:
return $default(_that.id,_that.relativePath,_that.size,_that.dateAdded,_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrMovieFile implements RadarrMovieFile {
  const _RadarrMovieFile({required this.id, this.relativePath, this.size, this.dateAdded, this.quality});
  factory _RadarrMovieFile.fromJson(Map<String, dynamic> json) => _$RadarrMovieFileFromJson(json);

@override final  int id;
@override final  String? relativePath;
@override final  int? size;
@override final  DateTime? dateAdded;
@override final  RadarrQualityInfo? quality;

/// Create a copy of RadarrMovieFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrMovieFileCopyWith<_RadarrMovieFile> get copyWith => __$RadarrMovieFileCopyWithImpl<_RadarrMovieFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrMovieFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrMovieFile&&(identical(other.id, id) || other.id == id)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.size, size) || other.size == size)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relativePath,size,dateAdded,quality);

@override
String toString() {
  return 'RadarrMovieFile(id: $id, relativePath: $relativePath, size: $size, dateAdded: $dateAdded, quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$RadarrMovieFileCopyWith<$Res> implements $RadarrMovieFileCopyWith<$Res> {
  factory _$RadarrMovieFileCopyWith(_RadarrMovieFile value, $Res Function(_RadarrMovieFile) _then) = __$RadarrMovieFileCopyWithImpl;
@override @useResult
$Res call({
 int id, String? relativePath, int? size, DateTime? dateAdded, RadarrQualityInfo? quality
});


@override $RadarrQualityInfoCopyWith<$Res>? get quality;

}
/// @nodoc
class __$RadarrMovieFileCopyWithImpl<$Res>
    implements _$RadarrMovieFileCopyWith<$Res> {
  __$RadarrMovieFileCopyWithImpl(this._self, this._then);

  final _RadarrMovieFile _self;
  final $Res Function(_RadarrMovieFile) _then;

/// Create a copy of RadarrMovieFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? relativePath = freezed,Object? size = freezed,Object? dateAdded = freezed,Object? quality = freezed,}) {
  return _then(_RadarrMovieFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,relativePath: freezed == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQualityInfo?,
  ));
}

/// Create a copy of RadarrMovieFile
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
}
}


/// @nodoc
mixin _$RadarrQualityInfo {

 RadarrQuality? get quality;
/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrQualityInfoCopyWith<RadarrQualityInfo> get copyWith => _$RadarrQualityInfoCopyWithImpl<RadarrQualityInfo>(this as RadarrQualityInfo, _$identity);

  /// Serializes this RadarrQualityInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrQualityInfo&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality);

@override
String toString() {
  return 'RadarrQualityInfo(quality: $quality)';
}


}

/// @nodoc
abstract mixin class $RadarrQualityInfoCopyWith<$Res>  {
  factory $RadarrQualityInfoCopyWith(RadarrQualityInfo value, $Res Function(RadarrQualityInfo) _then) = _$RadarrQualityInfoCopyWithImpl;
@useResult
$Res call({
 RadarrQuality? quality
});


$RadarrQualityCopyWith<$Res>? get quality;

}
/// @nodoc
class _$RadarrQualityInfoCopyWithImpl<$Res>
    implements $RadarrQualityInfoCopyWith<$Res> {
  _$RadarrQualityInfoCopyWithImpl(this._self, this._then);

  final RadarrQualityInfo _self;
  final $Res Function(RadarrQualityInfo) _then;

/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quality = freezed,}) {
  return _then(RadarrQualityInfo(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQuality?,
  ));
}
/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrQualityCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $RadarrQualityCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// Adds pattern-matching-related methods to [RadarrQualityInfo].
extension RadarrQualityInfoPatterns on RadarrQualityInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrQualityInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrQualityInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrQualityInfo value)  $default,){
final _that = this;
switch (_that) {
case _RadarrQualityInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrQualityInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrQualityInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RadarrQuality? quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrQualityInfo() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RadarrQuality? quality)  $default,) {final _that = this;
switch (_that) {
case _RadarrQualityInfo():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RadarrQuality? quality)?  $default,) {final _that = this;
switch (_that) {
case _RadarrQualityInfo() when $default != null:
return $default(_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrQualityInfo implements RadarrQualityInfo {
  const _RadarrQualityInfo({this.quality});
  factory _RadarrQualityInfo.fromJson(Map<String, dynamic> json) => _$RadarrQualityInfoFromJson(json);

@override final  RadarrQuality? quality;

/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrQualityInfoCopyWith<_RadarrQualityInfo> get copyWith => __$RadarrQualityInfoCopyWithImpl<_RadarrQualityInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrQualityInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrQualityInfo&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality);

@override
String toString() {
  return 'RadarrQualityInfo(quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$RadarrQualityInfoCopyWith<$Res> implements $RadarrQualityInfoCopyWith<$Res> {
  factory _$RadarrQualityInfoCopyWith(_RadarrQualityInfo value, $Res Function(_RadarrQualityInfo) _then) = __$RadarrQualityInfoCopyWithImpl;
@override @useResult
$Res call({
 RadarrQuality? quality
});


@override $RadarrQualityCopyWith<$Res>? get quality;

}
/// @nodoc
class __$RadarrQualityInfoCopyWithImpl<$Res>
    implements _$RadarrQualityInfoCopyWith<$Res> {
  __$RadarrQualityInfoCopyWithImpl(this._self, this._then);

  final _RadarrQualityInfo _self;
  final $Res Function(_RadarrQualityInfo) _then;

/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quality = freezed,}) {
  return _then(_RadarrQualityInfo(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RadarrQuality?,
  ));
}

/// Create a copy of RadarrQualityInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrQualityCopyWith<$Res>? get quality {
    if (_self.quality == null) {
    return null;
  }

  return $RadarrQualityCopyWith<$Res>(_self.quality!, (value) {
    return _then(_self.copyWith(quality: value));
  });
}
}


/// @nodoc
mixin _$RadarrQuality {

 int? get id; String? get name;
/// Create a copy of RadarrQuality
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrQualityCopyWith<RadarrQuality> get copyWith => _$RadarrQualityCopyWithImpl<RadarrQuality>(this as RadarrQuality, _$identity);

  /// Serializes this RadarrQuality to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrQuality&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RadarrQuality(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $RadarrQualityCopyWith<$Res>  {
  factory $RadarrQualityCopyWith(RadarrQuality value, $Res Function(RadarrQuality) _then) = _$RadarrQualityCopyWithImpl;
@useResult
$Res call({
 int? id, String? name
});




}
/// @nodoc
class _$RadarrQualityCopyWithImpl<$Res>
    implements $RadarrQualityCopyWith<$Res> {
  _$RadarrQualityCopyWithImpl(this._self, this._then);

  final RadarrQuality _self;
  final $Res Function(RadarrQuality) _then;

/// Create a copy of RadarrQuality
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(RadarrQuality(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrQuality].
extension RadarrQualityPatterns on RadarrQuality {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrQuality value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrQuality() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrQuality value)  $default,){
final _that = this;
switch (_that) {
case _RadarrQuality():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrQuality value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrQuality() when $default != null:
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
case _RadarrQuality() when $default != null:
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
case _RadarrQuality():
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
case _RadarrQuality() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrQuality implements RadarrQuality {
  const _RadarrQuality({this.id, this.name});
  factory _RadarrQuality.fromJson(Map<String, dynamic> json) => _$RadarrQualityFromJson(json);

@override final  int? id;
@override final  String? name;

/// Create a copy of RadarrQuality
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrQualityCopyWith<_RadarrQuality> get copyWith => __$RadarrQualityCopyWithImpl<_RadarrQuality>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrQualityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrQuality&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RadarrQuality(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$RadarrQualityCopyWith<$Res> implements $RadarrQualityCopyWith<$Res> {
  factory _$RadarrQualityCopyWith(_RadarrQuality value, $Res Function(_RadarrQuality) _then) = __$RadarrQualityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name
});




}
/// @nodoc
class __$RadarrQualityCopyWithImpl<$Res>
    implements _$RadarrQualityCopyWith<$Res> {
  __$RadarrQualityCopyWithImpl(this._self, this._then);

  final _RadarrQuality _self;
  final $Res Function(_RadarrQuality) _then;

/// Create a copy of RadarrQuality
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_RadarrQuality(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RadarrRatings {

 RadarrRatingValue? get imdb; RadarrRatingValue? get tmdb; RadarrRatingValue? get rottenTomatoes;
/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrRatingsCopyWith<RadarrRatings> get copyWith => _$RadarrRatingsCopyWithImpl<RadarrRatings>(this as RadarrRatings, _$identity);

  /// Serializes this RadarrRatings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrRatings&&(identical(other.imdb, imdb) || other.imdb == imdb)&&(identical(other.tmdb, tmdb) || other.tmdb == tmdb)&&(identical(other.rottenTomatoes, rottenTomatoes) || other.rottenTomatoes == rottenTomatoes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imdb,tmdb,rottenTomatoes);

@override
String toString() {
  return 'RadarrRatings(imdb: $imdb, tmdb: $tmdb, rottenTomatoes: $rottenTomatoes)';
}


}

/// @nodoc
abstract mixin class $RadarrRatingsCopyWith<$Res>  {
  factory $RadarrRatingsCopyWith(RadarrRatings value, $Res Function(RadarrRatings) _then) = _$RadarrRatingsCopyWithImpl;
@useResult
$Res call({
 RadarrRatingValue? imdb, RadarrRatingValue? tmdb, RadarrRatingValue? rottenTomatoes
});


$RadarrRatingValueCopyWith<$Res>? get imdb;$RadarrRatingValueCopyWith<$Res>? get tmdb;$RadarrRatingValueCopyWith<$Res>? get rottenTomatoes;

}
/// @nodoc
class _$RadarrRatingsCopyWithImpl<$Res>
    implements $RadarrRatingsCopyWith<$Res> {
  _$RadarrRatingsCopyWithImpl(this._self, this._then);

  final RadarrRatings _self;
  final $Res Function(RadarrRatings) _then;

/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imdb = freezed,Object? tmdb = freezed,Object? rottenTomatoes = freezed,}) {
  return _then(RadarrRatings(
imdb: freezed == imdb ? _self.imdb : imdb // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,tmdb: freezed == tmdb ? _self.tmdb : tmdb // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,rottenTomatoes: freezed == rottenTomatoes ? _self.rottenTomatoes : rottenTomatoes // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,
  ));
}
/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get imdb {
    if (_self.imdb == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.imdb!, (value) {
    return _then(_self.copyWith(imdb: value));
  });
}/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get tmdb {
    if (_self.tmdb == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.tmdb!, (value) {
    return _then(_self.copyWith(tmdb: value));
  });
}/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get rottenTomatoes {
    if (_self.rottenTomatoes == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.rottenTomatoes!, (value) {
    return _then(_self.copyWith(rottenTomatoes: value));
  });
}
}


/// Adds pattern-matching-related methods to [RadarrRatings].
extension RadarrRatingsPatterns on RadarrRatings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrRatings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrRatings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrRatings value)  $default,){
final _that = this;
switch (_that) {
case _RadarrRatings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrRatings value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrRatings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RadarrRatingValue? imdb,  RadarrRatingValue? tmdb,  RadarrRatingValue? rottenTomatoes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrRatings() when $default != null:
return $default(_that.imdb,_that.tmdb,_that.rottenTomatoes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RadarrRatingValue? imdb,  RadarrRatingValue? tmdb,  RadarrRatingValue? rottenTomatoes)  $default,) {final _that = this;
switch (_that) {
case _RadarrRatings():
return $default(_that.imdb,_that.tmdb,_that.rottenTomatoes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RadarrRatingValue? imdb,  RadarrRatingValue? tmdb,  RadarrRatingValue? rottenTomatoes)?  $default,) {final _that = this;
switch (_that) {
case _RadarrRatings() when $default != null:
return $default(_that.imdb,_that.tmdb,_that.rottenTomatoes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrRatings implements RadarrRatings {
  const _RadarrRatings({this.imdb, this.tmdb, this.rottenTomatoes});
  factory _RadarrRatings.fromJson(Map<String, dynamic> json) => _$RadarrRatingsFromJson(json);

@override final  RadarrRatingValue? imdb;
@override final  RadarrRatingValue? tmdb;
@override final  RadarrRatingValue? rottenTomatoes;

/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrRatingsCopyWith<_RadarrRatings> get copyWith => __$RadarrRatingsCopyWithImpl<_RadarrRatings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrRatingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrRatings&&(identical(other.imdb, imdb) || other.imdb == imdb)&&(identical(other.tmdb, tmdb) || other.tmdb == tmdb)&&(identical(other.rottenTomatoes, rottenTomatoes) || other.rottenTomatoes == rottenTomatoes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imdb,tmdb,rottenTomatoes);

@override
String toString() {
  return 'RadarrRatings(imdb: $imdb, tmdb: $tmdb, rottenTomatoes: $rottenTomatoes)';
}


}

/// @nodoc
abstract mixin class _$RadarrRatingsCopyWith<$Res> implements $RadarrRatingsCopyWith<$Res> {
  factory _$RadarrRatingsCopyWith(_RadarrRatings value, $Res Function(_RadarrRatings) _then) = __$RadarrRatingsCopyWithImpl;
@override @useResult
$Res call({
 RadarrRatingValue? imdb, RadarrRatingValue? tmdb, RadarrRatingValue? rottenTomatoes
});


@override $RadarrRatingValueCopyWith<$Res>? get imdb;@override $RadarrRatingValueCopyWith<$Res>? get tmdb;@override $RadarrRatingValueCopyWith<$Res>? get rottenTomatoes;

}
/// @nodoc
class __$RadarrRatingsCopyWithImpl<$Res>
    implements _$RadarrRatingsCopyWith<$Res> {
  __$RadarrRatingsCopyWithImpl(this._self, this._then);

  final _RadarrRatings _self;
  final $Res Function(_RadarrRatings) _then;

/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imdb = freezed,Object? tmdb = freezed,Object? rottenTomatoes = freezed,}) {
  return _then(_RadarrRatings(
imdb: freezed == imdb ? _self.imdb : imdb // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,tmdb: freezed == tmdb ? _self.tmdb : tmdb // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,rottenTomatoes: freezed == rottenTomatoes ? _self.rottenTomatoes : rottenTomatoes // ignore: cast_nullable_to_non_nullable
as RadarrRatingValue?,
  ));
}

/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get imdb {
    if (_self.imdb == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.imdb!, (value) {
    return _then(_self.copyWith(imdb: value));
  });
}/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get tmdb {
    if (_self.tmdb == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.tmdb!, (value) {
    return _then(_self.copyWith(tmdb: value));
  });
}/// Create a copy of RadarrRatings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<$Res>? get rottenTomatoes {
    if (_self.rottenTomatoes == null) {
    return null;
  }

  return $RadarrRatingValueCopyWith<$Res>(_self.rottenTomatoes!, (value) {
    return _then(_self.copyWith(rottenTomatoes: value));
  });
}
}


/// @nodoc
mixin _$RadarrRatingValue {

 int get votes; double get value;
/// Create a copy of RadarrRatingValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrRatingValueCopyWith<RadarrRatingValue> get copyWith => _$RadarrRatingValueCopyWithImpl<RadarrRatingValue>(this as RadarrRatingValue, _$identity);

  /// Serializes this RadarrRatingValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrRatingValue&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,votes,value);

@override
String toString() {
  return 'RadarrRatingValue(votes: $votes, value: $value)';
}


}

/// @nodoc
abstract mixin class $RadarrRatingValueCopyWith<$Res>  {
  factory $RadarrRatingValueCopyWith(RadarrRatingValue value, $Res Function(RadarrRatingValue) _then) = _$RadarrRatingValueCopyWithImpl;
@useResult
$Res call({
 int votes, double value
});




}
/// @nodoc
class _$RadarrRatingValueCopyWithImpl<$Res>
    implements $RadarrRatingValueCopyWith<$Res> {
  _$RadarrRatingValueCopyWithImpl(this._self, this._then);

  final RadarrRatingValue _self;
  final $Res Function(RadarrRatingValue) _then;

/// Create a copy of RadarrRatingValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? votes = null,Object? value = null,}) {
  return _then(RadarrRatingValue(
votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrRatingValue].
extension RadarrRatingValuePatterns on RadarrRatingValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrRatingValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrRatingValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrRatingValue value)  $default,){
final _that = this;
switch (_that) {
case _RadarrRatingValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrRatingValue value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrRatingValue() when $default != null:
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
case _RadarrRatingValue() when $default != null:
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
case _RadarrRatingValue():
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
case _RadarrRatingValue() when $default != null:
return $default(_that.votes,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrRatingValue implements RadarrRatingValue {
  const _RadarrRatingValue({this.votes = 0, this.value = 0});
  factory _RadarrRatingValue.fromJson(Map<String, dynamic> json) => _$RadarrRatingValueFromJson(json);

@override@JsonKey() final  int votes;
@override@JsonKey() final  double value;

/// Create a copy of RadarrRatingValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrRatingValueCopyWith<_RadarrRatingValue> get copyWith => __$RadarrRatingValueCopyWithImpl<_RadarrRatingValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrRatingValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrRatingValue&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,votes,value);

@override
String toString() {
  return 'RadarrRatingValue(votes: $votes, value: $value)';
}


}

/// @nodoc
abstract mixin class _$RadarrRatingValueCopyWith<$Res> implements $RadarrRatingValueCopyWith<$Res> {
  factory _$RadarrRatingValueCopyWith(_RadarrRatingValue value, $Res Function(_RadarrRatingValue) _then) = __$RadarrRatingValueCopyWithImpl;
@override @useResult
$Res call({
 int votes, double value
});




}
/// @nodoc
class __$RadarrRatingValueCopyWithImpl<$Res>
    implements _$RadarrRatingValueCopyWith<$Res> {
  __$RadarrRatingValueCopyWithImpl(this._self, this._then);

  final _RadarrRatingValue _self;
  final $Res Function(_RadarrRatingValue) _then;

/// Create a copy of RadarrRatingValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? votes = null,Object? value = null,}) {
  return _then(_RadarrRatingValue(
votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$RadarrQualityProfile {

 int get id; String? get name;
/// Create a copy of RadarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrQualityProfileCopyWith<RadarrQualityProfile> get copyWith => _$RadarrQualityProfileCopyWithImpl<RadarrQualityProfile>(this as RadarrQualityProfile, _$identity);

  /// Serializes this RadarrQualityProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrQualityProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RadarrQualityProfile(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $RadarrQualityProfileCopyWith<$Res>  {
  factory $RadarrQualityProfileCopyWith(RadarrQualityProfile value, $Res Function(RadarrQualityProfile) _then) = _$RadarrQualityProfileCopyWithImpl;
@useResult
$Res call({
 int id, String? name
});




}
/// @nodoc
class _$RadarrQualityProfileCopyWithImpl<$Res>
    implements $RadarrQualityProfileCopyWith<$Res> {
  _$RadarrQualityProfileCopyWithImpl(this._self, this._then);

  final RadarrQualityProfile _self;
  final $Res Function(RadarrQualityProfile) _then;

/// Create a copy of RadarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(RadarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrQualityProfile].
extension RadarrQualityProfilePatterns on RadarrQualityProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrQualityProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrQualityProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrQualityProfile value)  $default,){
final _that = this;
switch (_that) {
case _RadarrQualityProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrQualityProfile value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrQualityProfile() when $default != null:
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
case _RadarrQualityProfile() when $default != null:
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
case _RadarrQualityProfile():
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
case _RadarrQualityProfile() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrQualityProfile implements RadarrQualityProfile {
  const _RadarrQualityProfile({required this.id, this.name});
  factory _RadarrQualityProfile.fromJson(Map<String, dynamic> json) => _$RadarrQualityProfileFromJson(json);

@override final  int id;
@override final  String? name;

/// Create a copy of RadarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrQualityProfileCopyWith<_RadarrQualityProfile> get copyWith => __$RadarrQualityProfileCopyWithImpl<_RadarrQualityProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrQualityProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrQualityProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RadarrQualityProfile(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$RadarrQualityProfileCopyWith<$Res> implements $RadarrQualityProfileCopyWith<$Res> {
  factory _$RadarrQualityProfileCopyWith(_RadarrQualityProfile value, $Res Function(_RadarrQualityProfile) _then) = __$RadarrQualityProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String? name
});




}
/// @nodoc
class __$RadarrQualityProfileCopyWithImpl<$Res>
    implements _$RadarrQualityProfileCopyWith<$Res> {
  __$RadarrQualityProfileCopyWithImpl(this._self, this._then);

  final _RadarrQualityProfile _self;
  final $Res Function(_RadarrQualityProfile) _then;

/// Create a copy of RadarrQualityProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,}) {
  return _then(_RadarrQualityProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RadarrRootFolder {

 int get id; String? get path; int? get freeSpace;
/// Create a copy of RadarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrRootFolderCopyWith<RadarrRootFolder> get copyWith => _$RadarrRootFolderCopyWithImpl<RadarrRootFolder>(this as RadarrRootFolder, _$identity);

  /// Serializes this RadarrRootFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrRootFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.freeSpace, freeSpace) || other.freeSpace == freeSpace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,freeSpace);

@override
String toString() {
  return 'RadarrRootFolder(id: $id, path: $path, freeSpace: $freeSpace)';
}


}

/// @nodoc
abstract mixin class $RadarrRootFolderCopyWith<$Res>  {
  factory $RadarrRootFolderCopyWith(RadarrRootFolder value, $Res Function(RadarrRootFolder) _then) = _$RadarrRootFolderCopyWithImpl;
@useResult
$Res call({
 int id, String? path, int? freeSpace
});




}
/// @nodoc
class _$RadarrRootFolderCopyWithImpl<$Res>
    implements $RadarrRootFolderCopyWith<$Res> {
  _$RadarrRootFolderCopyWithImpl(this._self, this._then);

  final RadarrRootFolder _self;
  final $Res Function(RadarrRootFolder) _then;

/// Create a copy of RadarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = freezed,Object? freeSpace = freezed,}) {
  return _then(RadarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,freeSpace: freezed == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadarrRootFolder].
extension RadarrRootFolderPatterns on RadarrRootFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrRootFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrRootFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrRootFolder value)  $default,){
final _that = this;
switch (_that) {
case _RadarrRootFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrRootFolder value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrRootFolder() when $default != null:
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
case _RadarrRootFolder() when $default != null:
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
case _RadarrRootFolder():
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
case _RadarrRootFolder() when $default != null:
return $default(_that.id,_that.path,_that.freeSpace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrRootFolder implements RadarrRootFolder {
  const _RadarrRootFolder({required this.id, this.path, this.freeSpace});
  factory _RadarrRootFolder.fromJson(Map<String, dynamic> json) => _$RadarrRootFolderFromJson(json);

@override final  int id;
@override final  String? path;
@override final  int? freeSpace;

/// Create a copy of RadarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrRootFolderCopyWith<_RadarrRootFolder> get copyWith => __$RadarrRootFolderCopyWithImpl<_RadarrRootFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrRootFolderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrRootFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.freeSpace, freeSpace) || other.freeSpace == freeSpace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,freeSpace);

@override
String toString() {
  return 'RadarrRootFolder(id: $id, path: $path, freeSpace: $freeSpace)';
}


}

/// @nodoc
abstract mixin class _$RadarrRootFolderCopyWith<$Res> implements $RadarrRootFolderCopyWith<$Res> {
  factory _$RadarrRootFolderCopyWith(_RadarrRootFolder value, $Res Function(_RadarrRootFolder) _then) = __$RadarrRootFolderCopyWithImpl;
@override @useResult
$Res call({
 int id, String? path, int? freeSpace
});




}
/// @nodoc
class __$RadarrRootFolderCopyWithImpl<$Res>
    implements _$RadarrRootFolderCopyWith<$Res> {
  __$RadarrRootFolderCopyWithImpl(this._self, this._then);

  final _RadarrRootFolder _self;
  final $Res Function(_RadarrRootFolder) _then;

/// Create a copy of RadarrRootFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = freezed,Object? freeSpace = freezed,}) {
  return _then(_RadarrRootFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,freeSpace: freezed == freeSpace ? _self.freeSpace : freeSpace // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RadarrQueueItem {

 int get id; int? get movieId; String? get status; int get size; int get sizeleft; String? get title; String? get timeleft; DateTime? get estimatedCompletionTime;
/// Create a copy of RadarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadarrQueueItemCopyWith<RadarrQueueItem> get copyWith => _$RadarrQueueItemCopyWithImpl<RadarrQueueItem>(this as RadarrQueueItem, _$identity);

  /// Serializes this RadarrQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadarrQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.movieId, movieId) || other.movieId == movieId)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeleft, sizeleft) || other.sizeleft == sizeleft)&&(identical(other.title, title) || other.title == title)&&(identical(other.timeleft, timeleft) || other.timeleft == timeleft)&&(identical(other.estimatedCompletionTime, estimatedCompletionTime) || other.estimatedCompletionTime == estimatedCompletionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movieId,status,size,sizeleft,title,timeleft,estimatedCompletionTime);

@override
String toString() {
  return 'RadarrQueueItem(id: $id, movieId: $movieId, status: $status, size: $size, sizeleft: $sizeleft, title: $title, timeleft: $timeleft, estimatedCompletionTime: $estimatedCompletionTime)';
}


}

/// @nodoc
abstract mixin class $RadarrQueueItemCopyWith<$Res>  {
  factory $RadarrQueueItemCopyWith(RadarrQueueItem value, $Res Function(RadarrQueueItem) _then) = _$RadarrQueueItemCopyWithImpl;
@useResult
$Res call({
 int id, int? movieId, String? status, int size, int sizeleft, String? title, String? timeleft, DateTime? estimatedCompletionTime
});




}
/// @nodoc
class _$RadarrQueueItemCopyWithImpl<$Res>
    implements $RadarrQueueItemCopyWith<$Res> {
  _$RadarrQueueItemCopyWithImpl(this._self, this._then);

  final RadarrQueueItem _self;
  final $Res Function(RadarrQueueItem) _then;

/// Create a copy of RadarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? movieId = freezed,Object? status = freezed,Object? size = null,Object? sizeleft = null,Object? title = freezed,Object? timeleft = freezed,Object? estimatedCompletionTime = freezed,}) {
  return _then(RadarrQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,movieId: freezed == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [RadarrQueueItem].
extension RadarrQueueItemPatterns on RadarrQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadarrQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadarrQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadarrQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _RadarrQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadarrQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _RadarrQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? movieId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadarrQueueItem() when $default != null:
return $default(_that.id,_that.movieId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? movieId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)  $default,) {final _that = this;
switch (_that) {
case _RadarrQueueItem():
return $default(_that.id,_that.movieId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? movieId,  String? status,  int size,  int sizeleft,  String? title,  String? timeleft,  DateTime? estimatedCompletionTime)?  $default,) {final _that = this;
switch (_that) {
case _RadarrQueueItem() when $default != null:
return $default(_that.id,_that.movieId,_that.status,_that.size,_that.sizeleft,_that.title,_that.timeleft,_that.estimatedCompletionTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadarrQueueItem implements RadarrQueueItem {
  const _RadarrQueueItem({required this.id, this.movieId, this.status, this.size = 0, this.sizeleft = 0, this.title, this.timeleft, this.estimatedCompletionTime});
  factory _RadarrQueueItem.fromJson(Map<String, dynamic> json) => _$RadarrQueueItemFromJson(json);

@override final  int id;
@override final  int? movieId;
@override final  String? status;
@override@JsonKey() final  int size;
@override@JsonKey() final  int sizeleft;
@override final  String? title;
@override final  String? timeleft;
@override final  DateTime? estimatedCompletionTime;

/// Create a copy of RadarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadarrQueueItemCopyWith<_RadarrQueueItem> get copyWith => __$RadarrQueueItemCopyWithImpl<_RadarrQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadarrQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadarrQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.movieId, movieId) || other.movieId == movieId)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeleft, sizeleft) || other.sizeleft == sizeleft)&&(identical(other.title, title) || other.title == title)&&(identical(other.timeleft, timeleft) || other.timeleft == timeleft)&&(identical(other.estimatedCompletionTime, estimatedCompletionTime) || other.estimatedCompletionTime == estimatedCompletionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movieId,status,size,sizeleft,title,timeleft,estimatedCompletionTime);

@override
String toString() {
  return 'RadarrQueueItem(id: $id, movieId: $movieId, status: $status, size: $size, sizeleft: $sizeleft, title: $title, timeleft: $timeleft, estimatedCompletionTime: $estimatedCompletionTime)';
}


}

/// @nodoc
abstract mixin class _$RadarrQueueItemCopyWith<$Res> implements $RadarrQueueItemCopyWith<$Res> {
  factory _$RadarrQueueItemCopyWith(_RadarrQueueItem value, $Res Function(_RadarrQueueItem) _then) = __$RadarrQueueItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int? movieId, String? status, int size, int sizeleft, String? title, String? timeleft, DateTime? estimatedCompletionTime
});




}
/// @nodoc
class __$RadarrQueueItemCopyWithImpl<$Res>
    implements _$RadarrQueueItemCopyWith<$Res> {
  __$RadarrQueueItemCopyWithImpl(this._self, this._then);

  final _RadarrQueueItem _self;
  final $Res Function(_RadarrQueueItem) _then;

/// Create a copy of RadarrQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? movieId = freezed,Object? status = freezed,Object? size = null,Object? sizeleft = null,Object? title = freezed,Object? timeleft = freezed,Object? estimatedCompletionTime = freezed,}) {
  return _then(_RadarrQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,movieId: freezed == movieId ? _self.movieId : movieId // ignore: cast_nullable_to_non_nullable
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
