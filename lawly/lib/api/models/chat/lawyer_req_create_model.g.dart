// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lawyer_req_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LawyerReqCreateModel _$LawyerReqCreateModelFromJson(
        Map<String, dynamic> json) =>
    LawyerReqCreateModel(
      description: json['description'] as String,
      documentBytes: (json['document_bytes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$LawyerReqCreateModelToJson(
        LawyerReqCreateModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'document_bytes': instance.documentBytes,
    };
