import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';

part 'improve_text_model.g.dart';

@JsonSerializable()
class ImproveTextModel extends ImproveTextEntity {
  @JsonKey(name: 'improved_text')
  final String improvedText;

  ImproveTextModel({required this.improvedText})
      : super(improvedText: improvedText);

  factory ImproveTextModel.fromJson(Map<String, dynamic> json) =>
      _$ImproveTextModelFromJson(json);
}
