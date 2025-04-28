import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_widget.dart';
import 'package:lawly/features/navigation/service/guards/auth_guard.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:provider/provider.dart';

abstract class IRegistrationScreenWidgetModel implements IWidgetModel {
  TextEditingController get nameTextController;
  TextEditingController get emailTextController;
  TextEditingController get passwordTextController;

  void onCompleteRegistration();

  void goBack();
}

RegistrationScreenWidgetModel defaultRegistrationScreenWidgetModelFactory(
  BuildContext context,
) {
  final appScope = context.read<IAppScope>();
  final model = RegistrationScreenModel(
    navBarObserver: appScope.navBarObserver,
  );

  return RegistrationScreenWidgetModel(
    model,
    authGuard: appScope.authGuard,
    appRouter: appScope.router,
    stackRouter: context.router,
  );
}

class RegistrationScreenWidgetModel
    extends WidgetModel<RegistrationScreenWidget, RegistrationScreenModel>
    implements IRegistrationScreenWidgetModel {
  final AuthGuard authGuard;
  final AppRouter appRouter;
  final StackRouter stackRouter;

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  RegistrationScreenWidgetModel(
    super.model, {
    required this.authGuard,
    required this.appRouter,
    required this.stackRouter,
  });

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  TextEditingController get nameTextController => _nameTextController;

  @override
  TextEditingController get emailTextController => _emailTextController;

  @override
  TextEditingController get passwordTextController => _passwordTextController;

  @override
  void onCompleteRegistration() {
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
