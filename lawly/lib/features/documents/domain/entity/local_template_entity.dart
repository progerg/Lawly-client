class LocalTemplateEntity {
  /// если null, то сгенерированный шаблон, иначе пустой
  final int templateId;

  final String name;

  final String filePath;

  final bool isEmpty;

  /// если null, значит ставить дефолтное превью документа
  final String? imageUrl;

  LocalTemplateEntity({
    required this.templateId,
    required this.name,
    required this.filePath,
    required this.isEmpty,
    this.imageUrl,
  });

  LocalTemplateEntity copyWith({
    int? templateId,
    String? name,
    String? filePath,
    bool? isEmpty,
    String? imageUrl,
  }) {
    return LocalTemplateEntity(
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      isEmpty: isEmpty ?? this.isEmpty,
      filePath: filePath ?? this.filePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
