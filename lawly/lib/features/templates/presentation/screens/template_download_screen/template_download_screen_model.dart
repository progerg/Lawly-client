import 'package:elementary/elementary.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';
import 'package:lawly/features/chat/service/chat_service.dart';

class TemplateDownloadScreenModel extends ElementaryModel {
  final ChatService _chatService;

  TemplateDownloadScreenModel({
    required ChatService chatService,
  }) : _chatService = chatService;

  Future<LawyerReqResponseEntity> createLawyerRequest({
    required LawyerReqCreateEntity lawyerReqCreateEntity,
  }) async {
    return await _chatService.createLawyerRequest(
      lawyerReqCreateEntity: lawyerReqCreateEntity,
    );
  }
}
