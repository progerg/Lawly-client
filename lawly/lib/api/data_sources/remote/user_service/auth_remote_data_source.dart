import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/user_service/auth_endpoints.dart';
import 'package:lawly/api/models/auth/auth_tokens_model.dart';
import 'package:lawly/api/models/auth/authorized_user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST(AuthEndpoints.register)
  Future<AuthTokensModel> register({
    @Body() required AuthorizedUserModel request,
  });

  @POST(AuthEndpoints.login)
  Future<AuthTokensModel> login({
    @Body() required AuthorizedUserModel request,
  });

  @POST(AuthEndpoints.refreshTokens)
  Future<AuthTokensModel> refreshTokens({
    @Field('device_id') required String deviceId,
    @Field('device_os') required String deviceOs,
    @Field('device_name') required String deviceName,
    @Field('refresh_token') required String refreshToken,
  });

  @POST(AuthEndpoints.logout)
  Future<void> logout({
    @Field('device_id') required String deviceId,
    @Field('refresh_token') required String refreshToken,
  });
}
