class FieldEntity {
  final int id;
  final String name;
  final String? nameRu;
  final String type;
  final String? value;

  FieldEntity({
    required this.id,
    required this.name,
    required this.type,
    this.nameRu,
    this.value,
  });

  FieldEntity copyWith({
    int? id,
    String? name,
    String? nameRu,
    String? type,
    String? value,
  }) {
    return FieldEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameRu: nameRu ?? this.nameRu,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
