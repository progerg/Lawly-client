import 'package:lawly/api/data_sources/remote/chat_service/chat_remote_data_source.dart';
import 'package:lawly/api/models/chat/lawyer_req_create_model.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';
import 'package:lawly/features/chat/domain/entity/total_lawyer_messages_entity.dart';
import 'package:lawly/features/chat/domain/entity/total_messages_entity.dart';

const String contentType =
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

abstract class IChatRepository {
  Future<LawyerReqResponseEntity> createLawyerRequest({
    required LawyerReqCreateEntity lawyerReqCreateEntity,
  });

  Future<TotalMessagesEntity> getAiMessages({
    String? fromDate,
    String? toDate,
    int? limit,
    required int offset,
  });

  Future<TotalLawyerMessagesEntity> getLawyerMessages({
    required String startDate,
    required String endDate,
  });

  Future<List<int>> getLawyerDocuments({
    required int messageId,
  });
}

class ChatRepository implements IChatRepository {
  static const int defaultLimit = 50;

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

  @override
  Future<TotalMessagesEntity> getAiMessages({
    String? fromDate,
    String? toDate,
    int? limit,
    required int offset,
  }) async {
    return await _chatRemoteDataSource.getAiMessages(
      fromDate: fromDate,
      toDate: toDate,
      limit: limit ?? defaultLimit,
      offset: offset,
    );
  }

  @override
  Future<TotalLawyerMessagesEntity> getLawyerMessages({
    required String startDate,
    required String endDate,
  }) async {
    // TODO:
    // final data = await _chatRemoteDataSource.getLawyerDocuments(
    //     messageId: 26,
    //     contentType:
    //         'application/vnd.openxmlformats-officedocument.wordprocessingml.document');

    return await _chatRemoteDataSource.getLawyerMessages(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<int>> getLawyerDocuments({
    required int messageId,
  }) async {
    return await _chatRemoteDataSource.getLawyerDocuments(
      messageId: messageId,
      contentType: contentType,
    );
  }
}
