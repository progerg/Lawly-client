// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldModel _$FieldModelFromJson(Map<String, dynamic> json) => FieldModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      nameRu: json['name_ru'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$FieldModelToJson(FieldModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'name_ru': instance.nameRu,
    };
