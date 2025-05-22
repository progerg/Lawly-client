import 'package:lawly/features/chat/domain/entity/lawyer_message_entity.dart';

class TotalLawyerMessagesEntity {
  final int total;
  final List<LawyerMessageEntity> responses;

  TotalLawyerMessagesEntity({
    required this.total,
    required this.responses,
  });
}
