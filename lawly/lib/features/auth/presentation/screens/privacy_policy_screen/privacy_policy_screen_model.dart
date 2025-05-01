import 'package:elementary/elementary.dart';
import 'package:lawly/features/auth/domain/entities/privacy_policy_entity.dart';
import 'package:lawly/features/documents/service/documents_service.dart';

class PrivacyPolicyScreenModel extends ElementaryModel {
  final DocumentsService _documentsService;

  PrivacyPolicyScreenModel({
    required DocumentsService documentsService,
  }) : _documentsService = documentsService;

  Future<PrivacyPolicyEntity> getPrivacyPolicy() =>
      _documentsService.getPrivacyPolicy();
}
