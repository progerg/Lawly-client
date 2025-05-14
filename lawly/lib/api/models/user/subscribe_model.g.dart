// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeModel _$SubscribeModelFromJson(Map<String, dynamic> json) =>
    SubscribeModel(
      tariff: TariffModel.fromJson(json['tariff'] as Map<String, dynamic>),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      countLawyers: (json['count_lawyers'] as num).toInt(),
      consultationsTotal: (json['consultations_total'] as num).toInt(),
      consultationsUsed: (json['consultations_used'] as num).toInt(),
      canUserAi: json['can_user_ai'] as bool,
      canCreateCustomTemplates: json['can_create_custom_templates'] as bool,
      unlimitedDocuments: json['unlimited_documents'] as bool,
    );

Map<String, dynamic> _$SubscribeModelToJson(SubscribeModel instance) =>
    <String, dynamic>{
      'tariff': instance.tariff,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'count_lawyers': instance.countLawyers,
      'consultations_total': instance.consultationsTotal,
      'consultations_used': instance.consultationsUsed,
      'can_user_ai': instance.canUserAi,
      'can_create_custom_templates': instance.canCreateCustomTemplates,
      'unlimited_documents': instance.unlimitedDocuments,
    };
