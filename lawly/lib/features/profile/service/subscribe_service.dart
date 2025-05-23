import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/repository/subscribe_repository.dart';

class SubscribeService {
  final ISubscribeRepository _subscribeRepository;

  SubscribeService({required ISubscribeRepository subscribeRepository})
      : _subscribeRepository = subscribeRepository;

  Future<List<TariffEntity>> getTariffs() async {
    return await _subscribeRepository.getTariffs();
  }

  Future<void> setSubscribe({required int tariffId}) async {
    return await _subscribeRepository.setSubscribe(tariffId: tariffId);
  }

  Future<SubscribeEntity> getSubscribe() async {
    return await _subscribeRepository.getSubscribe();
  }
}
