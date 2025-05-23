// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel<T> _$ResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ResponseModel<T>(
      status: (json['status'] as num).toInt(),
      data: fromJsonT(json['data']),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          const <Object>[],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          const <Object>[],
    );

Map<String, dynamic> _$ResponseModelToJson<T>(
  ResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'data': toJsonT(instance.data),
      'errors': instance.errors,
      'messages': instance.messages,
    };
