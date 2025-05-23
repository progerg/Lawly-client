import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_message_entity.dart';

part 'lawyer_message_model.g.dart';

@JsonSerializable()
class LawyerMessageModel extends LawyerMessageEntity {
  @JsonKey(name: 'message_id')
  final int messageId;

  @JsonKey(name: 'has_file')
  final bool hasFile;

  LawyerMessageModel({
    required this.messageId,
    required super.note,
    required this.hasFile,
  }) : super(
          messageId: messageId,
          hasFile: hasFile,
        );

  factory LawyerMessageModel.fromJson(Map<String, dynamic> json) =>
      _$LawyerMessageModelFromJson(json);
}
