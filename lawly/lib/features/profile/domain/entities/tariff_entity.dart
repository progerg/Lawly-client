class TariffEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> features;
  final int consultationCount;
  final bool aiAccess;
  final bool customTemplates;
  final bool unlimitedDocs;
  final bool isBase;

  TariffEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    required this.consultationCount,
    required this.aiAccess,
    required this.customTemplates,
    required this.unlimitedDocs,
    required this.isBase,
  });
}
