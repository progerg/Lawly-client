import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';

part 'field_model.g.dart';

@JsonSerializable()
class FieldModel extends FieldEntity {
  @JsonKey(name: 'name_ru')
  final String? nameRu;

  FieldModel({
    required super.id,
    required super.name,
    required super.type,
    this.nameRu,
    super.value,
  }) : super(
          nameRu: nameRu,
        );

  factory FieldModel.fromJson(Map<String, dynamic> json) =>
      _$FieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FieldModelToJson(this);

  factory FieldModel.fromEntity(FieldEntity entity) {
    return FieldModel(
      id: entity.id,
      name: entity.name,
      nameRu: entity.nameRu,
      type: entity.type,
      value: entity.value,
    );
  }
}
