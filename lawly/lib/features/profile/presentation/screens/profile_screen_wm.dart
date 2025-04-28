import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';

abstract class IProfileScreenWidgetModel implements IWidgetModel {
  String get title;

  void onLogOut();
}

ProfileScreenWidgetModel defaultProfileScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = ProfileScreenModel(
    authBloc: appScope.authBloc,
  );
  return ProfileScreenWidgetModel(
    model,
    appRouter: appScope.router,
  );
}

class ProfileScreenWidgetModel
    extends WidgetModel<ProfileScreenWidget, ProfileScreenModel>
    implements IProfileScreenWidgetModel {
  final AppRouter appRouter;

  @override
  String get title => context.l10n.profile_app_bar_title;

  ProfileScreenWidgetModel(
    super.model, {
    required this.appRouter,
  });

  @override
  void onLogOut() {
    model.authBloc.add(AuthEvent.loggedOut());

    appRouter.push(const HomeRouter());
  }
}
