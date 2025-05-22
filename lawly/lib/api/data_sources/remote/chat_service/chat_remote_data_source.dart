import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/chat_service/chat_endpoints.dart';
import 'package:lawly/api/models/chat/lawyer_req_create_model.dart';
import 'package:lawly/api/models/chat/lawyer_req_response_model.dart';
import 'package:lawly/api/models/chat/total_lawyer_messages_model.dart';
import 'package:lawly/api/models/chat/total_messages_model.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_remote_data_source.g.dart';

@RestApi()
abstract class ChatRemoteDataSource {
  factory ChatRemoteDataSource(Dio dio, {String baseUrl}) =
      _ChatRemoteDataSource;

  @POST(ChatEndpoints.lawyerRequest)
  Future<LawyerReqResponseModel> createLawyerRequest({
    @Body() required LawyerReqCreateModel lawyerReqCreateModel,
  });

  @GET(ChatEndpoints.messages)
  Future<TotalMessagesModel> getAiMessages({
    @Query('from_date') String? fromDate,
    @Query('to_date') String? toDate,
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  @GET(ChatEndpoints.lawyerMessages)
  Future<TotalLawyerMessagesModel> getLawyerMessages({
    @Query('start_date') required String startDate,
    @Query('end_date') required String endDate,
  });

  @GET(ChatEndpoints.lawyerDocuments)
  Future<String> getLawyerDocuments({
    @Query('message_id') required int messageId,
  });
}
