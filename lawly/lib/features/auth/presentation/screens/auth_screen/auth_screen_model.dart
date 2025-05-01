import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';

class AuthScreenModel extends ElementaryModel {
  final AuthService _authService;
  final AuthBloc authBloc;
  final NavBarObserver navBarObserver;
  final SaveUserService saveUserService;

  AuthScreenModel({
    required AuthService authService,
    required this.authBloc,
    required this.navBarObserver,
    required this.saveUserService,
  }) : _authService = authService;

  Future<void> signIn({required AuthorizedUserEntity entity}) =>
      _authService.signIn(entity: entity);
}
