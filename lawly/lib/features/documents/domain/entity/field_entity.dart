class FieldEntity {
  final int id;
  final String name;
  final String? nameRu;
  final String? mask;
  final String? example;
  final Map<String, String>? filterField;
  final bool canImproveAi;
  final String? value;

  FieldEntity({
    required this.id,
    required this.name,
    required this.canImproveAi,
    this.mask,
    this.example,
    this.filterField,
    this.nameRu,
    this.value,
  });

  FieldEntity copyWith({
    int? id,
    String? name,
    String? nameRu,
    String? mask,
    String? example,
    Map<String, String>? filterField,
    bool? canImproveAi,
    String? value,
  }) {
    return FieldEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameRu: nameRu ?? this.nameRu,
      mask: mask ?? this.mask,
      example: example ?? this.example,
      filterField: filterField ?? this.filterField,
      canImproveAi: canImproveAi ?? this.canImproveAi,
      value: value ?? this.value,
    );
  }
}
