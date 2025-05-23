import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/api/models/templates/local_template_model.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';

abstract class ISaveUserRepository {
  Future<void> saveAuthUser({required AuthorizedUserEntity entity});

  AuthorizedUserEntity? getAuthUser();

  Future<void> savePersonalDocuments({required List<DocEntity> documents});

  List<DocEntity> getPersonalDocuments();

  Future<void> saveUserAvatarPath(String path);

  Future<String?> getUserAvatarPath();

  Future<void> saveLocalTemplates({
    required LocalTemplateEntity template,
  });

  Future<List<LocalTemplateEntity>> getLocalTemplates();

  Future<void> removeLocalTemplate({required int id});
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

  @override
  Future<List<LocalTemplateEntity>> getLocalTemplates() async {
    return _saveUserLocalDataSource.getLocalTemplates();
  }

  @override
  Future<void> saveLocalTemplates({
    required LocalTemplateEntity template,
  }) async {
    return await _saveUserLocalDataSource.saveLocalTemplates(
      template: LocalTemplateModel.fromEntity(template),
    );
  }

  @override
  Future<void> removeLocalTemplate({required int id}) async {
    return await _saveUserLocalDataSource.removeLocalTemplate(id);
  }

  @override
  Future<void> saveUserAvatarPath(String path) async {
    await _saveUserLocalDataSource.saveUserAvatarPath(path);
  }

  @override
  Future<String?> getUserAvatarPath() async {
    return _saveUserLocalDataSource.getUserAvatarPath();
  }
}
