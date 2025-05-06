import 'package:lawly/features/auth/repository/save_user_repository.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';

class SaveUserService {
  final ISaveUserRepository _saveUserRepository;

  SaveUserService({required ISaveUserRepository saveUserRepository})
      : _saveUserRepository = saveUserRepository;

  Future<void> saveAuthUser({required AuthorizedUserEntity entity}) async {
    return await _saveUserRepository.saveAuthUser(entity: entity);
  }

  AuthorizedUserEntity? getAuthUser() {
    return _saveUserRepository.getAuthUser();
  }

  Future<void> savePersonalDocuments({
    required List<DocEntity> documents,
  }) async {
    return await _saveUserRepository.savePersonalDocuments(
        documents: documents);
  }

  List<DocEntity> getPersonalDocuments() {
    return _saveUserRepository.getPersonalDocuments();
  }
}
