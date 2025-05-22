import 'package:elementary/elementary.dart';
import 'package:lawly/features/chat/domain/entity/total_lawyer_messages_entity.dart';
import 'package:lawly/features/chat/service/chat_service.dart';

class LawyerChatScreenModel extends ElementaryModel {
  final ChatService _chatService;

  LawyerChatScreenModel({
    required ChatService chatService,
  }) : _chatService = chatService;

  int get defaultLimit => 10;

  Future<TotalLawyerMessagesEntity> getLawyerMessages({
    required String startDate,
    required String endDate,
  }) async {
    return await _chatService.getLawyerMessages(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
