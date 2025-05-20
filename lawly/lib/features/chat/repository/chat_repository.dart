import 'package:lawly/api/data_sources/remote/chat_service/chat_remote_data_source.dart';
import 'package:lawly/api/models/chat/lawyer_req_create_model.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';

abstract class IChatRepository {
  Future<LawyerReqResponseEntity> createLawyerRequest({
    required LawyerReqCreateEntity lawyerReqCreateEntity,
  });
}

class ChatRepository implements IChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepository({
    required ChatRemoteDataSource chatRemoteDataSource,
  }) : _chatRemoteDataSource = chatRemoteDataSource;

  @override
  Future<LawyerReqResponseEntity> createLawyerRequest({
    required LawyerReqCreateEntity lawyerReqCreateEntity,
  }) async {
    return await _chatRemoteDataSource.createLawyerRequest(
      lawyerReqCreateModel: LawyerReqCreateModel.fromEntity(
        lawyerReqCreateEntity,
      ),
    );
  }
}
