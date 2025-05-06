import 'package:elementary/elementary.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/service/personal_documents_service.dart';

class DocumentsScreenModel extends ElementaryModel {
  final SaveUserService saveUserService;
  final PersonalDocumentsService _personalDocumentsService;

  DocumentsScreenModel({
    required this.saveUserService,
    required PersonalDocumentsService personalDocumentsService,
  }) : _personalDocumentsService = personalDocumentsService;

  Future<List<DocEntity>> getPersonalDocuments() async {
    return await _personalDocumentsService.getPersonalDocuments();
  }
}
