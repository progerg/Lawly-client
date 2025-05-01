import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';

class RegistrationScreenModel extends ElementaryModel {
  final NavBarObserver navBarObserver;
  final AuthBloc authBloc;
  final SaveUserService saveUserService;
  final AuthService _authService;

  RegistrationScreenModel({
    required this.navBarObserver,
    required AuthService authService,
    required this.authBloc,
    required this.saveUserService,
  }) : _authService = authService;

  Future<void> register({
    required AuthorizedUserEntity entity,
  }) =>
      _authService.register(entity: entity);
}
