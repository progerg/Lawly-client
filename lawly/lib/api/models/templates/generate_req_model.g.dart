// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_req_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilledFieldModel _$FilledFieldModelFromJson(Map<String, dynamic> json) =>
    FilledFieldModel(
      name: json['name'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$FilledFieldModelToJson(FilledFieldModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

GenerateReqModel _$GenerateReqModelFromJson(Map<String, dynamic> json) =>
    GenerateReqModel(
      templateId: (json['template_id'] as num).toInt(),
      fields: (json['fields'] as List<dynamic>)
          .map((e) => FilledFieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenerateReqModelToJson(GenerateReqModel instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };
