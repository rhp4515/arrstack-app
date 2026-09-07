// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'indexer_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IndexerStat {

 int get indexerId; String get indexerName; int get averageResponseTime; int get numberOfQueries; int get numberOfGrabs; int get numberOfFailures;
/// Create a copy of IndexerStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndexerStatCopyWith<IndexerStat> get copyWith => _$IndexerStatCopyWithImpl<IndexerStat>(this as IndexerStat, _$identity);

  /// Serializes this IndexerStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndexerStat&&(identical(other.indexerId, indexerId) || other.indexerId == indexerId)&&(identical(other.indexerName, indexerName) || other.indexerName == indexerName)&&(identical(other.averageResponseTime, averageResponseTime) || other.averageResponseTime == averageResponseTime)&&(identical(other.numberOfQueries, numberOfQueries) || other.numberOfQueries == numberOfQueries)&&(identical(other.numberOfGrabs, numberOfGrabs) || other.numberOfGrabs == numberOfGrabs)&&(identical(other.numberOfFailures, numberOfFailures) || other.numberOfFailures == numberOfFailures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,indexerId,indexerName,averageResponseTime,numberOfQueries,numberOfGrabs,numberOfFailures);

@override
String toString() {
  return 'IndexerStat(indexerId: $indexerId, indexerName: $indexerName, averageResponseTime: $averageResponseTime, numberOfQueries: $numberOfQueries, numberOfGrabs: $numberOfGrabs, numberOfFailures: $numberOfFailures)';
}


}

/// @nodoc
abstract mixin class $IndexerStatCopyWith<$Res>  {
  factory $IndexerStatCopyWith(IndexerStat value, $Res Function(IndexerStat) _then) = _$IndexerStatCopyWithImpl;
@useResult
$Res call({
 int indexerId, String indexerName, int averageResponseTime, int numberOfQueries, int numberOfGrabs, int numberOfFailures
});




}
/// @nodoc
class _$IndexerStatCopyWithImpl<$Res>
    implements $IndexerStatCopyWith<$Res> {
  _$IndexerStatCopyWithImpl(this._self, this._then);

  final IndexerStat _self;
  final $Res Function(IndexerStat) _then;

/// Create a copy of IndexerStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? indexerId = null,Object? indexerName = null,Object? averageResponseTime = null,Object? numberOfQueries = null,Object? numberOfGrabs = null,Object? numberOfFailures = null,}) {
  return _then(IndexerStat(
indexerId: null == indexerId ? _self.indexerId : indexerId // ignore: cast_nullable_to_non_nullable
as int,indexerName: null == indexerName ? _self.indexerName : indexerName // ignore: cast_nullable_to_non_nullable
as String,averageResponseTime: null == averageResponseTime ? _self.averageResponseTime : averageResponseTime // ignore: cast_nullable_to_non_nullable
as int,numberOfQueries: null == numberOfQueries ? _self.numberOfQueries : numberOfQueries // ignore: cast_nullable_to_non_nullable
as int,numberOfGrabs: null == numberOfGrabs ? _self.numberOfGrabs : numberOfGrabs // ignore: cast_nullable_to_non_nullable
as int,numberOfFailures: null == numberOfFailures ? _self.numberOfFailures : numberOfFailures // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IndexerStat].
extension IndexerStatPatterns on IndexerStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndexerStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndexerStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndexerStat value)  $default,){
final _that = this;
switch (_that) {
case _IndexerStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndexerStat value)?  $default,){
final _that = this;
switch (_that) {
case _IndexerStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int indexerId,  String indexerName,  int averageResponseTime,  int numberOfQueries,  int numberOfGrabs,  int numberOfFailures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndexerStat() when $default != null:
return $default(_that.indexerId,_that.indexerName,_that.averageResponseTime,_that.numberOfQueries,_that.numberOfGrabs,_that.numberOfFailures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int indexerId,  String indexerName,  int averageResponseTime,  int numberOfQueries,  int numberOfGrabs,  int numberOfFailures)  $default,) {final _that = this;
switch (_that) {
case _IndexerStat():
return $default(_that.indexerId,_that.indexerName,_that.averageResponseTime,_that.numberOfQueries,_that.numberOfGrabs,_that.numberOfFailures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int indexerId,  String indexerName,  int averageResponseTime,  int numberOfQueries,  int numberOfGrabs,  int numberOfFailures)?  $default,) {final _that = this;
switch (_that) {
case _IndexerStat() when $default != null:
return $default(_that.indexerId,_that.indexerName,_that.averageResponseTime,_that.numberOfQueries,_that.numberOfGrabs,_that.numberOfFailures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndexerStat implements IndexerStat {
  const _IndexerStat({required this.indexerId, this.indexerName = '', this.averageResponseTime = 0, this.numberOfQueries = 0, this.numberOfGrabs = 0, this.numberOfFailures = 0});
  factory _IndexerStat.fromJson(Map<String, dynamic> json) => _$IndexerStatFromJson(json);

@override final  int indexerId;
@override@JsonKey() final  String indexerName;
@override@JsonKey() final  int averageResponseTime;
@override@JsonKey() final  int numberOfQueries;
@override@JsonKey() final  int numberOfGrabs;
@override@JsonKey() final  int numberOfFailures;

/// Create a copy of IndexerStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndexerStatCopyWith<_IndexerStat> get copyWith => __$IndexerStatCopyWithImpl<_IndexerStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndexerStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndexerStat&&(identical(other.indexerId, indexerId) || other.indexerId == indexerId)&&(identical(other.indexerName, indexerName) || other.indexerName == indexerName)&&(identical(other.averageResponseTime, averageResponseTime) || other.averageResponseTime == averageResponseTime)&&(identical(other.numberOfQueries, numberOfQueries) || other.numberOfQueries == numberOfQueries)&&(identical(other.numberOfGrabs, numberOfGrabs) || other.numberOfGrabs == numberOfGrabs)&&(identical(other.numberOfFailures, numberOfFailures) || other.numberOfFailures == numberOfFailures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,indexerId,indexerName,averageResponseTime,numberOfQueries,numberOfGrabs,numberOfFailures);

@override
String toString() {
  return 'IndexerStat(indexerId: $indexerId, indexerName: $indexerName, averageResponseTime: $averageResponseTime, numberOfQueries: $numberOfQueries, numberOfGrabs: $numberOfGrabs, numberOfFailures: $numberOfFailures)';
}


}

/// @nodoc
abstract mixin class _$IndexerStatCopyWith<$Res> implements $IndexerStatCopyWith<$Res> {
  factory _$IndexerStatCopyWith(_IndexerStat value, $Res Function(_IndexerStat) _then) = __$IndexerStatCopyWithImpl;
@override @useResult
$Res call({
 int indexerId, String indexerName, int averageResponseTime, int numberOfQueries, int numberOfGrabs, int numberOfFailures
});




}
/// @nodoc
class __$IndexerStatCopyWithImpl<$Res>
    implements _$IndexerStatCopyWith<$Res> {
  __$IndexerStatCopyWithImpl(this._self, this._then);

  final _IndexerStat _self;
  final $Res Function(_IndexerStat) _then;

/// Create a copy of IndexerStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? indexerId = null,Object? indexerName = null,Object? averageResponseTime = null,Object? numberOfQueries = null,Object? numberOfGrabs = null,Object? numberOfFailures = null,}) {
  return _then(_IndexerStat(
indexerId: null == indexerId ? _self.indexerId : indexerId // ignore: cast_nullable_to_non_nullable
as int,indexerName: null == indexerName ? _self.indexerName : indexerName // ignore: cast_nullable_to_non_nullable
as String,averageResponseTime: null == averageResponseTime ? _self.averageResponseTime : averageResponseTime // ignore: cast_nullable_to_non_nullable
as int,numberOfQueries: null == numberOfQueries ? _self.numberOfQueries : numberOfQueries // ignore: cast_nullable_to_non_nullable
as int,numberOfGrabs: null == numberOfGrabs ? _self.numberOfGrabs : numberOfGrabs // ignore: cast_nullable_to_non_nullable
as int,numberOfFailures: null == numberOfFailures ? _self.numberOfFailures : numberOfFailures // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$IndexerStatsResponse {

 List<IndexerStat> get indexers;
/// Create a copy of IndexerStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndexerStatsResponseCopyWith<IndexerStatsResponse> get copyWith => _$IndexerStatsResponseCopyWithImpl<IndexerStatsResponse>(this as IndexerStatsResponse, _$identity);

  /// Serializes this IndexerStatsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndexerStatsResponse&&const DeepCollectionEquality().equals(other.indexers, indexers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(indexers));

@override
String toString() {
  return 'IndexerStatsResponse(indexers: $indexers)';
}


}

/// @nodoc
abstract mixin class $IndexerStatsResponseCopyWith<$Res>  {
  factory $IndexerStatsResponseCopyWith(IndexerStatsResponse value, $Res Function(IndexerStatsResponse) _then) = _$IndexerStatsResponseCopyWithImpl;
@useResult
$Res call({
 List<IndexerStat> indexers
});




}
/// @nodoc
class _$IndexerStatsResponseCopyWithImpl<$Res>
    implements $IndexerStatsResponseCopyWith<$Res> {
  _$IndexerStatsResponseCopyWithImpl(this._self, this._then);

  final IndexerStatsResponse _self;
  final $Res Function(IndexerStatsResponse) _then;

/// Create a copy of IndexerStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? indexers = null,}) {
  return _then(IndexerStatsResponse(
indexers: null == indexers ? _self.indexers : indexers // ignore: cast_nullable_to_non_nullable
as List<IndexerStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [IndexerStatsResponse].
extension IndexerStatsResponsePatterns on IndexerStatsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndexerStatsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndexerStatsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndexerStatsResponse value)  $default,){
final _that = this;
switch (_that) {
case _IndexerStatsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndexerStatsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _IndexerStatsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<IndexerStat> indexers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndexerStatsResponse() when $default != null:
return $default(_that.indexers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<IndexerStat> indexers)  $default,) {final _that = this;
switch (_that) {
case _IndexerStatsResponse():
return $default(_that.indexers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<IndexerStat> indexers)?  $default,) {final _that = this;
switch (_that) {
case _IndexerStatsResponse() when $default != null:
return $default(_that.indexers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndexerStatsResponse implements IndexerStatsResponse {
  const _IndexerStatsResponse({ List<IndexerStat> indexers = const []}): _indexers = indexers;
  factory _IndexerStatsResponse.fromJson(Map<String, dynamic> json) => _$IndexerStatsResponseFromJson(json);

 final  List<IndexerStat> _indexers;
@override@JsonKey() List<IndexerStat> get indexers {
  if (_indexers is EqualUnmodifiableListView) return _indexers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indexers);
}


/// Create a copy of IndexerStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndexerStatsResponseCopyWith<_IndexerStatsResponse> get copyWith => __$IndexerStatsResponseCopyWithImpl<_IndexerStatsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndexerStatsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndexerStatsResponse&&const DeepCollectionEquality().equals(other._indexers, _indexers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_indexers));

@override
String toString() {
  return 'IndexerStatsResponse(indexers: $indexers)';
}


}

/// @nodoc
abstract mixin class _$IndexerStatsResponseCopyWith<$Res> implements $IndexerStatsResponseCopyWith<$Res> {
  factory _$IndexerStatsResponseCopyWith(_IndexerStatsResponse value, $Res Function(_IndexerStatsResponse) _then) = __$IndexerStatsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<IndexerStat> indexers
});




}
/// @nodoc
class __$IndexerStatsResponseCopyWithImpl<$Res>
    implements _$IndexerStatsResponseCopyWith<$Res> {
  __$IndexerStatsResponseCopyWithImpl(this._self, this._then);

  final _IndexerStatsResponse _self;
  final $Res Function(_IndexerStatsResponse) _then;

/// Create a copy of IndexerStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? indexers = null,}) {
  return _then(_IndexerStatsResponse(
indexers: null == indexers ? _self._indexers : indexers // ignore: cast_nullable_to_non_nullable
as List<IndexerStat>,
  ));
}


}

// dart format on
