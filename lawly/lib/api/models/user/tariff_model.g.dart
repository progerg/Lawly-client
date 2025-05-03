// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TariffModel _$TariffModelFromJson(Map<String, dynamic> json) => TariffModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? _defaultDescription,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          _defaultFeatures,
      price: (json['price'] as num).toDouble(),
      consultationCount: (json['consultations_count'] as num?)?.toInt() ??
          _defaultConsultationCount,
      aiAccess: json['ai_access'] as bool? ?? _defaultAiAccess,
      customTemplates:
          json['custom_templates'] as bool? ?? _defaultCustomTemplates,
      unlimitedDocs: json['unlimited_docs'] as bool? ?? _defaultUnlimitedDocs,
    );

Map<String, dynamic> _$TariffModelToJson(TariffModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'features': instance.features,
      'consultations_count': instance.consultationCount,
      'ai_access': instance.aiAccess,
      'custom_templates': instance.customTemplates,
      'unlimited_docs': instance.unlimitedDocs,
    };
