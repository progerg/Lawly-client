// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      email: json['email'] as String?,
      name: json['name'] as String?,
      userId: (json['user_id'] as num).toInt(),
      tariff: TariffModel.fromJson(json['tariff'] as Map<String, dynamic>),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'user_id': instance.userId,
      'tariff': instance.tariff,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };
