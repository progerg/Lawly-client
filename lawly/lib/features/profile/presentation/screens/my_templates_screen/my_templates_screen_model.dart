import 'package:elementary/elementary.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';

class MyTemplatesScreenModel extends ElementaryModel {
  final SaveUserService _saveUserService;

  MyTemplatesScreenModel({
    required SaveUserService saveUserService,
  }) : _saveUserService = saveUserService;

  Future<List<LocalTemplateEntity>> getMyTemplates() async {
    return await _saveUserService.getLocalTemplates();
  }

  Future<void> removeLocalTemplate({required int id}) async {
    await _saveUserService.removeLocalTemplate(id: id);
  }
}
