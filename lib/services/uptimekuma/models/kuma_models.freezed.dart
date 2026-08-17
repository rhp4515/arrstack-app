// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kuma_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KumaMonitor {

 int get id; String get name; String get type; String? get url; bool get active; int get interval; int get status; double get uptime; int get weight; List<KumaHeartbeat> get heartbeats;
/// Create a copy of KumaMonitor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KumaMonitorCopyWith<KumaMonitor> get copyWith => _$KumaMonitorCopyWithImpl<KumaMonitor>(this as KumaMonitor, _$identity);

  /// Serializes this KumaMonitor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KumaMonitor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.active, active) || other.active == active)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.status, status) || other.status == status)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.weight, weight) || other.weight == weight)&&const DeepCollectionEquality().equals(other.heartbeats, heartbeats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,url,active,interval,status,uptime,weight,const DeepCollectionEquality().hash(heartbeats));

@override
String toString() {
  return 'KumaMonitor(id: $id, name: $name, type: $type, url: $url, active: $active, interval: $interval, status: $status, uptime: $uptime, weight: $weight, heartbeats: $heartbeats)';
}


}

/// @nodoc
abstract mixin class $KumaMonitorCopyWith<$Res>  {
  factory $KumaMonitorCopyWith(KumaMonitor value, $Res Function(KumaMonitor) _then) = _$KumaMonitorCopyWithImpl;
@useResult
$Res call({
 int id, String name, String type, String? url, bool active, int interval, int status, double uptime, int weight, List<KumaHeartbeat> heartbeats
});




}
/// @nodoc
class _$KumaMonitorCopyWithImpl<$Res>
    implements $KumaMonitorCopyWith<$Res> {
  _$KumaMonitorCopyWithImpl(this._self, this._then);

  final KumaMonitor _self;
  final $Res Function(KumaMonitor) _then;

/// Create a copy of KumaMonitor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? url = freezed,Object? active = null,Object? interval = null,Object? status = null,Object? uptime = null,Object? weight = null,Object? heartbeats = null,}) {
  return _then(KumaMonitor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,heartbeats: null == heartbeats ? _self.heartbeats : heartbeats // ignore: cast_nullable_to_non_nullable
as List<KumaHeartbeat>,
  ));
}

}


/// Adds pattern-matching-related methods to [KumaMonitor].
extension KumaMonitorPatterns on KumaMonitor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KumaMonitor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KumaMonitor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KumaMonitor value)  $default,){
final _that = this;
switch (_that) {
case _KumaMonitor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KumaMonitor value)?  $default,){
final _that = this;
switch (_that) {
case _KumaMonitor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String type,  String? url,  bool active,  int interval,  int status,  double uptime,  int weight,  List<KumaHeartbeat> heartbeats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KumaMonitor() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.url,_that.active,_that.interval,_that.status,_that.uptime,_that.weight,_that.heartbeats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String type,  String? url,  bool active,  int interval,  int status,  double uptime,  int weight,  List<KumaHeartbeat> heartbeats)  $default,) {final _that = this;
switch (_that) {
case _KumaMonitor():
return $default(_that.id,_that.name,_that.type,_that.url,_that.active,_that.interval,_that.status,_that.uptime,_that.weight,_that.heartbeats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String type,  String? url,  bool active,  int interval,  int status,  double uptime,  int weight,  List<KumaHeartbeat> heartbeats)?  $default,) {final _that = this;
switch (_that) {
case _KumaMonitor() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.url,_that.active,_that.interval,_that.status,_that.uptime,_that.weight,_that.heartbeats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KumaMonitor implements KumaMonitor {
  const _KumaMonitor({required this.id, required this.name, required this.type, this.url, required this.active, required this.interval, this.status = 1, this.uptime = 0, this.weight = 0,  List<KumaHeartbeat> heartbeats = const []}): _heartbeats = heartbeats;
  factory _KumaMonitor.fromJson(Map<String, dynamic> json) => _$KumaMonitorFromJson(json);

@override final  int id;
@override final  String name;
@override final  String type;
@override final  String? url;
@override final  bool active;
@override final  int interval;
@override@JsonKey() final  int status;
@override@JsonKey() final  double uptime;
@override@JsonKey() final  int weight;
 final  List<KumaHeartbeat> _heartbeats;
@override@JsonKey() List<KumaHeartbeat> get heartbeats {
  if (_heartbeats is EqualUnmodifiableListView) return _heartbeats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heartbeats);
}


/// Create a copy of KumaMonitor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KumaMonitorCopyWith<_KumaMonitor> get copyWith => __$KumaMonitorCopyWithImpl<_KumaMonitor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KumaMonitorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KumaMonitor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.active, active) || other.active == active)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.status, status) || other.status == status)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.weight, weight) || other.weight == weight)&&const DeepCollectionEquality().equals(other._heartbeats, _heartbeats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,url,active,interval,status,uptime,weight,const DeepCollectionEquality().hash(_heartbeats));

@override
String toString() {
  return 'KumaMonitor(id: $id, name: $name, type: $type, url: $url, active: $active, interval: $interval, status: $status, uptime: $uptime, weight: $weight, heartbeats: $heartbeats)';
}


}

/// @nodoc
abstract mixin class _$KumaMonitorCopyWith<$Res> implements $KumaMonitorCopyWith<$Res> {
  factory _$KumaMonitorCopyWith(_KumaMonitor value, $Res Function(_KumaMonitor) _then) = __$KumaMonitorCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String type, String? url, bool active, int interval, int status, double uptime, int weight, List<KumaHeartbeat> heartbeats
});




}
/// @nodoc
class __$KumaMonitorCopyWithImpl<$Res>
    implements _$KumaMonitorCopyWith<$Res> {
  __$KumaMonitorCopyWithImpl(this._self, this._then);

  final _KumaMonitor _self;
  final $Res Function(_KumaMonitor) _then;

/// Create a copy of KumaMonitor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? url = freezed,Object? active = null,Object? interval = null,Object? status = null,Object? uptime = null,Object? weight = null,Object? heartbeats = null,}) {
  return _then(_KumaMonitor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,heartbeats: null == heartbeats ? _self._heartbeats : heartbeats // ignore: cast_nullable_to_non_nullable
as List<KumaHeartbeat>,
  ));
}


}


/// @nodoc
mixin _$KumaHeartbeat {

@JsonKey(name: 'monitorID') int get monitorId; int get status; DateTime get time; String? get msg; int get ping; bool get important;
/// Create a copy of KumaHeartbeat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KumaHeartbeatCopyWith<KumaHeartbeat> get copyWith => _$KumaHeartbeatCopyWithImpl<KumaHeartbeat>(this as KumaHeartbeat, _$identity);

  /// Serializes this KumaHeartbeat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KumaHeartbeat&&(identical(other.monitorId, monitorId) || other.monitorId == monitorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.time, time) || other.time == time)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.ping, ping) || other.ping == ping)&&(identical(other.important, important) || other.important == important));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monitorId,status,time,msg,ping,important);

@override
String toString() {
  return 'KumaHeartbeat(monitorId: $monitorId, status: $status, time: $time, msg: $msg, ping: $ping, important: $important)';
}


}

/// @nodoc
abstract mixin class $KumaHeartbeatCopyWith<$Res>  {
  factory $KumaHeartbeatCopyWith(KumaHeartbeat value, $Res Function(KumaHeartbeat) _then) = _$KumaHeartbeatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'monitorID') int monitorId, int status, DateTime time, String? msg, int ping, bool important
});




}
/// @nodoc
class _$KumaHeartbeatCopyWithImpl<$Res>
    implements $KumaHeartbeatCopyWith<$Res> {
  _$KumaHeartbeatCopyWithImpl(this._self, this._then);

  final KumaHeartbeat _self;
  final $Res Function(KumaHeartbeat) _then;

/// Create a copy of KumaHeartbeat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monitorId = null,Object? status = null,Object? time = null,Object? msg = freezed,Object? ping = null,Object? important = null,}) {
  return _then(KumaHeartbeat(
monitorId: null == monitorId ? _self.monitorId : monitorId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,ping: null == ping ? _self.ping : ping // ignore: cast_nullable_to_non_nullable
as int,important: null == important ? _self.important : important // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KumaHeartbeat].
extension KumaHeartbeatPatterns on KumaHeartbeat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KumaHeartbeat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KumaHeartbeat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KumaHeartbeat value)  $default,){
final _that = this;
switch (_that) {
case _KumaHeartbeat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KumaHeartbeat value)?  $default,){
final _that = this;
switch (_that) {
case _KumaHeartbeat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'monitorID')  int monitorId,  int status,  DateTime time,  String? msg,  int ping,  bool important)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KumaHeartbeat() when $default != null:
return $default(_that.monitorId,_that.status,_that.time,_that.msg,_that.ping,_that.important);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'monitorID')  int monitorId,  int status,  DateTime time,  String? msg,  int ping,  bool important)  $default,) {final _that = this;
switch (_that) {
case _KumaHeartbeat():
return $default(_that.monitorId,_that.status,_that.time,_that.msg,_that.ping,_that.important);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'monitorID')  int monitorId,  int status,  DateTime time,  String? msg,  int ping,  bool important)?  $default,) {final _that = this;
switch (_that) {
case _KumaHeartbeat() when $default != null:
return $default(_that.monitorId,_that.status,_that.time,_that.msg,_that.ping,_that.important);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KumaHeartbeat implements KumaHeartbeat {
  const _KumaHeartbeat({@JsonKey(name: 'monitorID') required this.monitorId, required this.status, required this.time, this.msg, required this.ping, required this.important});
  factory _KumaHeartbeat.fromJson(Map<String, dynamic> json) => _$KumaHeartbeatFromJson(json);

@override@JsonKey(name: 'monitorID') final  int monitorId;
@override final  int status;
@override final  DateTime time;
@override final  String? msg;
@override final  int ping;
@override final  bool important;

/// Create a copy of KumaHeartbeat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KumaHeartbeatCopyWith<_KumaHeartbeat> get copyWith => __$KumaHeartbeatCopyWithImpl<_KumaHeartbeat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KumaHeartbeatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KumaHeartbeat&&(identical(other.monitorId, monitorId) || other.monitorId == monitorId)&&(identical(other.status, status) || other.status == status)&&(identical(other.time, time) || other.time == time)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.ping, ping) || other.ping == ping)&&(identical(other.important, important) || other.important == important));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monitorId,status,time,msg,ping,important);

@override
String toString() {
  return 'KumaHeartbeat(monitorId: $monitorId, status: $status, time: $time, msg: $msg, ping: $ping, important: $important)';
}


}

/// @nodoc
abstract mixin class _$KumaHeartbeatCopyWith<$Res> implements $KumaHeartbeatCopyWith<$Res> {
  factory _$KumaHeartbeatCopyWith(_KumaHeartbeat value, $Res Function(_KumaHeartbeat) _then) = __$KumaHeartbeatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'monitorID') int monitorId, int status, DateTime time, String? msg, int ping, bool important
});




}
/// @nodoc
class __$KumaHeartbeatCopyWithImpl<$Res>
    implements _$KumaHeartbeatCopyWith<$Res> {
  __$KumaHeartbeatCopyWithImpl(this._self, this._then);

  final _KumaHeartbeat _self;
  final $Res Function(_KumaHeartbeat) _then;

/// Create a copy of KumaHeartbeat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monitorId = null,Object? status = null,Object? time = null,Object? msg = freezed,Object? ping = null,Object? important = null,}) {
  return _then(_KumaHeartbeat(
monitorId: null == monitorId ? _self.monitorId : monitorId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,msg: freezed == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String?,ping: null == ping ? _self.ping : ping // ignore: cast_nullable_to_non_nullable
as int,important: null == important ? _self.important : important // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
