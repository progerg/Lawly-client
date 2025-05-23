import 'dart:convert';

import 'package:lawly/api/models/auth/authorized_user_model.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/api/models/templates/local_template_model.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserLocalDataSource {
  final SharedPreferences _prefs;

  SaveUserLocalDataSource({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static const String authUserKey = 'user-json';

  static const String personalDocumentsKey = 'personal-documents';

  static const String userAvatarPathKey = 'user-avatar-path';

  static const String localTemplatesKey = 'local-templates';

  Future<void> saveAuthUser({required AuthorizedUserModel model}) async {
    final data = json.encode(model.toJson());

    await _prefs.setString(authUserKey, data);
  }

  AuthorizedUserEntity? getAuthUser() {
    final userDataString = _prefs.getString(authUserKey);

    if (userDataString != null) {
      final dataMap = json.decode(userDataString);

      return AuthorizedUserModel.fromJson(dataMap);
    }
    return null;
  }

  Future<void> savePersonalDocuments({
    required List<DocModel> documents,
  }) async {
    final data = json.encode(documents.map((e) => e.toJson()).toList());

    await _prefs.setString(personalDocumentsKey, data);
  }

  List<DocModel> getPersonalDocuments() {
    final documentsString = _prefs.getString(personalDocumentsKey);

    if (documentsString != null) {
      final dataList = json.decode(documentsString) as List;

      return dataList
          .map((e) => DocModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> saveLocalTemplates({
    required LocalTemplateModel template,
  }) async {
    final templates = await getLocalTemplates();

    if (templates.any((element) => template.templateId == element.templateId)) {
      return; // чтобы не добавлять одинаковые шаблоны
    }

    templates.add(template);

    final data = json.encode(templates.map((e) => e.toJson()).toList());

    await _prefs.setString(localTemplatesKey, data);
  }

  Future<List<LocalTemplateModel>> getLocalTemplates() async {
    final templatesString = _prefs.getString(localTemplatesKey);

    if (templatesString != null) {
      final dataList = json.decode(templatesString) as List;

      return dataList
          .map((e) => LocalTemplateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> removeLocalTemplate(int id) async {
    final templates = await getLocalTemplates();

    templates.removeWhere((element) => element.templateId == id);

    final data = json.encode(templates.map((e) => e.toJson()).toList());

    await _prefs.setString(localTemplatesKey, data);
  }

  Future<void> saveUserAvatarPath(String path) async {
    await _prefs.setString(userAvatarPathKey, path);
  }

  Future<String?> getUserAvatarPath() async {
    return _prefs.getString(userAvatarPathKey);
  }

  Future<void> clearUserData() async {
    await _prefs.remove(personalDocumentsKey);
    await _prefs.remove(userAvatarPathKey);
    await _prefs.remove(localTemplatesKey);
  }
}
