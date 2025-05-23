import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends MessageEntity {
  @JsonKey(name: 'sender_type')
  final String senderType;

  @JsonKey(name: 'sender_id')
  final int? senderId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  MessageModel({
    required super.id,
    required this.senderType,
    this.senderId,
    required super.content,
    required this.createdAt,
    required super.status,
  }) : super(
          senderType: senderType,
          senderId: senderId,
          createdAt: createdAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
