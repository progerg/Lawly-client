import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/remote/chat_service/web_socket_service.dart';
import 'package:lawly/features/chat/domain/entity/total_messages_entity.dart';
import 'package:lawly/features/chat/repository/chat_repository.dart';
import 'package:lawly/features/chat/service/chat_service.dart';

class ChatScreenModel extends ElementaryModel {
  final ChatService _chatService;
  final WebSocketService webSocketService;

  ChatScreenModel({
    required ChatService chatService,
    required this.webSocketService,
  }) : _chatService = chatService;

  int get defaultLimit => ChatRepository.defaultLimit;

  Future<TotalMessagesEntity> getAiMessages({
    String? fromDate,
    String? toDate,
    int? limit,
    required int offset,
  }) async {
    return await _chatService.getAiMessages(
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
      offset: offset,
    );
  }
}
