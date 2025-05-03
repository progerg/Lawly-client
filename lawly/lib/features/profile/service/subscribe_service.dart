import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/repository/subscribe_repository.dart';

class SubscribeService {
  final ISubscribeRepository _subscribeRepository;

  SubscribeService({required ISubscribeRepository subscribeRepository})
      : _subscribeRepository = subscribeRepository;

  Future<List<TariffEntity>> getTariffs() async {
    return await _subscribeRepository.getTariffs();
  }
}
