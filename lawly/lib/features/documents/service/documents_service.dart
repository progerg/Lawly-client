import 'package:lawly/features/auth/domain/entities/privacy_policy_entity.dart';
import 'package:lawly/features/documents/repository/documents_repository.dart';

class DocumentsService {
  final DocumentsRepository _documentsRepository;

  DocumentsService({required DocumentsRepository documentsRepository})
      : _documentsRepository = documentsRepository;

  Future<PrivacyPolicyEntity> getPrivacyPolicy() async {
    return await _documentsRepository.getPrivacyPolicy();
  }
}
