// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lawyer_req_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LawyerReqResponseModel _$LawyerReqResponseModelFromJson(
        Map<String, dynamic> json) =>
    LawyerReqResponseModel(
      id: (json['id'] as num).toInt(),
      status: $enumDecode(_$LawyerReqResponseStatusEnumMap, json['status']),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$LawyerReqResponseModelToJson(
        LawyerReqResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'status': _$LawyerReqResponseStatusEnumMap[instance.status]!,
    };

const _$LawyerReqResponseStatusEnumMap = {
  LawyerReqResponseStatus.started: 'pending',
  LawyerReqResponseStatus.completed: 'completed',
  LawyerReqResponseStatus.processing: 'processing',
};
