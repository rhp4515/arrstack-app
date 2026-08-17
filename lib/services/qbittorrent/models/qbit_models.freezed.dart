// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qbit_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QbitTorrent {

 String get hash; String get name; int get size; double get progress; int get dlspeed; int get upspeed; int get priority;@JsonKey(name: 'num_seeds') int get numSeeds;@JsonKey(name: 'num_leechs') int get numLeechs;@JsonKey(name: 'num_incomplete') int get numIncomplete; double get ratio; int get eta; String get state;@JsonKey(name: 'seq_dl') int get seqDl;@JsonKey(name: 'seq_up') int get seqUp;@JsonKey(name: 'added_on') int get addedOn;@JsonKey(name: 'completion_on') int get completionOn; String get category; String get tags;@JsonKey(name: 'save_path') String get savePath;@JsonKey(name: 'time_active') int get timeActive;@JsonKey(name: 'last_activity') int get lastActivity;
/// Create a copy of QbitTorrent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QbitTorrentCopyWith<QbitTorrent> get copyWith => _$QbitTorrentCopyWithImpl<QbitTorrent>(this as QbitTorrent, _$identity);

  /// Serializes this QbitTorrent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QbitTorrent&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.dlspeed, dlspeed) || other.dlspeed == dlspeed)&&(identical(other.upspeed, upspeed) || other.upspeed == upspeed)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.numSeeds, numSeeds) || other.numSeeds == numSeeds)&&(identical(other.numLeechs, numLeechs) || other.numLeechs == numLeechs)&&(identical(other.numIncomplete, numIncomplete) || other.numIncomplete == numIncomplete)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.state, state) || other.state == state)&&(identical(other.seqDl, seqDl) || other.seqDl == seqDl)&&(identical(other.seqUp, seqUp) || other.seqUp == seqUp)&&(identical(other.addedOn, addedOn) || other.addedOn == addedOn)&&(identical(other.completionOn, completionOn) || other.completionOn == completionOn)&&(identical(other.category, category) || other.category == category)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.savePath, savePath) || other.savePath == savePath)&&(identical(other.timeActive, timeActive) || other.timeActive == timeActive)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,hash,name,size,progress,dlspeed,upspeed,priority,numSeeds,numLeechs,numIncomplete,ratio,eta,state,seqDl,seqUp,addedOn,completionOn,category,tags,savePath,timeActive,lastActivity]);

@override
String toString() {
  return 'QbitTorrent(hash: $hash, name: $name, size: $size, progress: $progress, dlspeed: $dlspeed, upspeed: $upspeed, priority: $priority, numSeeds: $numSeeds, numLeechs: $numLeechs, numIncomplete: $numIncomplete, ratio: $ratio, eta: $eta, state: $state, seqDl: $seqDl, seqUp: $seqUp, addedOn: $addedOn, completionOn: $completionOn, category: $category, tags: $tags, savePath: $savePath, timeActive: $timeActive, lastActivity: $lastActivity)';
}


}

/// @nodoc
abstract mixin class $QbitTorrentCopyWith<$Res>  {
  factory $QbitTorrentCopyWith(QbitTorrent value, $Res Function(QbitTorrent) _then) = _$QbitTorrentCopyWithImpl;
@useResult
$Res call({
 String hash, String name, int size, double progress, int dlspeed, int upspeed, int priority,@JsonKey(name: 'num_seeds') int numSeeds,@JsonKey(name: 'num_leechs') int numLeechs,@JsonKey(name: 'num_incomplete') int numIncomplete, double ratio, int eta, String state,@JsonKey(name: 'seq_dl') int seqDl,@JsonKey(name: 'seq_up') int seqUp,@JsonKey(name: 'added_on') int addedOn,@JsonKey(name: 'completion_on') int completionOn, String category, String tags,@JsonKey(name: 'save_path') String savePath,@JsonKey(name: 'time_active') int timeActive,@JsonKey(name: 'last_activity') int lastActivity
});




}
/// @nodoc
class _$QbitTorrentCopyWithImpl<$Res>
    implements $QbitTorrentCopyWith<$Res> {
  _$QbitTorrentCopyWithImpl(this._self, this._then);

  final QbitTorrent _self;
  final $Res Function(QbitTorrent) _then;

/// Create a copy of QbitTorrent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hash = null,Object? name = null,Object? size = null,Object? progress = null,Object? dlspeed = null,Object? upspeed = null,Object? priority = null,Object? numSeeds = null,Object? numLeechs = null,Object? numIncomplete = null,Object? ratio = null,Object? eta = null,Object? state = null,Object? seqDl = null,Object? seqUp = null,Object? addedOn = null,Object? completionOn = null,Object? category = null,Object? tags = null,Object? savePath = null,Object? timeActive = null,Object? lastActivity = null,}) {
  return _then(QbitTorrent(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,dlspeed: null == dlspeed ? _self.dlspeed : dlspeed // ignore: cast_nullable_to_non_nullable
as int,upspeed: null == upspeed ? _self.upspeed : upspeed // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,numSeeds: null == numSeeds ? _self.numSeeds : numSeeds // ignore: cast_nullable_to_non_nullable
as int,numLeechs: null == numLeechs ? _self.numLeechs : numLeechs // ignore: cast_nullable_to_non_nullable
as int,numIncomplete: null == numIncomplete ? _self.numIncomplete : numIncomplete // ignore: cast_nullable_to_non_nullable
as int,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,seqDl: null == seqDl ? _self.seqDl : seqDl // ignore: cast_nullable_to_non_nullable
as int,seqUp: null == seqUp ? _self.seqUp : seqUp // ignore: cast_nullable_to_non_nullable
as int,addedOn: null == addedOn ? _self.addedOn : addedOn // ignore: cast_nullable_to_non_nullable
as int,completionOn: null == completionOn ? _self.completionOn : completionOn // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,savePath: null == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String,timeActive: null == timeActive ? _self.timeActive : timeActive // ignore: cast_nullable_to_non_nullable
as int,lastActivity: null == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QbitTorrent].
extension QbitTorrentPatterns on QbitTorrent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QbitTorrent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QbitTorrent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QbitTorrent value)  $default,){
final _that = this;
switch (_that) {
case _QbitTorrent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QbitTorrent value)?  $default,){
final _that = this;
switch (_that) {
case _QbitTorrent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hash,  String name,  int size,  double progress,  int dlspeed,  int upspeed,  int priority, @JsonKey(name: 'num_seeds')  int numSeeds, @JsonKey(name: 'num_leechs')  int numLeechs, @JsonKey(name: 'num_incomplete')  int numIncomplete,  double ratio,  int eta,  String state, @JsonKey(name: 'seq_dl')  int seqDl, @JsonKey(name: 'seq_up')  int seqUp, @JsonKey(name: 'added_on')  int addedOn, @JsonKey(name: 'completion_on')  int completionOn,  String category,  String tags, @JsonKey(name: 'save_path')  String savePath, @JsonKey(name: 'time_active')  int timeActive, @JsonKey(name: 'last_activity')  int lastActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QbitTorrent() when $default != null:
return $default(_that.hash,_that.name,_that.size,_that.progress,_that.dlspeed,_that.upspeed,_that.priority,_that.numSeeds,_that.numLeechs,_that.numIncomplete,_that.ratio,_that.eta,_that.state,_that.seqDl,_that.seqUp,_that.addedOn,_that.completionOn,_that.category,_that.tags,_that.savePath,_that.timeActive,_that.lastActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hash,  String name,  int size,  double progress,  int dlspeed,  int upspeed,  int priority, @JsonKey(name: 'num_seeds')  int numSeeds, @JsonKey(name: 'num_leechs')  int numLeechs, @JsonKey(name: 'num_incomplete')  int numIncomplete,  double ratio,  int eta,  String state, @JsonKey(name: 'seq_dl')  int seqDl, @JsonKey(name: 'seq_up')  int seqUp, @JsonKey(name: 'added_on')  int addedOn, @JsonKey(name: 'completion_on')  int completionOn,  String category,  String tags, @JsonKey(name: 'save_path')  String savePath, @JsonKey(name: 'time_active')  int timeActive, @JsonKey(name: 'last_activity')  int lastActivity)  $default,) {final _that = this;
switch (_that) {
case _QbitTorrent():
return $default(_that.hash,_that.name,_that.size,_that.progress,_that.dlspeed,_that.upspeed,_that.priority,_that.numSeeds,_that.numLeechs,_that.numIncomplete,_that.ratio,_that.eta,_that.state,_that.seqDl,_that.seqUp,_that.addedOn,_that.completionOn,_that.category,_that.tags,_that.savePath,_that.timeActive,_that.lastActivity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hash,  String name,  int size,  double progress,  int dlspeed,  int upspeed,  int priority, @JsonKey(name: 'num_seeds')  int numSeeds, @JsonKey(name: 'num_leechs')  int numLeechs, @JsonKey(name: 'num_incomplete')  int numIncomplete,  double ratio,  int eta,  String state, @JsonKey(name: 'seq_dl')  int seqDl, @JsonKey(name: 'seq_up')  int seqUp, @JsonKey(name: 'added_on')  int addedOn, @JsonKey(name: 'completion_on')  int completionOn,  String category,  String tags, @JsonKey(name: 'save_path')  String savePath, @JsonKey(name: 'time_active')  int timeActive, @JsonKey(name: 'last_activity')  int lastActivity)?  $default,) {final _that = this;
switch (_that) {
case _QbitTorrent() when $default != null:
return $default(_that.hash,_that.name,_that.size,_that.progress,_that.dlspeed,_that.upspeed,_that.priority,_that.numSeeds,_that.numLeechs,_that.numIncomplete,_that.ratio,_that.eta,_that.state,_that.seqDl,_that.seqUp,_that.addedOn,_that.completionOn,_that.category,_that.tags,_that.savePath,_that.timeActive,_that.lastActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QbitTorrent implements QbitTorrent {
  const _QbitTorrent({required this.hash, required this.name, required this.size, required this.progress, required this.dlspeed, required this.upspeed, required this.priority, @JsonKey(name: 'num_seeds') required this.numSeeds, @JsonKey(name: 'num_leechs') required this.numLeechs, @JsonKey(name: 'num_incomplete') required this.numIncomplete, required this.ratio, required this.eta, required this.state, @JsonKey(name: 'seq_dl') required this.seqDl, @JsonKey(name: 'seq_up') required this.seqUp, @JsonKey(name: 'added_on') required this.addedOn, @JsonKey(name: 'completion_on') required this.completionOn, required this.category, required this.tags, @JsonKey(name: 'save_path') required this.savePath, @JsonKey(name: 'time_active') required this.timeActive, @JsonKey(name: 'last_activity') required this.lastActivity});
  factory _QbitTorrent.fromJson(Map<String, dynamic> json) => _$QbitTorrentFromJson(json);

@override final  String hash;
@override final  String name;
@override final  int size;
@override final  double progress;
@override final  int dlspeed;
@override final  int upspeed;
@override final  int priority;
@override@JsonKey(name: 'num_seeds') final  int numSeeds;
@override@JsonKey(name: 'num_leechs') final  int numLeechs;
@override@JsonKey(name: 'num_incomplete') final  int numIncomplete;
@override final  double ratio;
@override final  int eta;
@override final  String state;
@override@JsonKey(name: 'seq_dl') final  int seqDl;
@override@JsonKey(name: 'seq_up') final  int seqUp;
@override@JsonKey(name: 'added_on') final  int addedOn;
@override@JsonKey(name: 'completion_on') final  int completionOn;
@override final  String category;
@override final  String tags;
@override@JsonKey(name: 'save_path') final  String savePath;
@override@JsonKey(name: 'time_active') final  int timeActive;
@override@JsonKey(name: 'last_activity') final  int lastActivity;

/// Create a copy of QbitTorrent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QbitTorrentCopyWith<_QbitTorrent> get copyWith => __$QbitTorrentCopyWithImpl<_QbitTorrent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QbitTorrentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QbitTorrent&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.dlspeed, dlspeed) || other.dlspeed == dlspeed)&&(identical(other.upspeed, upspeed) || other.upspeed == upspeed)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.numSeeds, numSeeds) || other.numSeeds == numSeeds)&&(identical(other.numLeechs, numLeechs) || other.numLeechs == numLeechs)&&(identical(other.numIncomplete, numIncomplete) || other.numIncomplete == numIncomplete)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.state, state) || other.state == state)&&(identical(other.seqDl, seqDl) || other.seqDl == seqDl)&&(identical(other.seqUp, seqUp) || other.seqUp == seqUp)&&(identical(other.addedOn, addedOn) || other.addedOn == addedOn)&&(identical(other.completionOn, completionOn) || other.completionOn == completionOn)&&(identical(other.category, category) || other.category == category)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.savePath, savePath) || other.savePath == savePath)&&(identical(other.timeActive, timeActive) || other.timeActive == timeActive)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,hash,name,size,progress,dlspeed,upspeed,priority,numSeeds,numLeechs,numIncomplete,ratio,eta,state,seqDl,seqUp,addedOn,completionOn,category,tags,savePath,timeActive,lastActivity]);

@override
String toString() {
  return 'QbitTorrent(hash: $hash, name: $name, size: $size, progress: $progress, dlspeed: $dlspeed, upspeed: $upspeed, priority: $priority, numSeeds: $numSeeds, numLeechs: $numLeechs, numIncomplete: $numIncomplete, ratio: $ratio, eta: $eta, state: $state, seqDl: $seqDl, seqUp: $seqUp, addedOn: $addedOn, completionOn: $completionOn, category: $category, tags: $tags, savePath: $savePath, timeActive: $timeActive, lastActivity: $lastActivity)';
}


}

/// @nodoc
abstract mixin class _$QbitTorrentCopyWith<$Res> implements $QbitTorrentCopyWith<$Res> {
  factory _$QbitTorrentCopyWith(_QbitTorrent value, $Res Function(_QbitTorrent) _then) = __$QbitTorrentCopyWithImpl;
@override @useResult
$Res call({
 String hash, String name, int size, double progress, int dlspeed, int upspeed, int priority,@JsonKey(name: 'num_seeds') int numSeeds,@JsonKey(name: 'num_leechs') int numLeechs,@JsonKey(name: 'num_incomplete') int numIncomplete, double ratio, int eta, String state,@JsonKey(name: 'seq_dl') int seqDl,@JsonKey(name: 'seq_up') int seqUp,@JsonKey(name: 'added_on') int addedOn,@JsonKey(name: 'completion_on') int completionOn, String category, String tags,@JsonKey(name: 'save_path') String savePath,@JsonKey(name: 'time_active') int timeActive,@JsonKey(name: 'last_activity') int lastActivity
});




}
/// @nodoc
class __$QbitTorrentCopyWithImpl<$Res>
    implements _$QbitTorrentCopyWith<$Res> {
  __$QbitTorrentCopyWithImpl(this._self, this._then);

  final _QbitTorrent _self;
  final $Res Function(_QbitTorrent) _then;

/// Create a copy of QbitTorrent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hash = null,Object? name = null,Object? size = null,Object? progress = null,Object? dlspeed = null,Object? upspeed = null,Object? priority = null,Object? numSeeds = null,Object? numLeechs = null,Object? numIncomplete = null,Object? ratio = null,Object? eta = null,Object? state = null,Object? seqDl = null,Object? seqUp = null,Object? addedOn = null,Object? completionOn = null,Object? category = null,Object? tags = null,Object? savePath = null,Object? timeActive = null,Object? lastActivity = null,}) {
  return _then(_QbitTorrent(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,dlspeed: null == dlspeed ? _self.dlspeed : dlspeed // ignore: cast_nullable_to_non_nullable
as int,upspeed: null == upspeed ? _self.upspeed : upspeed // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,numSeeds: null == numSeeds ? _self.numSeeds : numSeeds // ignore: cast_nullable_to_non_nullable
as int,numLeechs: null == numLeechs ? _self.numLeechs : numLeechs // ignore: cast_nullable_to_non_nullable
as int,numIncomplete: null == numIncomplete ? _self.numIncomplete : numIncomplete // ignore: cast_nullable_to_non_nullable
as int,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,seqDl: null == seqDl ? _self.seqDl : seqDl // ignore: cast_nullable_to_non_nullable
as int,seqUp: null == seqUp ? _self.seqUp : seqUp // ignore: cast_nullable_to_non_nullable
as int,addedOn: null == addedOn ? _self.addedOn : addedOn // ignore: cast_nullable_to_non_nullable
as int,completionOn: null == completionOn ? _self.completionOn : completionOn // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,savePath: null == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String,timeActive: null == timeActive ? _self.timeActive : timeActive // ignore: cast_nullable_to_non_nullable
as int,lastActivity: null == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$QbitMainData {

@JsonKey(name: 'server_state') QbitServerState get serverState; Map<String, QbitTorrent> get torrents; List<String> get categories;
/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QbitMainDataCopyWith<QbitMainData> get copyWith => _$QbitMainDataCopyWithImpl<QbitMainData>(this as QbitMainData, _$identity);

  /// Serializes this QbitMainData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QbitMainData&&(identical(other.serverState, serverState) || other.serverState == serverState)&&const DeepCollectionEquality().equals(other.torrents, torrents)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverState,const DeepCollectionEquality().hash(torrents),const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'QbitMainData(serverState: $serverState, torrents: $torrents, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $QbitMainDataCopyWith<$Res>  {
  factory $QbitMainDataCopyWith(QbitMainData value, $Res Function(QbitMainData) _then) = _$QbitMainDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'server_state') QbitServerState serverState, Map<String, QbitTorrent> torrents, List<String> categories
});


$QbitServerStateCopyWith<$Res> get serverState;

}
/// @nodoc
class _$QbitMainDataCopyWithImpl<$Res>
    implements $QbitMainDataCopyWith<$Res> {
  _$QbitMainDataCopyWithImpl(this._self, this._then);

  final QbitMainData _self;
  final $Res Function(QbitMainData) _then;

/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverState = null,Object? torrents = null,Object? categories = null,}) {
  return _then(QbitMainData(
serverState: null == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as QbitServerState,torrents: null == torrents ? _self.torrents : torrents // ignore: cast_nullable_to_non_nullable
as Map<String, QbitTorrent>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QbitServerStateCopyWith<$Res> get serverState {
  
  return $QbitServerStateCopyWith<$Res>(_self.serverState, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}


/// Adds pattern-matching-related methods to [QbitMainData].
extension QbitMainDataPatterns on QbitMainData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QbitMainData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QbitMainData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QbitMainData value)  $default,){
final _that = this;
switch (_that) {
case _QbitMainData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QbitMainData value)?  $default,){
final _that = this;
switch (_that) {
case _QbitMainData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'server_state')  QbitServerState serverState,  Map<String, QbitTorrent> torrents,  List<String> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QbitMainData() when $default != null:
return $default(_that.serverState,_that.torrents,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'server_state')  QbitServerState serverState,  Map<String, QbitTorrent> torrents,  List<String> categories)  $default,) {final _that = this;
switch (_that) {
case _QbitMainData():
return $default(_that.serverState,_that.torrents,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'server_state')  QbitServerState serverState,  Map<String, QbitTorrent> torrents,  List<String> categories)?  $default,) {final _that = this;
switch (_that) {
case _QbitMainData() when $default != null:
return $default(_that.serverState,_that.torrents,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QbitMainData implements QbitMainData {
  const _QbitMainData({@JsonKey(name: 'server_state') required this.serverState,  Map<String, QbitTorrent> torrents = const {},  List<String> categories = const []}): _torrents = torrents,_categories = categories;
  factory _QbitMainData.fromJson(Map<String, dynamic> json) => _$QbitMainDataFromJson(json);

@override@JsonKey(name: 'server_state') final  QbitServerState serverState;
 final  Map<String, QbitTorrent> _torrents;
@override@JsonKey() Map<String, QbitTorrent> get torrents {
  if (_torrents is EqualUnmodifiableMapView) return _torrents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_torrents);
}

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QbitMainDataCopyWith<_QbitMainData> get copyWith => __$QbitMainDataCopyWithImpl<_QbitMainData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QbitMainDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QbitMainData&&(identical(other.serverState, serverState) || other.serverState == serverState)&&const DeepCollectionEquality().equals(other._torrents, _torrents)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverState,const DeepCollectionEquality().hash(_torrents),const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'QbitMainData(serverState: $serverState, torrents: $torrents, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$QbitMainDataCopyWith<$Res> implements $QbitMainDataCopyWith<$Res> {
  factory _$QbitMainDataCopyWith(_QbitMainData value, $Res Function(_QbitMainData) _then) = __$QbitMainDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'server_state') QbitServerState serverState, Map<String, QbitTorrent> torrents, List<String> categories
});


@override $QbitServerStateCopyWith<$Res> get serverState;

}
/// @nodoc
class __$QbitMainDataCopyWithImpl<$Res>
    implements _$QbitMainDataCopyWith<$Res> {
  __$QbitMainDataCopyWithImpl(this._self, this._then);

  final _QbitMainData _self;
  final $Res Function(_QbitMainData) _then;

/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverState = null,Object? torrents = null,Object? categories = null,}) {
  return _then(_QbitMainData(
serverState: null == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as QbitServerState,torrents: null == torrents ? _self._torrents : torrents // ignore: cast_nullable_to_non_nullable
as Map<String, QbitTorrent>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of QbitMainData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QbitServerStateCopyWith<$Res> get serverState {
  
  return $QbitServerStateCopyWith<$Res>(_self.serverState, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}


/// @nodoc
mixin _$QbitServerState {

@JsonKey(name: 'dl_info_speed') int get dlInfoSpeed;@JsonKey(name: 'dl_info_data') int get dlInfoData;@JsonKey(name: 'up_info_speed') int get upInfoSpeed;@JsonKey(name: 'up_info_data') int get upInfoData;@JsonKey(name: 'dl_rate_limit') int get dlRateLimit;@JsonKey(name: 'up_rate_limit') int get upRateLimit;@JsonKey(name: 'dht_nodes') int get dhtNodes;@JsonKey(name: 'connection_status') String get connectionStatus;
/// Create a copy of QbitServerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QbitServerStateCopyWith<QbitServerState> get copyWith => _$QbitServerStateCopyWithImpl<QbitServerState>(this as QbitServerState, _$identity);

  /// Serializes this QbitServerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QbitServerState&&(identical(other.dlInfoSpeed, dlInfoSpeed) || other.dlInfoSpeed == dlInfoSpeed)&&(identical(other.dlInfoData, dlInfoData) || other.dlInfoData == dlInfoData)&&(identical(other.upInfoSpeed, upInfoSpeed) || other.upInfoSpeed == upInfoSpeed)&&(identical(other.upInfoData, upInfoData) || other.upInfoData == upInfoData)&&(identical(other.dlRateLimit, dlRateLimit) || other.dlRateLimit == dlRateLimit)&&(identical(other.upRateLimit, upRateLimit) || other.upRateLimit == upRateLimit)&&(identical(other.dhtNodes, dhtNodes) || other.dhtNodes == dhtNodes)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dlInfoSpeed,dlInfoData,upInfoSpeed,upInfoData,dlRateLimit,upRateLimit,dhtNodes,connectionStatus);

@override
String toString() {
  return 'QbitServerState(dlInfoSpeed: $dlInfoSpeed, dlInfoData: $dlInfoData, upInfoSpeed: $upInfoSpeed, upInfoData: $upInfoData, dlRateLimit: $dlRateLimit, upRateLimit: $upRateLimit, dhtNodes: $dhtNodes, connectionStatus: $connectionStatus)';
}


}

/// @nodoc
abstract mixin class $QbitServerStateCopyWith<$Res>  {
  factory $QbitServerStateCopyWith(QbitServerState value, $Res Function(QbitServerState) _then) = _$QbitServerStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'dl_info_speed') int dlInfoSpeed,@JsonKey(name: 'dl_info_data') int dlInfoData,@JsonKey(name: 'up_info_speed') int upInfoSpeed,@JsonKey(name: 'up_info_data') int upInfoData,@JsonKey(name: 'dl_rate_limit') int dlRateLimit,@JsonKey(name: 'up_rate_limit') int upRateLimit,@JsonKey(name: 'dht_nodes') int dhtNodes,@JsonKey(name: 'connection_status') String connectionStatus
});




}
/// @nodoc
class _$QbitServerStateCopyWithImpl<$Res>
    implements $QbitServerStateCopyWith<$Res> {
  _$QbitServerStateCopyWithImpl(this._self, this._then);

  final QbitServerState _self;
  final $Res Function(QbitServerState) _then;

/// Create a copy of QbitServerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dlInfoSpeed = null,Object? dlInfoData = null,Object? upInfoSpeed = null,Object? upInfoData = null,Object? dlRateLimit = null,Object? upRateLimit = null,Object? dhtNodes = null,Object? connectionStatus = null,}) {
  return _then(QbitServerState(
dlInfoSpeed: null == dlInfoSpeed ? _self.dlInfoSpeed : dlInfoSpeed // ignore: cast_nullable_to_non_nullable
as int,dlInfoData: null == dlInfoData ? _self.dlInfoData : dlInfoData // ignore: cast_nullable_to_non_nullable
as int,upInfoSpeed: null == upInfoSpeed ? _self.upInfoSpeed : upInfoSpeed // ignore: cast_nullable_to_non_nullable
as int,upInfoData: null == upInfoData ? _self.upInfoData : upInfoData // ignore: cast_nullable_to_non_nullable
as int,dlRateLimit: null == dlRateLimit ? _self.dlRateLimit : dlRateLimit // ignore: cast_nullable_to_non_nullable
as int,upRateLimit: null == upRateLimit ? _self.upRateLimit : upRateLimit // ignore: cast_nullable_to_non_nullable
as int,dhtNodes: null == dhtNodes ? _self.dhtNodes : dhtNodes // ignore: cast_nullable_to_non_nullable
as int,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QbitServerState].
extension QbitServerStatePatterns on QbitServerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QbitServerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QbitServerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QbitServerState value)  $default,){
final _that = this;
switch (_that) {
case _QbitServerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QbitServerState value)?  $default,){
final _that = this;
switch (_that) {
case _QbitServerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'dl_info_speed')  int dlInfoSpeed, @JsonKey(name: 'dl_info_data')  int dlInfoData, @JsonKey(name: 'up_info_speed')  int upInfoSpeed, @JsonKey(name: 'up_info_data')  int upInfoData, @JsonKey(name: 'dl_rate_limit')  int dlRateLimit, @JsonKey(name: 'up_rate_limit')  int upRateLimit, @JsonKey(name: 'dht_nodes')  int dhtNodes, @JsonKey(name: 'connection_status')  String connectionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QbitServerState() when $default != null:
return $default(_that.dlInfoSpeed,_that.dlInfoData,_that.upInfoSpeed,_that.upInfoData,_that.dlRateLimit,_that.upRateLimit,_that.dhtNodes,_that.connectionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'dl_info_speed')  int dlInfoSpeed, @JsonKey(name: 'dl_info_data')  int dlInfoData, @JsonKey(name: 'up_info_speed')  int upInfoSpeed, @JsonKey(name: 'up_info_data')  int upInfoData, @JsonKey(name: 'dl_rate_limit')  int dlRateLimit, @JsonKey(name: 'up_rate_limit')  int upRateLimit, @JsonKey(name: 'dht_nodes')  int dhtNodes, @JsonKey(name: 'connection_status')  String connectionStatus)  $default,) {final _that = this;
switch (_that) {
case _QbitServerState():
return $default(_that.dlInfoSpeed,_that.dlInfoData,_that.upInfoSpeed,_that.upInfoData,_that.dlRateLimit,_that.upRateLimit,_that.dhtNodes,_that.connectionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'dl_info_speed')  int dlInfoSpeed, @JsonKey(name: 'dl_info_data')  int dlInfoData, @JsonKey(name: 'up_info_speed')  int upInfoSpeed, @JsonKey(name: 'up_info_data')  int upInfoData, @JsonKey(name: 'dl_rate_limit')  int dlRateLimit, @JsonKey(name: 'up_rate_limit')  int upRateLimit, @JsonKey(name: 'dht_nodes')  int dhtNodes, @JsonKey(name: 'connection_status')  String connectionStatus)?  $default,) {final _that = this;
switch (_that) {
case _QbitServerState() when $default != null:
return $default(_that.dlInfoSpeed,_that.dlInfoData,_that.upInfoSpeed,_that.upInfoData,_that.dlRateLimit,_that.upRateLimit,_that.dhtNodes,_that.connectionStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QbitServerState implements QbitServerState {
  const _QbitServerState({@JsonKey(name: 'dl_info_speed') required this.dlInfoSpeed, @JsonKey(name: 'dl_info_data') required this.dlInfoData, @JsonKey(name: 'up_info_speed') required this.upInfoSpeed, @JsonKey(name: 'up_info_data') required this.upInfoData, @JsonKey(name: 'dl_rate_limit') required this.dlRateLimit, @JsonKey(name: 'up_rate_limit') required this.upRateLimit, @JsonKey(name: 'dht_nodes') required this.dhtNodes, @JsonKey(name: 'connection_status') required this.connectionStatus});
  factory _QbitServerState.fromJson(Map<String, dynamic> json) => _$QbitServerStateFromJson(json);

@override@JsonKey(name: 'dl_info_speed') final  int dlInfoSpeed;
@override@JsonKey(name: 'dl_info_data') final  int dlInfoData;
@override@JsonKey(name: 'up_info_speed') final  int upInfoSpeed;
@override@JsonKey(name: 'up_info_data') final  int upInfoData;
@override@JsonKey(name: 'dl_rate_limit') final  int dlRateLimit;
@override@JsonKey(name: 'up_rate_limit') final  int upRateLimit;
@override@JsonKey(name: 'dht_nodes') final  int dhtNodes;
@override@JsonKey(name: 'connection_status') final  String connectionStatus;

/// Create a copy of QbitServerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QbitServerStateCopyWith<_QbitServerState> get copyWith => __$QbitServerStateCopyWithImpl<_QbitServerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QbitServerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QbitServerState&&(identical(other.dlInfoSpeed, dlInfoSpeed) || other.dlInfoSpeed == dlInfoSpeed)&&(identical(other.dlInfoData, dlInfoData) || other.dlInfoData == dlInfoData)&&(identical(other.upInfoSpeed, upInfoSpeed) || other.upInfoSpeed == upInfoSpeed)&&(identical(other.upInfoData, upInfoData) || other.upInfoData == upInfoData)&&(identical(other.dlRateLimit, dlRateLimit) || other.dlRateLimit == dlRateLimit)&&(identical(other.upRateLimit, upRateLimit) || other.upRateLimit == upRateLimit)&&(identical(other.dhtNodes, dhtNodes) || other.dhtNodes == dhtNodes)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dlInfoSpeed,dlInfoData,upInfoSpeed,upInfoData,dlRateLimit,upRateLimit,dhtNodes,connectionStatus);

@override
String toString() {
  return 'QbitServerState(dlInfoSpeed: $dlInfoSpeed, dlInfoData: $dlInfoData, upInfoSpeed: $upInfoSpeed, upInfoData: $upInfoData, dlRateLimit: $dlRateLimit, upRateLimit: $upRateLimit, dhtNodes: $dhtNodes, connectionStatus: $connectionStatus)';
}


}

/// @nodoc
abstract mixin class _$QbitServerStateCopyWith<$Res> implements $QbitServerStateCopyWith<$Res> {
  factory _$QbitServerStateCopyWith(_QbitServerState value, $Res Function(_QbitServerState) _then) = __$QbitServerStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'dl_info_speed') int dlInfoSpeed,@JsonKey(name: 'dl_info_data') int dlInfoData,@JsonKey(name: 'up_info_speed') int upInfoSpeed,@JsonKey(name: 'up_info_data') int upInfoData,@JsonKey(name: 'dl_rate_limit') int dlRateLimit,@JsonKey(name: 'up_rate_limit') int upRateLimit,@JsonKey(name: 'dht_nodes') int dhtNodes,@JsonKey(name: 'connection_status') String connectionStatus
});




}
/// @nodoc
class __$QbitServerStateCopyWithImpl<$Res>
    implements _$QbitServerStateCopyWith<$Res> {
  __$QbitServerStateCopyWithImpl(this._self, this._then);

  final _QbitServerState _self;
  final $Res Function(_QbitServerState) _then;

/// Create a copy of QbitServerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dlInfoSpeed = null,Object? dlInfoData = null,Object? upInfoSpeed = null,Object? upInfoData = null,Object? dlRateLimit = null,Object? upRateLimit = null,Object? dhtNodes = null,Object? connectionStatus = null,}) {
  return _then(_QbitServerState(
dlInfoSpeed: null == dlInfoSpeed ? _self.dlInfoSpeed : dlInfoSpeed // ignore: cast_nullable_to_non_nullable
as int,dlInfoData: null == dlInfoData ? _self.dlInfoData : dlInfoData // ignore: cast_nullable_to_non_nullable
as int,upInfoSpeed: null == upInfoSpeed ? _self.upInfoSpeed : upInfoSpeed // ignore: cast_nullable_to_non_nullable
as int,upInfoData: null == upInfoData ? _self.upInfoData : upInfoData // ignore: cast_nullable_to_non_nullable
as int,dlRateLimit: null == dlRateLimit ? _self.dlRateLimit : dlRateLimit // ignore: cast_nullable_to_non_nullable
as int,upRateLimit: null == upRateLimit ? _self.upRateLimit : upRateLimit // ignore: cast_nullable_to_non_nullable
as int,dhtNodes: null == dhtNodes ? _self.dhtNodes : dhtNodes // ignore: cast_nullable_to_non_nullable
as int,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
