// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_creation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentCreationModel _$DocumentCreationModelFromJson(
        Map<String, dynamic> json) =>
    DocumentCreationModel(
      id: (json['id'] as num).toInt(),
      customName: json['custom_name'] as String,
      userId: (json['user_id'] as num).toInt(),
      templateId: (json['template_id'] as num).toInt(),
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$DocumentCreationModelToJson(
        DocumentCreationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'custom_name': instance.customName,
      'user_id': instance.userId,
      'template_id': instance.templateId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'error_message': instance.errorMessage,
    };
