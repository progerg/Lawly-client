import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';
import 'package:lawly/features/chat/domain/entity/total_lawyer_messages_entity.dart';
import 'package:lawly/features/chat/domain/entity/total_messages_entity.dart';
import 'package:lawly/features/chat/repository/chat_repository.dart';

class ChatService {
  final ChatRepository _chatRepository;

  ChatService({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  Future<LawyerReqResponseEntity> createLawyerRequest({
    required LawyerReqCreateEntity lawyerReqCreateEntity,
  }) async {
    return await _chatRepository.createLawyerRequest(
      lawyerReqCreateEntity: lawyerReqCreateEntity,
    );
  }

  Future<TotalMessagesEntity> getAiMessages({
    String? fromDate,
    String? toDate,
    int? limit,
    required int offset,
  }) async {
    return await _chatRepository.getAiMessages(
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
      offset: offset,
    );
  }

  Future<TotalLawyerMessagesEntity> getLawyerMessages({
    required String startDate,
    required String endDate,
  }) async {
    return await _chatRepository.getLawyerMessages(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<int>> getLawyerDocuments({
    required int messageId,
  }) async {
    return await _chatRepository.getLawyerDocuments(
      messageId: messageId,
    );
  }
}
