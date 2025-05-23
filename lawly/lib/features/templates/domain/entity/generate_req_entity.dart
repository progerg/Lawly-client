class GenerateReqEntity {
  final int templateId;
  final List<FilledFieldEntity> fields;

  const GenerateReqEntity({
    required this.templateId,
    required this.fields,
  });
}

class FilledFieldEntity {
  final String name;
  final String value;

  const FilledFieldEntity({
    required this.name,
    required this.value,
  });
}
