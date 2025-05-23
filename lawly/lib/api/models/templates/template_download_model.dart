import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/templates/domain/entity/template_download_entity.dart';

part 'template_download_model.g.dart';

@JsonSerializable()
class TemplateDownloadModel extends TemplateDownloadEntity {
  @JsonKey(name: 'download_url')
  final String downloadUrl;

  TemplateDownloadModel({required this.downloadUrl})
      : super(downloadUrl: downloadUrl);

  factory TemplateDownloadModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateDownloadModelFromJson(json);
}
