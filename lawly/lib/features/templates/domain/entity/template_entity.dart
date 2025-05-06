import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';

class TemplateEntity {
  final int id;
  final int? userId;
  final String name;
  final String nameRu;
  final String description;
  final String imageUrl;
  final String downloadUrl;
  final List<DocEntity>? requiredDocuments;
  final List<FieldEntity>? customFields;

  TemplateEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.nameRu,
    required this.description,
    required this.imageUrl,
    required this.downloadUrl,
    this.requiredDocuments,
    this.customFields,
  });
}
