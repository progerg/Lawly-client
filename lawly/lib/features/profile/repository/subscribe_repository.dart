import 'package:lawly/api/data_sources/remote/subscribe_remote_data_source.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';

abstract class ISubscribeRepository {
  Future<List<TariffEntity>> getTariffs();
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
}
