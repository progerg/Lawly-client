import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/repository/personal_documents_repository.dart';

class PersonalDocumentsService {
  final IPersonalDocumentsRepository _repository;

  PersonalDocumentsService({
    required IPersonalDocumentsRepository repository,
  }) : _repository = repository;

  Future<List<DocEntity>> getPersonalDocuments() async {
    return await _repository.getPersonalDocuments();
  }

  Future<DocEntity> getPersonalDocumentById({required int id}) async {
    return await _repository.getPersonalDocumentById(id: id);
  }
}
