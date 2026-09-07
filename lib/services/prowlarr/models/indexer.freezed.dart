// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'indexer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Indexer {

 int get id; String get name; String get protocol; int get priority; bool get enable; String? get status;
/// Create a copy of Indexer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndexerCopyWith<Indexer> get copyWith => _$IndexerCopyWithImpl<Indexer>(this as Indexer, _$identity);

  /// Serializes this Indexer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Indexer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,protocol,priority,enable,status);

@override
String toString() {
  return 'Indexer(id: $id, name: $name, protocol: $protocol, priority: $priority, enable: $enable, status: $status)';
}


}

/// @nodoc
abstract mixin class $IndexerCopyWith<$Res>  {
  factory $IndexerCopyWith(Indexer value, $Res Function(Indexer) _then) = _$IndexerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String protocol, int priority, bool enable, String? status
});




}
/// @nodoc
class _$IndexerCopyWithImpl<$Res>
    implements $IndexerCopyWith<$Res> {
  _$IndexerCopyWithImpl(this._self, this._then);

  final Indexer _self;
  final $Res Function(Indexer) _then;

/// Create a copy of Indexer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? protocol = null,Object? priority = null,Object? enable = null,Object? status = freezed,}) {
  return _then(Indexer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Indexer].
extension IndexerPatterns on Indexer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Indexer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Indexer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Indexer value)  $default,){
final _that = this;
switch (_that) {
case _Indexer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Indexer value)?  $default,){
final _that = this;
switch (_that) {
case _Indexer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String protocol,  int priority,  bool enable,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Indexer() when $default != null:
return $default(_that.id,_that.name,_that.protocol,_that.priority,_that.enable,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String protocol,  int priority,  bool enable,  String? status)  $default,) {final _that = this;
switch (_that) {
case _Indexer():
return $default(_that.id,_that.name,_that.protocol,_that.priority,_that.enable,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String protocol,  int priority,  bool enable,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _Indexer() when $default != null:
return $default(_that.id,_that.name,_that.protocol,_that.priority,_that.enable,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Indexer implements Indexer {
  const _Indexer({required this.id, this.name = '', this.protocol = '', this.priority = 25, this.enable = true, this.status});
  factory _Indexer.fromJson(Map<String, dynamic> json) => _$IndexerFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String protocol;
@override@JsonKey() final  int priority;
@override@JsonKey() final  bool enable;
@override final  String? status;

/// Create a copy of Indexer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndexerCopyWith<_Indexer> get copyWith => __$IndexerCopyWithImpl<_Indexer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndexerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Indexer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,protocol,priority,enable,status);

@override
String toString() {
  return 'Indexer(id: $id, name: $name, protocol: $protocol, priority: $priority, enable: $enable, status: $status)';
}


}

/// @nodoc
abstract mixin class _$IndexerCopyWith<$Res> implements $IndexerCopyWith<$Res> {
  factory _$IndexerCopyWith(_Indexer value, $Res Function(_Indexer) _then) = __$IndexerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String protocol, int priority, bool enable, String? status
});




}
/// @nodoc
class __$IndexerCopyWithImpl<$Res>
    implements _$IndexerCopyWith<$Res> {
  __$IndexerCopyWithImpl(this._self, this._then);

  final _Indexer _self;
  final $Res Function(_Indexer) _then;

/// Create a copy of Indexer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? protocol = null,Object? priority = null,Object? enable = null,Object? status = freezed,}) {
  return _then(_Indexer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
