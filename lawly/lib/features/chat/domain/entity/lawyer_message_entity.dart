class LawyerMessageEntity {
  final int messageId;
  final String note;
  final bool hasFile;

  const LawyerMessageEntity({
    required this.messageId,
    required this.note,
    required this.hasFile,
  });
}
