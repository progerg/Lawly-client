import 'package:elementary/elementary.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';
import 'package:lawly/features/templates/service/template_service.dart';

class CustomTemplateScreenModel extends ElementaryModel {
  final TemplateService _templateService;

  CustomTemplateScreenModel({
    required TemplateService templateService,
  }) : _templateService = templateService;

  Future<List<int>> customTemplate({
    String? description,
  }) async {
    return await _templateService.customTemplate(
      description: description,
    );
  }

  Future<ImproveTextEntity> improveText({
    required String text,
  }) async {
    return await _templateService.improveText(
      text: text,
    );
  }
}
