// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lawyer_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LawyerMessageModel _$LawyerMessageModelFromJson(Map<String, dynamic> json) =>
    LawyerMessageModel(
      messageId: (json['message_id'] as num).toInt(),
      note: json['note'] as String,
      hasFile: json['has_file'] as bool,
    );

Map<String, dynamic> _$LawyerMessageModelToJson(LawyerMessageModel instance) =>
    <String, dynamic>{
      'note': instance.note,
      'message_id': instance.messageId,
      'has_file': instance.hasFile,
    };
