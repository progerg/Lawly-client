import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/api/models/chat/lawyer_message_model.dart';
import 'package:lawly/features/chat/domain/entity/total_lawyer_messages_entity.dart';

part 'total_lawyer_messages_model.g.dart';

@JsonSerializable()
class TotalLawyerMessagesModel extends TotalLawyerMessagesEntity {
  @JsonKey(name: 'responses')
  final List<LawyerMessageModel> responses;

  TotalLawyerMessagesModel({
    required super.total,
    required this.responses,
  }) : super(responses: responses);

  factory TotalLawyerMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$TotalLawyerMessagesModelFromJson(json);
}
