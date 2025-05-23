// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: (json['id'] as num).toInt(),
      senderType: json['sender_type'] as String,
      senderId: (json['sender_id'] as num?)?.toInt(),
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'status': instance.status,
      'sender_type': instance.senderType,
      'sender_id': instance.senderId,
      'created_at': instance.createdAt,
    };
