import 'package:lawly/api/data_sources/remote/user_service/documents_remote_data_source.dart';
import 'package:lawly/features/auth/domain/entities/privacy_policy_entity.dart';

abstract class IDocumentsRepository {
  Future<PrivacyPolicyEntity> getPrivacyPolicy();
}

class DocumentsRepository implements IDocumentsRepository {
  final DocumentsRemoteDataSource _documentsRemoteDataSource;

  DocumentsRepository({
    required DocumentsRemoteDataSource documentsRemoteDataSource,
  }) : _documentsRemoteDataSource = documentsRemoteDataSource;

  @override
  Future<PrivacyPolicyEntity> getPrivacyPolicy() async {
    return await _documentsRemoteDataSource.getPrivacyPolicy();
  }
}
