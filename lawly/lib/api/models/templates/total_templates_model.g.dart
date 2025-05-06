// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_templates_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalTemplatesModel _$TotalTemplatesModelFromJson(Map<String, dynamic> json) =>
    TotalTemplatesModel(
      total: (json['total'] as num).toInt(),
      templates: (json['templates'] as List<dynamic>)
          .map((e) => TemplateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TotalTemplatesModelToJson(
        TotalTemplatesModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'templates': instance.templates,
    };
