class MessageEntity {
  final int id;
  final String senderType;
  final int? senderId;
  final String content;
  final String createdAt;
  final String status;

  MessageEntity({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.status,
  });
}
