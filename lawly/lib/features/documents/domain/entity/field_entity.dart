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
}
