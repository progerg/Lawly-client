import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';
import 'package:lawly/features/profile/service/subscribe_service.dart';

class AuthScreenModel extends ElementaryModel {
  final AuthService _authService;
  final AuthBloc authBloc;
  final SubBloc subBloc;
  final NavBarObserver navBarObserver;
  final SaveUserService saveUserService;
  final SubscribeService _subscribeService;

  AuthScreenModel({
    required AuthService authService,
    required SubscribeService subscribeService,
    required this.authBloc,
    required this.subBloc,
    required this.navBarObserver,
    required this.saveUserService,
  })  : _authService = authService,
        _subscribeService = subscribeService;

  Future<void> signIn({required AuthorizedUserEntity entity}) =>
      _authService.signIn(entity: entity);

  Future<SubscribeEntity> getSubscribe() async {
    return await _subscribeService.getSubscribe();
  }
}
