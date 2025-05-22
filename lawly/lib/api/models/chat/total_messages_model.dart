import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/api/models/chat/message_model.dart';
import 'package:lawly/features/chat/domain/entity/total_messages_entity.dart';

part 'total_messages_model.g.dart';

@JsonSerializable()
class TotalMessagesModel extends TotalMessagesEntity {
  @JsonKey(name: 'has_more')
  final bool hasMore;

  @JsonKey(name: 'messages')
  final List<MessageModel> messages;

  TotalMessagesModel({
    required super.total,
    required this.hasMore,
    required this.messages,
  }) : super(
          hasMore: hasMore,
          messages: messages,
        );

  factory TotalMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$TotalMessagesModelFromJson(json);
}
