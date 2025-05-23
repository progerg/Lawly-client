import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';

part 'local_template_model.g.dart';

@JsonSerializable()
class LocalTemplateModel extends LocalTemplateEntity {
  @JsonKey(name: 'template_id')
  final int templateId;

  @JsonKey(name: 'file_path')
  final String filePath;

  @JsonKey(name: 'is_empty')
  final bool isEmpty;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  LocalTemplateModel({
    required this.templateId,
    required super.name,
    required this.filePath,
    required this.isEmpty,
    this.imageUrl,
  }) : super(
          templateId: templateId,
          filePath: filePath,
          imageUrl: imageUrl,
          isEmpty: isEmpty,
        );

  factory LocalTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$LocalTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalTemplateModelToJson(this);

  factory LocalTemplateModel.fromEntity(LocalTemplateEntity entity) {
    return LocalTemplateModel(
      templateId: entity.templateId,
      name: entity.name,
      filePath: entity.filePath,
      isEmpty: entity.isEmpty,
      imageUrl: entity.imageUrl,
    );
  }
}
