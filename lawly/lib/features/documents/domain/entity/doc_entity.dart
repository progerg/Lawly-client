import 'package:lawly/features/documents/domain/entity/field_entity.dart';

class DocEntity {
  final int id;
  final String name;
  final String nameRu;
  final String? link;
  final bool isPersonal;
  final String description;
  final List<FieldEntity>? fields;

  DocEntity({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.isPersonal,
    required this.description,
    this.fields,
    this.link,
  });

  DocEntity copyWith({
    int? id,
    String? name,
    String? nameRu,
    String? link,
    bool? isPersonal,
    String? description,
    List<FieldEntity>? fields,
  }) {
    return DocEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameRu: nameRu ?? this.nameRu,
      link: link ?? this.link,
      isPersonal: isPersonal ?? this.isPersonal,
      description: description ?? this.description,
      fields: fields ?? this.fields,
    );
  }
}
