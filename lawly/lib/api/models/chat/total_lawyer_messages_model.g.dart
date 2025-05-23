// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_lawyer_messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalLawyerMessagesModel _$TotalLawyerMessagesModelFromJson(
        Map<String, dynamic> json) =>
    TotalLawyerMessagesModel(
      total: (json['total'] as num).toInt(),
      responses: (json['responses'] as List<dynamic>)
          .map((e) => LawyerMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TotalLawyerMessagesModelToJson(
        TotalLawyerMessagesModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'responses': instance.responses,
    };
