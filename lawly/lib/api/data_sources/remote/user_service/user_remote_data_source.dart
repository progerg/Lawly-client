import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/user_service/user_endpoints.dart';
import 'package:lawly/api/models/user/user_info_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_remote_data_source.g.dart';

@RestApi()
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio, {String baseUrl}) =
      _UserRemoteDataSource;

  @GET(UserEndpoints.user)
  Future<UserInfoModel> getUserInfo();

  @POST(UserEndpoints.fcmUpdate)
  Future<void> updateFcmToken({
    @Field('fcm_token') required String fcmToken,
    @Field('device_id') required String deviceId,
  });
}
