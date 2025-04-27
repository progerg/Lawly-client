import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_routes.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthBloc _authBloc;

  AuthGuard({required AuthBloc authBloc}) : _authBloc = authBloc;

  set isAuthenticated(bool value) {
    isAuthenticated = value;
  }

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (_authBloc.state.isAuthorized) {
      resolver.next();

      return;
    }

    await router.push(createAuthRouter());

    if (_authBloc.state.isAuthorized) {
      resolver.next();
    } else {
      resolver.next(false);
    }
  }
}
