// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateModel _$TemplateModelFromJson(Map<String, dynamic> json) =>
    TemplateModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String,
      nameRu: json['name_ru'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      downloadUrl: json['download_url'] as String,
      requiredDocuments: (json['required_documents'] as List<dynamic>?)
          ?.map((e) => DocModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customFields: (json['custom_fields'] as List<dynamic>?)
          ?.map((e) => FieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplateModelToJson(TemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'name_ru': instance.nameRu,
      'user_id': instance.userId,
      'image_url': instance.imageUrl,
      'download_url': instance.downloadUrl,
      'required_documents': instance.requiredDocuments,
      'custom_fields': instance.customFields,
    };
