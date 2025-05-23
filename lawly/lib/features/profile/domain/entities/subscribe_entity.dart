import 'package:lawly/api/models/user/tariff_model.dart';

class SubscribeEntity {
  final TariffModel tariff;
  final String startDate;
  final String? endDate;
  final int countLawyers;
  final int consultationsTotal;
  final int consultationsUsed;
  final bool canUserAi;
  final bool canCreateCustomTemplates;
  final bool unlimitedDocuments;

  SubscribeEntity({
    required this.tariff,
    required this.startDate,
    this.endDate,
    required this.countLawyers,
    required this.consultationsTotal,
    required this.consultationsUsed,
    required this.canUserAi,
    required this.canCreateCustomTemplates,
    required this.unlimitedDocuments,
  });
}
