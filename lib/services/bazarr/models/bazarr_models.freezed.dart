// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bazarr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BazarrWantedSubtitle {

 String get title; String get type; String? get seriesTitle; int? get seasonNumber; int? get episodeNumber; List<String> get languages; String get path;@JsonKey(name: 'radarrId') int? get radarrId;@JsonKey(name: 'sonarrId') int? get sonarrId;@JsonKey(name: 'episode_id') int? get episodeId;
/// Create a copy of BazarrWantedSubtitle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BazarrWantedSubtitleCopyWith<BazarrWantedSubtitle> get copyWith => _$BazarrWantedSubtitleCopyWithImpl<BazarrWantedSubtitle>(this as BazarrWantedSubtitle, _$identity);

  /// Serializes this BazarrWantedSubtitle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BazarrWantedSubtitle&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.path, path) || other.path == path)&&(identical(other.radarrId, radarrId) || other.radarrId == radarrId)&&(identical(other.sonarrId, sonarrId) || other.sonarrId == sonarrId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,type,seriesTitle,seasonNumber,episodeNumber,const DeepCollectionEquality().hash(languages),path,radarrId,sonarrId,episodeId);

@override
String toString() {
  return 'BazarrWantedSubtitle(title: $title, type: $type, seriesTitle: $seriesTitle, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, languages: $languages, path: $path, radarrId: $radarrId, sonarrId: $sonarrId, episodeId: $episodeId)';
}


}

/// @nodoc
abstract mixin class $BazarrWantedSubtitleCopyWith<$Res>  {
  factory $BazarrWantedSubtitleCopyWith(BazarrWantedSubtitle value, $Res Function(BazarrWantedSubtitle) _then) = _$BazarrWantedSubtitleCopyWithImpl;
@useResult
$Res call({
 String title, String type, String? seriesTitle, int? seasonNumber, int? episodeNumber, List<String> languages, String path,@JsonKey(name: 'radarrId') int? radarrId,@JsonKey(name: 'sonarrId') int? sonarrId,@JsonKey(name: 'episode_id') int? episodeId
});




}
/// @nodoc
class _$BazarrWantedSubtitleCopyWithImpl<$Res>
    implements $BazarrWantedSubtitleCopyWith<$Res> {
  _$BazarrWantedSubtitleCopyWithImpl(this._self, this._then);

  final BazarrWantedSubtitle _self;
  final $Res Function(BazarrWantedSubtitle) _then;

/// Create a copy of BazarrWantedSubtitle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? type = null,Object? seriesTitle = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? languages = null,Object? path = null,Object? radarrId = freezed,Object? sonarrId = freezed,Object? episodeId = freezed,}) {
  return _then(BazarrWantedSubtitle(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,radarrId: freezed == radarrId ? _self.radarrId : radarrId // ignore: cast_nullable_to_non_nullable
as int?,sonarrId: freezed == sonarrId ? _self.sonarrId : sonarrId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BazarrWantedSubtitle].
extension BazarrWantedSubtitlePatterns on BazarrWantedSubtitle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BazarrWantedSubtitle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BazarrWantedSubtitle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BazarrWantedSubtitle value)  $default,){
final _that = this;
switch (_that) {
case _BazarrWantedSubtitle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BazarrWantedSubtitle value)?  $default,){
final _that = this;
switch (_that) {
case _BazarrWantedSubtitle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String type,  String? seriesTitle,  int? seasonNumber,  int? episodeNumber,  List<String> languages,  String path, @JsonKey(name: 'radarrId')  int? radarrId, @JsonKey(name: 'sonarrId')  int? sonarrId, @JsonKey(name: 'episode_id')  int? episodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BazarrWantedSubtitle() when $default != null:
return $default(_that.title,_that.type,_that.seriesTitle,_that.seasonNumber,_that.episodeNumber,_that.languages,_that.path,_that.radarrId,_that.sonarrId,_that.episodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String type,  String? seriesTitle,  int? seasonNumber,  int? episodeNumber,  List<String> languages,  String path, @JsonKey(name: 'radarrId')  int? radarrId, @JsonKey(name: 'sonarrId')  int? sonarrId, @JsonKey(name: 'episode_id')  int? episodeId)  $default,) {final _that = this;
switch (_that) {
case _BazarrWantedSubtitle():
return $default(_that.title,_that.type,_that.seriesTitle,_that.seasonNumber,_that.episodeNumber,_that.languages,_that.path,_that.radarrId,_that.sonarrId,_that.episodeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String type,  String? seriesTitle,  int? seasonNumber,  int? episodeNumber,  List<String> languages,  String path, @JsonKey(name: 'radarrId')  int? radarrId, @JsonKey(name: 'sonarrId')  int? sonarrId, @JsonKey(name: 'episode_id')  int? episodeId)?  $default,) {final _that = this;
switch (_that) {
case _BazarrWantedSubtitle() when $default != null:
return $default(_that.title,_that.type,_that.seriesTitle,_that.seasonNumber,_that.episodeNumber,_that.languages,_that.path,_that.radarrId,_that.sonarrId,_that.episodeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BazarrWantedSubtitle implements BazarrWantedSubtitle {
  const _BazarrWantedSubtitle({required this.title, this.type = 'episode', this.seriesTitle, this.seasonNumber, this.episodeNumber,  List<String> languages = const [], this.path = '', @JsonKey(name: 'radarrId') this.radarrId, @JsonKey(name: 'sonarrId') this.sonarrId, @JsonKey(name: 'episode_id') this.episodeId}): _languages = languages;
  factory _BazarrWantedSubtitle.fromJson(Map<String, dynamic> json) => _$BazarrWantedSubtitleFromJson(json);

@override final  String title;
@override@JsonKey() final  String type;
@override final  String? seriesTitle;
@override final  int? seasonNumber;
@override final  int? episodeNumber;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override@JsonKey() final  String path;
@override@JsonKey(name: 'radarrId') final  int? radarrId;
@override@JsonKey(name: 'sonarrId') final  int? sonarrId;
@override@JsonKey(name: 'episode_id') final  int? episodeId;

/// Create a copy of BazarrWantedSubtitle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BazarrWantedSubtitleCopyWith<_BazarrWantedSubtitle> get copyWith => __$BazarrWantedSubtitleCopyWithImpl<_BazarrWantedSubtitle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BazarrWantedSubtitleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BazarrWantedSubtitle&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.path, path) || other.path == path)&&(identical(other.radarrId, radarrId) || other.radarrId == radarrId)&&(identical(other.sonarrId, sonarrId) || other.sonarrId == sonarrId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,type,seriesTitle,seasonNumber,episodeNumber,const DeepCollectionEquality().hash(_languages),path,radarrId,sonarrId,episodeId);

@override
String toString() {
  return 'BazarrWantedSubtitle(title: $title, type: $type, seriesTitle: $seriesTitle, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, languages: $languages, path: $path, radarrId: $radarrId, sonarrId: $sonarrId, episodeId: $episodeId)';
}


}

/// @nodoc
abstract mixin class _$BazarrWantedSubtitleCopyWith<$Res> implements $BazarrWantedSubtitleCopyWith<$Res> {
  factory _$BazarrWantedSubtitleCopyWith(_BazarrWantedSubtitle value, $Res Function(_BazarrWantedSubtitle) _then) = __$BazarrWantedSubtitleCopyWithImpl;
@override @useResult
$Res call({
 String title, String type, String? seriesTitle, int? seasonNumber, int? episodeNumber, List<String> languages, String path,@JsonKey(name: 'radarrId') int? radarrId,@JsonKey(name: 'sonarrId') int? sonarrId,@JsonKey(name: 'episode_id') int? episodeId
});




}
/// @nodoc
class __$BazarrWantedSubtitleCopyWithImpl<$Res>
    implements _$BazarrWantedSubtitleCopyWith<$Res> {
  __$BazarrWantedSubtitleCopyWithImpl(this._self, this._then);

  final _BazarrWantedSubtitle _self;
  final $Res Function(_BazarrWantedSubtitle) _then;

/// Create a copy of BazarrWantedSubtitle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? type = null,Object? seriesTitle = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? languages = null,Object? path = null,Object? radarrId = freezed,Object? sonarrId = freezed,Object? episodeId = freezed,}) {
  return _then(_BazarrWantedSubtitle(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,radarrId: freezed == radarrId ? _self.radarrId : radarrId // ignore: cast_nullable_to_non_nullable
as int?,sonarrId: freezed == sonarrId ? _self.sonarrId : sonarrId // ignore: cast_nullable_to_non_nullable
as int?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BazarrSystemStatus {

 String get version; String get branch;@JsonKey(name: 'app_name') String get appName;
/// Create a copy of BazarrSystemStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BazarrSystemStatusCopyWith<BazarrSystemStatus> get copyWith => _$BazarrSystemStatusCopyWithImpl<BazarrSystemStatus>(this as BazarrSystemStatus, _$identity);

  /// Serializes this BazarrSystemStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BazarrSystemStatus&&(identical(other.version, version) || other.version == version)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.appName, appName) || other.appName == appName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,branch,appName);

@override
String toString() {
  return 'BazarrSystemStatus(version: $version, branch: $branch, appName: $appName)';
}


}

/// @nodoc
abstract mixin class $BazarrSystemStatusCopyWith<$Res>  {
  factory $BazarrSystemStatusCopyWith(BazarrSystemStatus value, $Res Function(BazarrSystemStatus) _then) = _$BazarrSystemStatusCopyWithImpl;
@useResult
$Res call({
 String version, String branch,@JsonKey(name: 'app_name') String appName
});




}
/// @nodoc
class _$BazarrSystemStatusCopyWithImpl<$Res>
    implements $BazarrSystemStatusCopyWith<$Res> {
  _$BazarrSystemStatusCopyWithImpl(this._self, this._then);

  final BazarrSystemStatus _self;
  final $Res Function(BazarrSystemStatus) _then;

/// Create a copy of BazarrSystemStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? branch = null,Object? appName = null,}) {
  return _then(BazarrSystemStatus(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BazarrSystemStatus].
extension BazarrSystemStatusPatterns on BazarrSystemStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BazarrSystemStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BazarrSystemStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BazarrSystemStatus value)  $default,){
final _that = this;
switch (_that) {
case _BazarrSystemStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BazarrSystemStatus value)?  $default,){
final _that = this;
switch (_that) {
case _BazarrSystemStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String branch, @JsonKey(name: 'app_name')  String appName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BazarrSystemStatus() when $default != null:
return $default(_that.version,_that.branch,_that.appName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String branch, @JsonKey(name: 'app_name')  String appName)  $default,) {final _that = this;
switch (_that) {
case _BazarrSystemStatus():
return $default(_that.version,_that.branch,_that.appName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String branch, @JsonKey(name: 'app_name')  String appName)?  $default,) {final _that = this;
switch (_that) {
case _BazarrSystemStatus() when $default != null:
return $default(_that.version,_that.branch,_that.appName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BazarrSystemStatus implements BazarrSystemStatus {
  const _BazarrSystemStatus({this.version = '', this.branch = '', @JsonKey(name: 'app_name') this.appName = 'Bazarr'});
  factory _BazarrSystemStatus.fromJson(Map<String, dynamic> json) => _$BazarrSystemStatusFromJson(json);

@override@JsonKey() final  String version;
@override@JsonKey() final  String branch;
@override@JsonKey(name: 'app_name') final  String appName;

/// Create a copy of BazarrSystemStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BazarrSystemStatusCopyWith<_BazarrSystemStatus> get copyWith => __$BazarrSystemStatusCopyWithImpl<_BazarrSystemStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BazarrSystemStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BazarrSystemStatus&&(identical(other.version, version) || other.version == version)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.appName, appName) || other.appName == appName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,branch,appName);

@override
String toString() {
  return 'BazarrSystemStatus(version: $version, branch: $branch, appName: $appName)';
}


}

/// @nodoc
abstract mixin class _$BazarrSystemStatusCopyWith<$Res> implements $BazarrSystemStatusCopyWith<$Res> {
  factory _$BazarrSystemStatusCopyWith(_BazarrSystemStatus value, $Res Function(_BazarrSystemStatus) _then) = __$BazarrSystemStatusCopyWithImpl;
@override @useResult
$Res call({
 String version, String branch,@JsonKey(name: 'app_name') String appName
});




}
/// @nodoc
class __$BazarrSystemStatusCopyWithImpl<$Res>
    implements _$BazarrSystemStatusCopyWith<$Res> {
  __$BazarrSystemStatusCopyWithImpl(this._self, this._then);

  final _BazarrSystemStatus _self;
  final $Res Function(_BazarrSystemStatus) _then;

/// Create a copy of BazarrSystemStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? branch = null,Object? appName = null,}) {
  return _then(_BazarrSystemStatus(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
