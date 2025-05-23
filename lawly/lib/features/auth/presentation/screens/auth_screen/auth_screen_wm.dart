import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_widget.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/l10n/l10n.dart';
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
    subscribeService: appScope.subscribeService,
    authBloc: appScope.authBloc,
    subBloc: appScope.subBloc,
    navBarObserver: appScope.navBarObserver,
    saveUserService: appScope.saveUserService,
  );
  return AuthScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class AuthScreenWidgetModel
    extends WidgetModel<AuthScreenWidget, AuthScreenModel>
    implements IAuthScreenWidgetModel {
  final AppRouter appRouter;
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

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
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.uncorrect_auth_data,
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_sub,
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.uncorrect_email,
        );
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_connection_problems,
        );
      } else {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.unknown_error,
        );
      }
    }
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  Future<void> onCompleteAuth() async {
    try {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        final config = Environment<AppConfig>.instance().config;

        final localUser = model.saveUserService.getAuthUser();

        final user = localUser != null
            ? localUser.copyWith(
                email: _emailController.text,
                password: _passwordController.text,
                deviceId: config.deviceId,
                deviceOs: config.deviceOs,
                deviceName: config.deviceName,
              )
            : AuthorizedUserEntity(
                name: context.l10n.no_name,
                email: _emailController.text,
                password: _passwordController.text,
                deviceId: config.deviceId,
                deviceOs: config.deviceOs,
                deviceName: config.deviceName,
              );

        await model.signIn(entity: user);

        await model.saveUserService.saveAuthUser(entity: user);

        model.authBloc.add(
          AuthEvent.loggedIn(authorizedUser: user),
        );

        final currentSubscribe = await model.getSubscribe();

        model.subBloc.add(
          SubEvent.setSub(subscribeEntity: currentSubscribe),
        );

        appRouter.push(
          switch (model.navBarObserver.currentNavBarElement.value) {
            NavBarElement.document => DocumentsRouter(),
            NavBarElement.template => TemplatesRouter(),
            NavBarElement.chat => ChatRouter(),
            NavBarElement.profile => ProfileRouter(),
          },
        );
      } else {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.fill_all_fields,
        );
      }
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode.toString() ?? 'Unknown error'}');
      onErrorHandle(e);
    }
  }

  @override
  void goBack() {
    stackRouter.pop();
  }
}
