import 'dart:convert';

import 'package:lawly/api/models/auth/authorized_user_model.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserLocalDataSource {
  final SharedPreferences _prefs;

  SaveUserLocalDataSource({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static const String authUserKey = 'user-json';

  static const String personalDocumentsKey = 'personal-documents';

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
}
