// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
ServiceCredential _$ServiceCredentialFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'apiKey':
          return ApiKeyCredential.fromJson(
            json
          );
                case 'usernamePassword':
          return UsernamePasswordCredential.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ServiceCredential',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ServiceCredential {



  /// Serializes this ServiceCredential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCredential);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServiceCredential()';
}


}

/// @nodoc
class $ServiceCredentialCopyWith<$Res>  {
$ServiceCredentialCopyWith(ServiceCredential _, $Res Function(ServiceCredential) __);
}


/// Adds pattern-matching-related methods to [ServiceCredential].
extension ServiceCredentialPatterns on ServiceCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiKeyCredential value)?  apiKey,TResult Function( UsernamePasswordCredential value)?  usernamePassword,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiKeyCredential() when apiKey != null:
return apiKey(_that);case UsernamePasswordCredential() when usernamePassword != null:
return usernamePassword(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiKeyCredential value)  apiKey,required TResult Function( UsernamePasswordCredential value)  usernamePassword,}){
final _that = this;
switch (_that) {
case ApiKeyCredential():
return apiKey(_that);case UsernamePasswordCredential():
return usernamePassword(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiKeyCredential value)?  apiKey,TResult? Function( UsernamePasswordCredential value)?  usernamePassword,}){
final _that = this;
switch (_that) {
case ApiKeyCredential() when apiKey != null:
return apiKey(_that);case UsernamePasswordCredential() when usernamePassword != null:
return usernamePassword(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String apiKey)?  apiKey,TResult Function( String username,  String password)?  usernamePassword,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiKeyCredential() when apiKey != null:
return apiKey(_that.apiKey);case UsernamePasswordCredential() when usernamePassword != null:
return usernamePassword(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String apiKey)  apiKey,required TResult Function( String username,  String password)  usernamePassword,}) {final _that = this;
switch (_that) {
case ApiKeyCredential():
return apiKey(_that.apiKey);case UsernamePasswordCredential():
return usernamePassword(_that.username,_that.password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String apiKey)?  apiKey,TResult? Function( String username,  String password)?  usernamePassword,}) {final _that = this;
switch (_that) {
case ApiKeyCredential() when apiKey != null:
return apiKey(_that.apiKey);case UsernamePasswordCredential() when usernamePassword != null:
return usernamePassword(_that.username,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ApiKeyCredential implements ServiceCredential {
  const ApiKeyCredential(this.apiKey, { String? $type}): $type = $type ?? 'apiKey';
  factory ApiKeyCredential.fromJson(Map<String, dynamic> json) => _$ApiKeyCredentialFromJson(json);

 final  String apiKey;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ServiceCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiKeyCredentialCopyWith<ApiKeyCredential> get copyWith => _$ApiKeyCredentialCopyWithImpl<ApiKeyCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiKeyCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiKeyCredential&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,apiKey);

@override
String toString() {
  return 'ServiceCredential.apiKey(apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class $ApiKeyCredentialCopyWith<$Res> implements $ServiceCredentialCopyWith<$Res> {
  factory $ApiKeyCredentialCopyWith(ApiKeyCredential value, $Res Function(ApiKeyCredential) _then) = _$ApiKeyCredentialCopyWithImpl;
@useResult
$Res call({
 String apiKey
});




}
/// @nodoc
class _$ApiKeyCredentialCopyWithImpl<$Res>
    implements $ApiKeyCredentialCopyWith<$Res> {
  _$ApiKeyCredentialCopyWithImpl(this._self, this._then);

  final ApiKeyCredential _self;
  final $Res Function(ApiKeyCredential) _then;

/// Create a copy of ServiceCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? apiKey = null,}) {
  return _then(ApiKeyCredential(
null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UsernamePasswordCredential implements ServiceCredential {
  const UsernamePasswordCredential({required this.username, required this.password,  String? $type}): $type = $type ?? 'usernamePassword';
  factory UsernamePasswordCredential.fromJson(Map<String, dynamic> json) => _$UsernamePasswordCredentialFromJson(json);

 final  String username;
 final  String password;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ServiceCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernamePasswordCredentialCopyWith<UsernamePasswordCredential> get copyWith => _$UsernamePasswordCredentialCopyWithImpl<UsernamePasswordCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsernamePasswordCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernamePasswordCredential&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'ServiceCredential.usernamePassword(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class $UsernamePasswordCredentialCopyWith<$Res> implements $ServiceCredentialCopyWith<$Res> {
  factory $UsernamePasswordCredentialCopyWith(UsernamePasswordCredential value, $Res Function(UsernamePasswordCredential) _then) = _$UsernamePasswordCredentialCopyWithImpl;
@useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class _$UsernamePasswordCredentialCopyWithImpl<$Res>
    implements $UsernamePasswordCredentialCopyWith<$Res> {
  _$UsernamePasswordCredentialCopyWithImpl(this._self, this._then);

  final UsernamePasswordCredential _self;
  final $Res Function(UsernamePasswordCredential) _then;

/// Create a copy of ServiceCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,}) {
  return _then(UsernamePasswordCredential(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
