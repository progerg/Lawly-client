import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/templates/domain/entity/generate_req_entity.dart';

part 'generate_req_model.g.dart';

@JsonSerializable()
class FilledFieldModel extends FilledFieldEntity {
  FilledFieldModel({
    required super.name,
    required super.value,
  });

  factory FilledFieldModel.fromJson(Map<String, dynamic> json) =>
      _$FilledFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilledFieldModelToJson(this);

  factory FilledFieldModel.fromEntity(FilledFieldEntity entity) {
    return FilledFieldModel(
      name: entity.name,
      value: entity.value,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GenerateReqModel extends GenerateReqEntity {
  @JsonKey(name: 'template_id')
  final int templateId;

  final List<FilledFieldModel> fields;

  GenerateReqModel({
    required this.templateId,
    required this.fields,
  }) : super(
          templateId: templateId,
          fields: fields,
        );

  factory GenerateReqModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateReqModelToJson(this);

  factory GenerateReqModel.fromEntity(GenerateReqEntity entity) {
    return GenerateReqModel(
      templateId: entity.templateId,
      fields: entity.fields
          .map((field) => FilledFieldModel.fromEntity(field))
          .toList(),
    );
  }
}
