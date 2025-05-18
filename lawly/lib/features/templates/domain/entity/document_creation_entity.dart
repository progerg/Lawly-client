import 'package:lawly/api/models/templates/document_creation_model.dart';

class DocumentCreationEntity {
  final int id;
  final String customName;
  final int userId;
  final int templateId;
  final DocumentCreationStatus status;
  final String startDate;
  final String? endDate;
  final String? errorMessage;

  const DocumentCreationEntity({
    required this.id,
    required this.customName,
    required this.userId,
    required this.templateId,
    required this.status,
    required this.startDate,
    this.endDate,
    this.errorMessage,
  });
}
