import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';

class UserInfoEntity {
  final int userId;
  final String? name;
  final String? email;
  final TariffEntity tariff;
  final String startDate;
  final String? endDate;

  UserInfoEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.tariff,
    required this.startDate,
    this.endDate,
  });
}
