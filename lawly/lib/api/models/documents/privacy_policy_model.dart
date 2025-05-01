import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/features/auth/domain/entities/privacy_policy_entity.dart';

part 'privacy_policy_model.g.dart';

@JsonSerializable()
class PrivacyPolicyModel extends PrivacyPolicyEntity {
  PrivacyPolicyModel({
    required super.content,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPolicyModelFromJson(json);
}
