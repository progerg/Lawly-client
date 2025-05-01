// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorized_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizedUserModel _$AuthorizedUserModelFromJson(Map<String, dynamic> json) =>
    AuthorizedUserModel(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceId: json['device_id'] as String,
      deviceOs: json['device_os'] as String,
      deviceName: json['device_name'] as String,
      name: json['name'] as String?,
      agreeToTerms: json['agree_to_terms'] as bool? ?? true,
    );

Map<String, dynamic> _$AuthorizedUserModelToJson(
        AuthorizedUserModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'device_id': instance.deviceId,
      'device_os': instance.deviceOs,
      'device_name': instance.deviceName,
      'agree_to_terms': instance.agreeToTerms,
    };
