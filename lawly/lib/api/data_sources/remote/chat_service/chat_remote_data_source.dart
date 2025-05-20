import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/chat_service/chat_endpoints.dart';
import 'package:lawly/api/models/chat/lawyer_req_create_model.dart';
import 'package:lawly/api/models/chat/lawyer_req_response_model.dart';
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
}
