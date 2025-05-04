import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';

abstract class ISaveUserRepository {
  Future<void> saveAuthUser({required AuthorizedUserEntity entity});

  AuthorizedUserEntity? getAuthUser();

  Future<void> savePersonalDocuments({required List<DocEntity> documents});

  List<DocEntity> getPersonalDocuments();
}

class SaveUserRepository implements ISaveUserRepository {
  final SaveUserLocalDataSource _saveUserLocalDataSource;

  SaveUserRepository({required SaveUserLocalDataSource saveUserLocalDataSource})
      : _saveUserLocalDataSource = saveUserLocalDataSource;

  @override
  Future<void> saveAuthUser({required AuthorizedUserEntity entity}) async {
    return await _saveUserLocalDataSource.saveAuthUser(model: entity.toModel());
  }

  @override
  AuthorizedUserEntity? getAuthUser() {
    return _saveUserLocalDataSource.getAuthUser();
  }

  @override
  List<DocEntity> getPersonalDocuments() {
    return _saveUserLocalDataSource.getPersonalDocuments();
  }

  @override
  Future<void> savePersonalDocuments({
    required List<DocEntity> documents,
  }) async {
    final documentModels =
        documents.map((doc) => DocModel.fromEntity(doc)).toList();
    return await _saveUserLocalDataSource.savePersonalDocuments(
        documents: documentModels);
  }
}
