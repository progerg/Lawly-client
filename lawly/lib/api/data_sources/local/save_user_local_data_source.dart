import 'dart:convert';

import 'package:lawly/api/models/auth/authorized_user_model.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserLocalDataSource {
  final SharedPreferences _prefs;

  SaveUserLocalDataSource({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static const String authUserKey = 'user-json';

  Future<void> saveAuthUser({required AuthorizedUserEntity entity}) async {
    final model = entity.toModel();

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
}
