import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';

part 'field_model.g.dart';

@JsonSerializable()
class FieldModel extends FieldEntity {
  @JsonKey(name: 'name_ru')
  final String? nameRu;

  @JsonKey(name: 'can_improve_ai')
  final bool canImproveAi;

  @JsonKey(name: 'filter_field')
  final Map<String, String>? filterField;

  FieldModel({
    required super.id,
    required super.name,
    required this.canImproveAi,
    super.example,
    super.mask,
    this.nameRu,
    this.filterField,
    super.value,
  }) : super(
          nameRu: nameRu,
          filterField: filterField,
          canImproveAi: canImproveAi,
        );

  factory FieldModel.fromJson(Map<String, dynamic> json) =>
      _$FieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FieldModelToJson(this);

  factory FieldModel.fromEntity(FieldEntity entity) {
    return FieldModel(
      id: entity.id,
      name: entity.name,
      nameRu: entity.nameRu,
      mask: entity.mask,
      example: entity.example,
      filterField: entity.filterField,
      canImproveAi: entity.canImproveAi,
      value: entity.value,
    );
  }
}
