// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKeyCredential _$ApiKeyCredentialFromJson(Map<String, dynamic> json) =>
    ApiKeyCredential(
      json['apiKey'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ApiKeyCredentialToJson(ApiKeyCredential instance) =>
    <String, dynamic>{'apiKey': instance.apiKey, 'runtimeType': instance.$type};

UsernamePasswordCredential _$UsernamePasswordCredentialFromJson(
  Map<String, dynamic> json,
) => UsernamePasswordCredential(
  username: json['username'] as String,
  password: json['password'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UsernamePasswordCredentialToJson(
  UsernamePasswordCredential instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'runtimeType': instance.$type,
};
