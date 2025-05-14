import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/api/models/user/tariff_model.dart';
import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';

part 'subscribe_model.g.dart';

@JsonSerializable()
class SubscribeModel extends SubscribeEntity {
  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'count_lawyers')
  final int countLawyers;

  @JsonKey(name: 'consultations_total')
  final int consultationsTotal;

  @JsonKey(name: 'consultations_used')
  final int consultationsUsed;

  @JsonKey(name: 'can_user_ai')
  final bool canUserAi;

  @JsonKey(name: 'can_create_custom_templates')
  final bool canCreateCustomTemplates;

  @JsonKey(name: 'unlimited_documents')
  final bool unlimitedDocuments;

  SubscribeModel({
    required super.tariff,
    required this.startDate,
    this.endDate,
    required this.countLawyers,
    required this.consultationsTotal,
    required this.consultationsUsed,
    required this.canUserAi,
    required this.canCreateCustomTemplates,
    required this.unlimitedDocuments,
  }) : super(
          startDate: startDate,
          endDate: endDate,
          countLawyers: countLawyers,
          consultationsTotal: consultationsTotal,
          consultationsUsed: consultationsUsed,
          canUserAi: canUserAi,
          canCreateCustomTemplates: canCreateCustomTemplates,
          unlimitedDocuments: unlimitedDocuments,
        );

  factory SubscribeModel.fromJson(Map<String, dynamic> json) =>
      _$SubscribeModelFromJson(json);
}
