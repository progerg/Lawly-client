// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocModel _$DocModelFromJson(Map<String, dynamic> json) => DocModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameRu: json['name_ru'] as String,
      description: json['description'] as String,
      isPersonal: json['is_personal'] as bool,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => FieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      link: json['link'] as String?,
    );

Map<String, dynamic> _$DocModelToJson(DocModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'link': instance.link,
      'description': instance.description,
      'name_ru': instance.nameRu,
      'fields': instance.fields,
      'is_personal': instance.isPersonal,
    };
