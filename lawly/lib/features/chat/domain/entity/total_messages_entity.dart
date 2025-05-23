import 'package:lawly/features/chat/domain/entity/message_entity.dart';

class TotalMessagesEntity {
  final int total;
  final bool hasMore;
  List<MessageEntity> messages;

  TotalMessagesEntity({
    required this.total,
    required this.hasMore,
    required this.messages,
  });
}
