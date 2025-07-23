// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
    };

UploadPhotoResponse _$UploadPhotoResponseFromJson(Map<String, dynamic> json) =>
    UploadPhotoResponse(
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$UploadPhotoResponseToJson(
        UploadPhotoResponse instance) =>
    <String, dynamic>{
      'photoUrl': instance.photoUrl,
    };
