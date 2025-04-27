import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_widget.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:provider/provider.dart';

abstract class IAuthScreenWidgetModel implements IWidgetModel {
  TextEditingController get emailController;

  TextEditingController get passwordController;

  void onCompleteAuth();

  void goBack();
}

AuthScreenWidgetModel defaultAuthScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = AuthScreenModel(
    authService: appScope.authService,
    authBloc: appScope.authBloc,
    navBarObserver: appScope.navBarObserver,
  );
  return AuthScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
  );
}

class AuthScreenWidgetModel
    extends WidgetModel<AuthScreenWidget, AuthScreenModel>
    implements IAuthScreenWidgetModel {
  final AppRouter appRouter;
  final StackRouter stackRouter;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
  });

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  Future<void> onCompleteAuth() async {
    final user = await model.signIn();

    model.authBloc.add(
      AuthEvent.loggedIn(authorizedUser: user),
    );

    appRouter.push(
      switch (model.navBarObserver.currentNavBarElement.value) {
        NavBarElement.document => DocumentsRouter(),
        NavBarElement.template => TemplatesRouter(),
        NavBarElement.chat => ChatRouter(),
        NavBarElement.profile => ProfileRouter(),
      },
    );
  }

  @override
  void goBack() {
    stackRouter.pop();
  }
}
