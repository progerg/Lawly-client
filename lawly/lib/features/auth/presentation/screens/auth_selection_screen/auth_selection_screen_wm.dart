import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/auth/presentation/screens/auth_selection_screen/auth_selection_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/auth_selection_screen/auth_selection_screen_widget.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class IAuthSelectionScreenWidgetModel implements IWidgetModel {
  String get authSelectionText;

  String get authTitle;

  void onAuth();

  void onRegistration();
}

AuthSelectionScreenWidgetModel defaultAuthSelectionScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = AuthSelectionScreenModel(
    navBarObserver: appScope.navBarObserver,
  );

  return AuthSelectionScreenWidgetModel(
    model,
    l10n: context.l10n,
    appRouter: appScope.router,
    stackRouter: context.router,
  );
}

class AuthSelectionScreenWidgetModel
    extends WidgetModel<AuthSelectionScreenWidget, AuthSelectionScreenModel>
    implements IAuthSelectionScreenWidgetModel {
  AppRouter appRouter;
  StackRouter stackRouter;
  AppLocalizations l10n;

  String _authSelectionText = '';

  String _authTitle = '';

  @override
  String get authTitle => _authTitle;

  AuthSelectionScreenWidgetModel(
    super.model, {
    required this.l10n,
    required this.appRouter,
    required this.stackRouter,
  });

  @override
  String get authSelectionText => _authSelectionText;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    model.navBarObserver.showBottoNavBar();

    _authTitle = _getAuthTitle();
    _authSelectionText = _getAuthSelectionText();
  }

  @override
  Future<void> onAuth() async {
    await stackRouter.root.push(AuthRoute());
    // await context.navigateTo(AuthRoute());
  }

  @override
  void onRegistration() async {
    await stackRouter.root.push(RegistrationRoute());
    // await stackRouter.push(RegistrationRoute());
  }

  String _getAuthSelectionText() {
    switch (model.navBarObserver.currentNavBarElement.value) {
      case NavBarElement.document:
        return l10n.auth_text_for_documents;
      case NavBarElement.chat:
        return l10n.auth_text_for_chat;
      default:
        return l10n.auth_text_for_profile;
    }
  }

  String _getAuthTitle() {
    switch (model.navBarObserver.currentNavBarElement.value) {
      case NavBarElement.document:
        return l10n.document_app_bar_title;
      case NavBarElement.chat:
        return l10n.chat_app_bar_title;
      default:
        return l10n.profile_app_bar_title;
    }
  }
}
