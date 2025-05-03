import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/api/models/user/tariff_model.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel extends UserInfoEntity {
  @JsonKey(name: 'user_id')
  final int userId;

  final TariffModel tariff;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String endDate;

  UserInfoModel({
    required this.userId,
    required this.tariff,
    required this.startDate,
    required this.endDate,
  }) : super(
          userId: userId,
          tariff: tariff,
          startDate: startDate,
          endDate: endDate,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}
