// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalMessagesModel _$TotalMessagesModelFromJson(Map<String, dynamic> json) =>
    TotalMessagesModel(
      total: (json['total'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TotalMessagesModelToJson(TotalMessagesModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'has_more': instance.hasMore,
      'messages': instance.messages,
    };
