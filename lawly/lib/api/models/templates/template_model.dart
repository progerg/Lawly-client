import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/api/models/templates/field_model.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';

part 'template_model.g.dart';

@JsonSerializable()
class TemplateModel extends TemplateEntity {
  @JsonKey(name: 'name_ru')
  final String nameRu;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'download_url')
  final String downloadUrl;

  @JsonKey(name: 'required_documents')
  final List<DocModel>? requiredDocuments;

  @JsonKey(name: 'custom_fields')
  final List<FieldModel>? customFields;

  TemplateModel({
    required super.id,
    this.userId,
    required super.name,
    required this.nameRu,
    required super.description,
    required this.imageUrl,
    required this.downloadUrl,
    this.requiredDocuments,
    this.customFields,
  }) : super(
          nameRu: nameRu,
          userId: userId,
          imageUrl: imageUrl,
          downloadUrl: downloadUrl,
        );

  factory TemplateModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateModelFromJson(json);
}
