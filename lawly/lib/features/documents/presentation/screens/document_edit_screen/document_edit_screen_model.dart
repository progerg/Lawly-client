import 'package:elementary/elementary.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/service/personal_documents_service.dart';

class DocumentEditScreenModel extends ElementaryModel {
  final SaveUserService saveUserService;
  final PersonalDocumentsService _personalDocumentsService;

  DocumentEditScreenModel({
    required this.saveUserService,
    required PersonalDocumentsService personalDocumentsService,
  }) : _personalDocumentsService = personalDocumentsService;

  Future<DocEntity> getPersonalDocumentById({required int id}) async {
    return await _personalDocumentsService.getPersonalDocumentById(id: id);
  }
}
