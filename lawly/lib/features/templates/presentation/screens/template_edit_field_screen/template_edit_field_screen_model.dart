import 'package:elementary/elementary.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';
import 'package:lawly/features/templates/service/template_service.dart';

class TemplateEditFieldScreenModel extends ElementaryModel {
  final TemplateService _templateService;

  TemplateEditFieldScreenModel({
    required TemplateService templateService,
  }) : _templateService = templateService;

  Future<ImproveTextEntity> improveText({required String text}) async {
    return await _templateService.improveText(text: text);
  }
}
