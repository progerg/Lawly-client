// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalTemplateModel _$LocalTemplateModelFromJson(Map<String, dynamic> json) =>
    LocalTemplateModel(
      templateId: (json['template_id'] as num).toInt(),
      name: json['name'] as String,
      filePath: json['file_path'] as String,
      isEmpty: json['is_empty'] as bool,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$LocalTemplateModelToJson(LocalTemplateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'template_id': instance.templateId,
      'file_path': instance.filePath,
      'is_empty': instance.isEmpty,
      'image_url': instance.imageUrl,
    };
