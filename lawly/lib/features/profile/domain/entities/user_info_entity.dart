import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';

class UserInfoEntity {
  final int userId;
  final TariffEntity tariff;
  final String startDate;
  final String endDate;

  UserInfoEntity({
    required this.userId,
    required this.tariff,
    required this.startDate,
    required this.endDate,
  });
}
