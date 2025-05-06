import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/api/models/templates/template_model.dart';
import 'package:lawly/features/templates/domain/entity/total_templates_entity.dart';

part 'total_templates_model.g.dart';

@JsonSerializable()
class TotalTemplatesModel extends TotalTemplatesEntity {
  final List<TemplateModel> templates;

  TotalTemplatesModel({
    required super.total,
    required this.templates,
  }) : super(
          templates: templates,
        );

  factory TotalTemplatesModel.fromJson(Map<String, dynamic> json) =>
      _$TotalTemplatesModelFromJson(json);
}
