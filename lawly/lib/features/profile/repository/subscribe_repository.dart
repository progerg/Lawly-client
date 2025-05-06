import 'package:lawly/api/data_sources/remote/user_service/subscribe_remote_data_source.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';

abstract class ISubscribeRepository {
  Future<List<TariffEntity>> getTariffs();

  Future<void> setSubscribe({required int tariffId});
}

class SubscribeRepository implements ISubscribeRepository {
  final SubscribeRemoteDataSource _subscribeRemoteDataSource;

  SubscribeRepository(
      {required SubscribeRemoteDataSource subscribeRemoteDataSource})
      : _subscribeRemoteDataSource = subscribeRemoteDataSource;

  @override
  Future<List<TariffEntity>> getTariffs() async {
    return await _subscribeRemoteDataSource.getTariffs();
  }

  @override
  Future<void> setSubscribe({required int tariffId}) async {
    return await _subscribeRemoteDataSource.setSubscribe(tariffId: tariffId);
  }
}
