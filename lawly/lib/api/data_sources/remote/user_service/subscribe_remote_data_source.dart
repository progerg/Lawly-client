import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/user_service/subscribe_endpoints.dart';
import 'package:lawly/api/models/user/tariff_model.dart';
import 'package:retrofit/retrofit.dart';

part 'subscribe_remote_data_source.g.dart';

@RestApi()
abstract class SubscribeRemoteDataSource {
  factory SubscribeRemoteDataSource(Dio dio, {String baseUrl}) =
      _SubscribeRemoteDataSource;

  @GET(SubscribeEndpoints.tariffs)
  Future<List<TariffModel>> getTariffs();

  @POST(SubscribeEndpoints.subscribe)
  Future<void> setSubscribe({
    @Field('tariff_id') required int tariffId,
  });
}
