// ignore_for_file: annotate_overrides, overridden_fields

import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

part 'authorized_user_model.g.dart';

@JsonSerializable()
class AuthorizedUserModel extends AuthorizedUserEntity {
  @JsonKey(name: 'device_id')
  final String deviceId;

  @JsonKey(name: 'device_os')
  final String deviceOs;

  @JsonKey(name: 'device_name')
  final String deviceName;

  @JsonKey(name: 'agree_to_terms')
  final bool? agreeToTerms;

  const AuthorizedUserModel({
    required super.email,
    required super.password,
    required this.deviceId,
    required this.deviceOs,
    required this.deviceName,
    super.name,
    this.agreeToTerms = true,
  }) : super(
          deviceId: deviceId,
          deviceOs: deviceOs,
          deviceName: deviceName,
          agreeToTerms: agreeToTerms,
        );

  factory AuthorizedUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorizedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorizedUserModelToJson(this);
}
