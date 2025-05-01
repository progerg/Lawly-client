import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';

abstract class ITemplatesScreenWidgetModel implements IWidgetModel {
  String get title;
}

TemplatesScreenWidgetModel defaultTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplatesScreenModel(
    authBloc: appScope.authBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    saveUserService: appScope.saveUserService,
  );
  return TemplatesScreenWidgetModel(
    model,
    appRouter: appScope.router,
  );
}

class TemplatesScreenWidgetModel
    extends WidgetModel<TemplatesScreenWidget, TemplatesScreenModel>
    implements ITemplatesScreenWidgetModel {
  final AppRouter appRouter;

  @override
  String get title => context.l10n.template_app_bar_title;

  TemplatesScreenWidgetModel(
    super.model, {
    required this.appRouter,
  });

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    checkAuth();
  }

  void checkAuth() {
    final jwtToken = model.tokenLocalDataSource.getAccessToken();
    final user = model.saveUserService.getAuthUser();
    if (jwtToken != null && user != null) {
      model.authBloc.add(AuthEvent.loggedIn(authorizedUser: user));
    } else {
      model.authBloc.add(AuthEvent.loggedOut());
    }
  }
}
