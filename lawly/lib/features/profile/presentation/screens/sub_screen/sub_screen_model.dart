import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/service/subscribe_service.dart';

class SubScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final SubscribeService _subscribeService;

  SubScreenModel({
    required this.authBloc,
    required SubscribeService subscribeService,
  }) : _subscribeService = subscribeService;

  Future<List<TariffEntity>> getTariffs() async {
    return await _subscribeService.getTariffs();
  }

  Future<void> setSubscribe({required int tariffId}) async {
    return await _subscribeService.setSubscribe(tariffId: tariffId);
  }
}
