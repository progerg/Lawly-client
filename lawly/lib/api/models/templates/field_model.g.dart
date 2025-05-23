// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldModel _$FieldModelFromJson(Map<String, dynamic> json) => FieldModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      canImproveAi: json['can_improve_ai'] as bool,
      example: json['example'] as String?,
      mask: json['mask'] as String?,
      nameRu: json['name_ru'] as String?,
      filterField: (json['filter_field'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      value: json['value'] as String?,
    );

Map<String, dynamic> _$FieldModelToJson(FieldModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mask': instance.mask,
      'example': instance.example,
      'value': instance.value,
      'name_ru': instance.nameRu,
      'can_improve_ai': instance.canImproveAi,
      'filter_field': instance.filterField,
    };
