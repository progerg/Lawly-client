import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/templates/domain/entity/document_creation_entity.dart';

part 'document_creation_model.g.dart';

@JsonSerializable()
class DocumentCreationModel extends DocumentCreationEntity {
  @JsonKey(name: 'custom_name')
  final String customName;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'template_id')
  final int templateId;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'error_message')
  final String? errorMessage;

  DocumentCreationModel({
    required super.id,
    required this.customName,
    required this.userId,
    required this.templateId,
    required super.status,
    required this.startDate,
    this.endDate,
    this.errorMessage,
  }) : super(
          customName: customName,
          userId: userId,
          templateId: templateId,
          startDate: startDate,
          endDate: endDate,
          errorMessage: errorMessage,
        );

  factory DocumentCreationModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentCreationModelFromJson(json);
}
