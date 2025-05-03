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
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/profile/presentation/screens/settings_screen/settings_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/settings_screen/settings_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';

abstract class ISettingsScreenWidgetModel implements IWidgetModel {
  String get title;

  void onLogout();

  void goBack();
}

SettingsScreenWidgetModel defaultSettingsScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = SettingsScreenModel(
    authBloc: appScope.authBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    authService: appScope.authService,
  );
  return SettingsScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class SettingsScreenWidgetModel
    extends WidgetModel<SettingsScreenWidget, SettingsScreenModel>
    implements ISettingsScreenWidgetModel {
  final AppRouter appRouter;
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  SettingsScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 403) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Неверные учетные данные',
        );
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Проблемы с подключением к интернету',
        );
      } else {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Неизвестная ошибка',
        );
      }
    }
  }

  @override
  String get title => context.l10n.settings;

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onLogout() async {
    try {
      final config = Environment<AppConfig>.instance().config;

      await model.logout(deviceId: config.deviceId);

      await model.tokenLocalDataSource.clearTokens();

      model.authBloc.add(AuthEvent.loggedOut());

      appRouter.push(const ProfileRouter());
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode.toString() ?? 'Unknown error'}');
      onErrorHandle(e);
    }
  }
}
