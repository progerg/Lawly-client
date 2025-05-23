import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

/// Модель ответа сервера.
@JsonSerializable(genericArgumentFactories: true)
class ResponseModel<T> {
  /// Код статуса.
  final int status;

  /// Данные.
  final T data;

  /// Ошибки.
  final List<Object>? errors;

  /// Доп сообщения
  final List<Object> messages;

  /// Конструктор.
  ResponseModel({
    required this.status,
    required this.data,
    this.errors = const <Object>[],
    this.messages = const <Object>[],
  });

  /// Фабрика из json.
  factory ResponseModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) dataFromJson) =>
      _$ResponseModelFromJson(json, dataFromJson);
}
