import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';

part 'tariff_model.g.dart';

const String _defaultDescription = '';

const List<String> _defaultFeatures = [];

const int _defaultConsultationCount = 0;

const bool _defaultAiAccess = false;

const bool _defaultCustomTemplates = false;

const bool _defaultUnlimitedDocs = false;

@JsonSerializable()
class TariffModel extends TariffEntity {
  final String description;

  final List<String> features;

  @JsonKey(name: 'consultations_count')
  final int consultationCount;

  @JsonKey(name: 'ai_access')
  final bool aiAccess;

  @JsonKey(name: 'custom_templates')
  final bool customTemplates;

  @JsonKey(name: 'unlimited_docs')
  final bool unlimitedDocs;

  TariffModel({
    required super.id,
    required super.name,
    this.description = _defaultDescription,
    this.features = _defaultFeatures,
    required super.price,
    this.consultationCount = _defaultConsultationCount,
    this.aiAccess = _defaultAiAccess,
    this.customTemplates = _defaultCustomTemplates,
    this.unlimitedDocs = _defaultUnlimitedDocs,
  }) : super(
          description: description,
          features: features,
          consultationCount: consultationCount,
          aiAccess: aiAccess,
          customTemplates: customTemplates,
          unlimitedDocs: unlimitedDocs,
        );

  factory TariffModel.fromJson(Map<String, dynamic> json) =>
      _$TariffModelFromJson(json);
}
