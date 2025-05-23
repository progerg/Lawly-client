import 'package:elementary/elementary.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';
import 'package:lawly/features/templates/service/template_service.dart';

class CustomTemplateScreenModel extends ElementaryModel {
  final TemplateService _templateService;
  final SaveUserService _saveUserService;

  CustomTemplateScreenModel({
    required TemplateService templateService,
    required SaveUserService saveUserService,
  })  : _templateService = templateService,
        _saveUserService = saveUserService;

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

  Future<void> saveLocalTemplates({
    required LocalTemplateEntity template,
  }) async {
    return await _saveUserService.saveLocalTemplates(template: template);
  }
}
