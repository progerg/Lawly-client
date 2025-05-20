import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';
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
}
