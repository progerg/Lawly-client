import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

class SaveUserService {
  final SaveUserLocalDataSource _saveUserLocalDataSource;

  SaveUserService({required SaveUserLocalDataSource saveUserLocalDataSource})
      : _saveUserLocalDataSource = saveUserLocalDataSource;

  Future<void> saveAuthUser({required AuthorizedUserEntity entity}) async {
    return await _saveUserLocalDataSource.saveAuthUser(entity: entity);
  }

  AuthorizedUserEntity? getAuthUser() {
    return _saveUserLocalDataSource.getAuthUser();
  }
}
