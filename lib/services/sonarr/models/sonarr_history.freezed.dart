// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sonarr_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SonarrHistoryRecord {

 int get id; int? get seriesId; int? get episodeId;/// Raw Sonarr event type, e.g. `grabbed`, `downloadFolderImported`,
/// `downloadFailed`, `episodeFileDeleted`, `episodeFileRenamed`,
/// `downloadIgnored`.
 String get eventType;/// When the event happened (UTC as sent by Sonarr).
 DateTime get date;/// The release name the event concerns.
 String? get sourceTitle; String? get downloadId;@JsonKey(fromJson: _qualityFromJson) SonarrQualityInfo? get quality;/// The series, present when requested with `includeSeries=true`.
@JsonKey(fromJson: _seriesFromJson) SonarrHistorySeries? get series;/// The episode, present when requested with `includeEpisode=true`.
@JsonKey(fromJson: _episodeFromJson) SonarrHistoryEpisode? get episode;
/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrHistoryRecordCopyWith<SonarrHistoryRecord> get copyWith => _$SonarrHistoryRecordCopyWithImpl<SonarrHistoryRecord>(this as SonarrHistoryRecord, _$identity);

  /// Serializes this SonarrHistoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrHistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.date, date) || other.date == date)&&(identical(other.sourceTitle, sourceTitle) || other.sourceTitle == sourceTitle)&&(identical(other.downloadId, downloadId) || other.downloadId == downloadId)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.series, series) || other.series == series)&&(identical(other.episode, episode) || other.episode == episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeId,eventType,date,sourceTitle,downloadId,quality,series,episode);

@override
String toString() {
  return 'SonarrHistoryRecord(id: $id, seriesId: $seriesId, episodeId: $episodeId, eventType: $eventType, date: $date, sourceTitle: $sourceTitle, downloadId: $downloadId, quality: $quality, series: $series, episode: $episode)';
}


}

/// @nodoc
abstract mixin class $SonarrHistoryRecordCopyWith<$Res>  {
  factory $SonarrHistoryRecordCopyWith(SonarrHistoryRecord value, $Res Function(SonarrHistoryRecord) _then) = _$SonarrHistoryRecordCopyWithImpl;
@useResult
$Res call({
 int id, int? seriesId, int? episodeId, String eventType, DateTime date, String? sourceTitle, String? downloadId,@JsonKey(fromJson: _qualityFromJson) SonarrQualityInfo? quality,@JsonKey(fromJson: _seriesFromJson) SonarrHistorySeries? series,@JsonKey(fromJson: _episodeFromJson) SonarrHistoryEpisode? episode
});


$SonarrQualityInfoCopyWith<$Res>? get quality;$SonarrHistorySeriesCopyWith<$Res>? get series;$SonarrHistoryEpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class _$SonarrHistoryRecordCopyWithImpl<$Res>
    implements $SonarrHistoryRecordCopyWith<$Res> {
  _$SonarrHistoryRecordCopyWithImpl(this._self, this._then);

  final SonarrHistoryRecord _self;
  final $Res Function(SonarrHistoryRecord) _then;

/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = freezed,Object? episodeId = freezed,Object? eventType = null,Object? date = null,Object? sourceTitle = freezed,Object? downloadId = freezed,Object? quality = freezed,Object? series = freezed,Object? episode = freezed,}) {
  return _then(SonarrHistoryRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sourceTitle: freezed == sourceTitle ? _self.sourceTitle : sourceTitle // ignore: cast_nullable_to_non_nullable
as String?,downloadId: freezed == downloadId ? _self.downloadId : downloadId // ignore: cast_nullable_to_non_nullable
as String?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQualityInfo?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as SonarrHistorySeries?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as SonarrHistoryEpisode?,
  ));
}
/// Create a copy of SonarrHistoryRecord
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
}/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrHistorySeriesCopyWith<$Res>? get series {
    if (_self.series == null) {
    return null;
  }

  return $SonarrHistorySeriesCopyWith<$Res>(_self.series!, (value) {
    return _then(_self.copyWith(series: value));
  });
}/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrHistoryEpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $SonarrHistoryEpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonarrHistoryRecord].
extension SonarrHistoryRecordPatterns on SonarrHistoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrHistoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrHistoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrHistoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _SonarrHistoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrHistoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrHistoryRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? episodeId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  SonarrQualityInfo? quality, @JsonKey(fromJson: _seriesFromJson)  SonarrHistorySeries? series, @JsonKey(fromJson: _episodeFromJson)  SonarrHistoryEpisode? episode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrHistoryRecord() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.series,_that.episode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? seriesId,  int? episodeId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  SonarrQualityInfo? quality, @JsonKey(fromJson: _seriesFromJson)  SonarrHistorySeries? series, @JsonKey(fromJson: _episodeFromJson)  SonarrHistoryEpisode? episode)  $default,) {final _that = this;
switch (_that) {
case _SonarrHistoryRecord():
return $default(_that.id,_that.seriesId,_that.episodeId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.series,_that.episode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? seriesId,  int? episodeId,  String eventType,  DateTime date,  String? sourceTitle,  String? downloadId, @JsonKey(fromJson: _qualityFromJson)  SonarrQualityInfo? quality, @JsonKey(fromJson: _seriesFromJson)  SonarrHistorySeries? series, @JsonKey(fromJson: _episodeFromJson)  SonarrHistoryEpisode? episode)?  $default,) {final _that = this;
switch (_that) {
case _SonarrHistoryRecord() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeId,_that.eventType,_that.date,_that.sourceTitle,_that.downloadId,_that.quality,_that.series,_that.episode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrHistoryRecord implements SonarrHistoryRecord {
  const _SonarrHistoryRecord({this.id = 0, this.seriesId, this.episodeId, this.eventType = 'unknown', required this.date, this.sourceTitle, this.downloadId, @JsonKey(fromJson: _qualityFromJson) this.quality, @JsonKey(fromJson: _seriesFromJson) this.series, @JsonKey(fromJson: _episodeFromJson) this.episode});
  factory _SonarrHistoryRecord.fromJson(Map<String, dynamic> json) => _$SonarrHistoryRecordFromJson(json);

@override@JsonKey() final  int id;
@override final  int? seriesId;
@override final  int? episodeId;
/// Raw Sonarr event type, e.g. `grabbed`, `downloadFolderImported`,
/// `downloadFailed`, `episodeFileDeleted`, `episodeFileRenamed`,
/// `downloadIgnored`.
@override@JsonKey() final  String eventType;
/// When the event happened (UTC as sent by Sonarr).
@override final  DateTime date;
/// The release name the event concerns.
@override final  String? sourceTitle;
@override final  String? downloadId;
@override@JsonKey(fromJson: _qualityFromJson) final  SonarrQualityInfo? quality;
/// The series, present when requested with `includeSeries=true`.
@override@JsonKey(fromJson: _seriesFromJson) final  SonarrHistorySeries? series;
/// The episode, present when requested with `includeEpisode=true`.
@override@JsonKey(fromJson: _episodeFromJson) final  SonarrHistoryEpisode? episode;

/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrHistoryRecordCopyWith<_SonarrHistoryRecord> get copyWith => __$SonarrHistoryRecordCopyWithImpl<_SonarrHistoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrHistoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrHistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.date, date) || other.date == date)&&(identical(other.sourceTitle, sourceTitle) || other.sourceTitle == sourceTitle)&&(identical(other.downloadId, downloadId) || other.downloadId == downloadId)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.series, series) || other.series == series)&&(identical(other.episode, episode) || other.episode == episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeId,eventType,date,sourceTitle,downloadId,quality,series,episode);

@override
String toString() {
  return 'SonarrHistoryRecord(id: $id, seriesId: $seriesId, episodeId: $episodeId, eventType: $eventType, date: $date, sourceTitle: $sourceTitle, downloadId: $downloadId, quality: $quality, series: $series, episode: $episode)';
}


}

/// @nodoc
abstract mixin class _$SonarrHistoryRecordCopyWith<$Res> implements $SonarrHistoryRecordCopyWith<$Res> {
  factory _$SonarrHistoryRecordCopyWith(_SonarrHistoryRecord value, $Res Function(_SonarrHistoryRecord) _then) = __$SonarrHistoryRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, int? seriesId, int? episodeId, String eventType, DateTime date, String? sourceTitle, String? downloadId,@JsonKey(fromJson: _qualityFromJson) SonarrQualityInfo? quality,@JsonKey(fromJson: _seriesFromJson) SonarrHistorySeries? series,@JsonKey(fromJson: _episodeFromJson) SonarrHistoryEpisode? episode
});


@override $SonarrQualityInfoCopyWith<$Res>? get quality;@override $SonarrHistorySeriesCopyWith<$Res>? get series;@override $SonarrHistoryEpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class __$SonarrHistoryRecordCopyWithImpl<$Res>
    implements _$SonarrHistoryRecordCopyWith<$Res> {
  __$SonarrHistoryRecordCopyWithImpl(this._self, this._then);

  final _SonarrHistoryRecord _self;
  final $Res Function(_SonarrHistoryRecord) _then;

/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = freezed,Object? episodeId = freezed,Object? eventType = null,Object? date = null,Object? sourceTitle = freezed,Object? downloadId = freezed,Object? quality = freezed,Object? series = freezed,Object? episode = freezed,}) {
  return _then(_SonarrHistoryRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sourceTitle: freezed == sourceTitle ? _self.sourceTitle : sourceTitle // ignore: cast_nullable_to_non_nullable
as String?,downloadId: freezed == downloadId ? _self.downloadId : downloadId // ignore: cast_nullable_to_non_nullable
as String?,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SonarrQualityInfo?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as SonarrHistorySeries?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as SonarrHistoryEpisode?,
  ));
}

/// Create a copy of SonarrHistoryRecord
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
}/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrHistorySeriesCopyWith<$Res>? get series {
    if (_self.series == null) {
    return null;
  }

  return $SonarrHistorySeriesCopyWith<$Res>(_self.series!, (value) {
    return _then(_self.copyWith(series: value));
  });
}/// Create a copy of SonarrHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SonarrHistoryEpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $SonarrHistoryEpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// @nodoc
mixin _$SonarrHistorySeries {

 int? get id; String? get title; int? get year;@JsonKey(fromJson: _imagesFromJson) List<SonarrImage>? get images;
/// Create a copy of SonarrHistorySeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrHistorySeriesCopyWith<SonarrHistorySeries> get copyWith => _$SonarrHistorySeriesCopyWithImpl<SonarrHistorySeries>(this as SonarrHistorySeries, _$identity);

  /// Serializes this SonarrHistorySeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrHistorySeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'SonarrHistorySeries(id: $id, title: $title, year: $year, images: $images)';
}


}

/// @nodoc
abstract mixin class $SonarrHistorySeriesCopyWith<$Res>  {
  factory $SonarrHistorySeriesCopyWith(SonarrHistorySeries value, $Res Function(SonarrHistorySeries) _then) = _$SonarrHistorySeriesCopyWithImpl;
@useResult
$Res call({
 int? id, String? title, int? year,@JsonKey(fromJson: _imagesFromJson) List<SonarrImage>? images
});




}
/// @nodoc
class _$SonarrHistorySeriesCopyWithImpl<$Res>
    implements $SonarrHistorySeriesCopyWith<$Res> {
  _$SonarrHistorySeriesCopyWithImpl(this._self, this._then);

  final SonarrHistorySeries _self;
  final $Res Function(SonarrHistorySeries) _then;

/// Create a copy of SonarrHistorySeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? year = freezed,Object? images = freezed,}) {
  return _then(SonarrHistorySeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrHistorySeries].
extension SonarrHistorySeriesPatterns on SonarrHistorySeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrHistorySeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrHistorySeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrHistorySeries value)  $default,){
final _that = this;
switch (_that) {
case _SonarrHistorySeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrHistorySeries value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrHistorySeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<SonarrImage>? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrHistorySeries() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<SonarrImage>? images)  $default,) {final _that = this;
switch (_that) {
case _SonarrHistorySeries():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? title,  int? year, @JsonKey(fromJson: _imagesFromJson)  List<SonarrImage>? images)?  $default,) {final _that = this;
switch (_that) {
case _SonarrHistorySeries() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrHistorySeries implements SonarrHistorySeries {
  const _SonarrHistorySeries({this.id, this.title, this.year, @JsonKey(fromJson: _imagesFromJson)  List<SonarrImage>? images}): _images = images;
  factory _SonarrHistorySeries.fromJson(Map<String, dynamic> json) => _$SonarrHistorySeriesFromJson(json);

@override final  int? id;
@override final  String? title;
@override final  int? year;
 final  List<SonarrImage>? _images;
@override@JsonKey(fromJson: _imagesFromJson) List<SonarrImage>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SonarrHistorySeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrHistorySeriesCopyWith<_SonarrHistorySeries> get copyWith => __$SonarrHistorySeriesCopyWithImpl<_SonarrHistorySeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrHistorySeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrHistorySeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'SonarrHistorySeries(id: $id, title: $title, year: $year, images: $images)';
}


}

/// @nodoc
abstract mixin class _$SonarrHistorySeriesCopyWith<$Res> implements $SonarrHistorySeriesCopyWith<$Res> {
  factory _$SonarrHistorySeriesCopyWith(_SonarrHistorySeries value, $Res Function(_SonarrHistorySeries) _then) = __$SonarrHistorySeriesCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? title, int? year,@JsonKey(fromJson: _imagesFromJson) List<SonarrImage>? images
});




}
/// @nodoc
class __$SonarrHistorySeriesCopyWithImpl<$Res>
    implements _$SonarrHistorySeriesCopyWith<$Res> {
  __$SonarrHistorySeriesCopyWithImpl(this._self, this._then);

  final _SonarrHistorySeries _self;
  final $Res Function(_SonarrHistorySeries) _then;

/// Create a copy of SonarrHistorySeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? year = freezed,Object? images = freezed,}) {
  return _then(_SonarrHistorySeries(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<SonarrImage>?,
  ));
}


}


/// @nodoc
mixin _$SonarrHistoryEpisode {

 int? get id; int? get seasonNumber; int? get episodeNumber; String? get title;
/// Create a copy of SonarrHistoryEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonarrHistoryEpisodeCopyWith<SonarrHistoryEpisode> get copyWith => _$SonarrHistoryEpisodeCopyWithImpl<SonarrHistoryEpisode>(this as SonarrHistoryEpisode, _$identity);

  /// Serializes this SonarrHistoryEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonarrHistoryEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,episodeNumber,title);

@override
String toString() {
  return 'SonarrHistoryEpisode(id: $id, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title)';
}


}

/// @nodoc
abstract mixin class $SonarrHistoryEpisodeCopyWith<$Res>  {
  factory $SonarrHistoryEpisodeCopyWith(SonarrHistoryEpisode value, $Res Function(SonarrHistoryEpisode) _then) = _$SonarrHistoryEpisodeCopyWithImpl;
@useResult
$Res call({
 int? id, int? seasonNumber, int? episodeNumber, String? title
});




}
/// @nodoc
class _$SonarrHistoryEpisodeCopyWithImpl<$Res>
    implements $SonarrHistoryEpisodeCopyWith<$Res> {
  _$SonarrHistoryEpisodeCopyWithImpl(this._self, this._then);

  final SonarrHistoryEpisode _self;
  final $Res Function(SonarrHistoryEpisode) _then;

/// Create a copy of SonarrHistoryEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,}) {
  return _then(SonarrHistoryEpisode(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SonarrHistoryEpisode].
extension SonarrHistoryEpisodePatterns on SonarrHistoryEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonarrHistoryEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonarrHistoryEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonarrHistoryEpisode value)  $default,){
final _that = this;
switch (_that) {
case _SonarrHistoryEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonarrHistoryEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _SonarrHistoryEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? seasonNumber,  int? episodeNumber,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonarrHistoryEpisode() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.episodeNumber,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? seasonNumber,  int? episodeNumber,  String? title)  $default,) {final _that = this;
switch (_that) {
case _SonarrHistoryEpisode():
return $default(_that.id,_that.seasonNumber,_that.episodeNumber,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? seasonNumber,  int? episodeNumber,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _SonarrHistoryEpisode() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.episodeNumber,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonarrHistoryEpisode implements SonarrHistoryEpisode {
  const _SonarrHistoryEpisode({this.id, this.seasonNumber, this.episodeNumber, this.title});
  factory _SonarrHistoryEpisode.fromJson(Map<String, dynamic> json) => _$SonarrHistoryEpisodeFromJson(json);

@override final  int? id;
@override final  int? seasonNumber;
@override final  int? episodeNumber;
@override final  String? title;

/// Create a copy of SonarrHistoryEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonarrHistoryEpisodeCopyWith<_SonarrHistoryEpisode> get copyWith => __$SonarrHistoryEpisodeCopyWithImpl<_SonarrHistoryEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonarrHistoryEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonarrHistoryEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,episodeNumber,title);

@override
String toString() {
  return 'SonarrHistoryEpisode(id: $id, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, title: $title)';
}


}

/// @nodoc
abstract mixin class _$SonarrHistoryEpisodeCopyWith<$Res> implements $SonarrHistoryEpisodeCopyWith<$Res> {
  factory _$SonarrHistoryEpisodeCopyWith(_SonarrHistoryEpisode value, $Res Function(_SonarrHistoryEpisode) _then) = __$SonarrHistoryEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? seasonNumber, int? episodeNumber, String? title
});




}
/// @nodoc
class __$SonarrHistoryEpisodeCopyWithImpl<$Res>
    implements _$SonarrHistoryEpisodeCopyWith<$Res> {
  __$SonarrHistoryEpisodeCopyWithImpl(this._self, this._then);

  final _SonarrHistoryEpisode _self;
  final $Res Function(_SonarrHistoryEpisode) _then;

/// Create a copy of SonarrHistoryEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? title = freezed,}) {
  return _then(_SonarrHistoryEpisode(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
