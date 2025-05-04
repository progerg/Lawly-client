import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/api/models/templates/field_model.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';

part 'doc_model.g.dart';

/// Модель документа пользователя (Паспорт, СНИЛС и т.д.)
@JsonSerializable()
class DocModel extends DocEntity {
  @JsonKey(name: 'name_ru')
  final String nameRu;

  final List<FieldModel>? fields;

  DocModel({
    required super.id,
    required super.name,
    required this.nameRu,
    required super.description,
    this.fields,
    super.link,
  }) : super(
          nameRu: nameRu,
          fields: fields,
        );

  factory DocModel.fromJson(Map<String, dynamic> json) =>
      _$DocModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocModelToJson(this);

  factory DocModel.fromEntity(DocEntity entity) {
    return DocModel(
      id: entity.id,
      name: entity.name,
      nameRu: entity.nameRu,
      description: entity.description,
      fields:
          entity.fields?.map((field) => FieldModel.fromEntity(field)).toList(),
      link: entity.link,
    );
  }
}
