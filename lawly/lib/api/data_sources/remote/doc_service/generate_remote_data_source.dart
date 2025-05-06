import 'package:dio/dio.dart';
import 'package:lawly/api/models/templates/generate_req_model.dart';
import 'package:retrofit/retrofit.dart';

part 'generate_remote_data_source.g.dart';

@RestApi()
abstract class GenerateRemoteDataSource {
  factory GenerateRemoteDataSource(Dio dio, {String baseUrl}) =
      _GenerateRemoteDataSource;

  @POST('/api/v1/documents/generate')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadTemplate({
    @Body() required GenerateReqModel generateReqModel,
    @Header('Accept') required String contentType,
  });
}
