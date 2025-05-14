import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/service/subscribe_service.dart';

class RegistrationScreenModel extends ElementaryModel {
  final NavBarObserver navBarObserver;
  final AuthBloc authBloc;
  final SubBloc subBloc;
  final SaveUserService saveUserService;
  final SubscribeService _subscribeService;
  final AuthService _authService;

  RegistrationScreenModel({
    required this.navBarObserver,
    required AuthService authService,
    required this.authBloc,
    required this.subBloc,
    required this.saveUserService,
    required SubscribeService subscribeService,
  })  : _authService = authService,
        _subscribeService = subscribeService;

  Future<void> register({
    required AuthorizedUserEntity entity,
  }) =>
      _authService.register(entity: entity);

  Future<void> setSubscribe({
    required int tariffId,
  }) =>
      _subscribeService.setSubscribe(tariffId: tariffId);

  Future<List<TariffEntity>> getTariffs() async {
    return await _subscribeService.getTariffs();
  }

  Future<SubscribeEntity> getSubscribe() async {
    return await _subscribeService.getSubscribe();
  }
}
