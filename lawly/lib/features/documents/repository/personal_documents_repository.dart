import 'package:lawly/api/data_sources/remote/doc_service/templates_remote_data_source.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';

abstract class IPersonalDocumentsRepository {
  Future<List<DocEntity>> getPersonalDocuments();

  Future<DocEntity> getPersonalDocumentById({required int id});
}

class PersonalDocumentsRepository implements IPersonalDocumentsRepository {
  final TemplatesRemoteDataSource _templatesRemoteDataSource;

  PersonalDocumentsRepository({
    required TemplatesRemoteDataSource templatesRemoteDataSource,
  }) : _templatesRemoteDataSource = templatesRemoteDataSource;

  @override
  Future<DocEntity> getPersonalDocumentById({required int id}) async {
    return await _templatesRemoteDataSource.getDocumentStructure(
      documentId: id,
    );
  }

  @override
  Future<List<DocEntity>> getPersonalDocuments() async {
    return await _templatesRemoteDataSource.getDocuments();
  }
}
