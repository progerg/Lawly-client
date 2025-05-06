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
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_widget.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';
import 'package:lawly/features/navigation/service/guards/auth_guard.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:provider/provider.dart';

abstract class IRegistrationScreenWidgetModel implements IWidgetModel {
  TextEditingController get nameTextController;
  TextEditingController get emailTextController;
  TextEditingController get passwordTextController;
  TextEditingController get confirmPasswordTextController;

  void onCompleteRegistration();

  void onAgreePrivacyPolicy(bool value);

  void openPrivacyPolicy();

  void goBack();
}

RegistrationScreenWidgetModel defaultRegistrationScreenWidgetModelFactory(
  BuildContext context,
) {
  final appScope = context.read<IAppScope>();
  final model = RegistrationScreenModel(
    navBarObserver: appScope.navBarObserver,
    authService: appScope.authService,
    authBloc: appScope.authBloc,
    saveUserService: appScope.saveUserService,
    subscribeService: appScope.subscribeService,
  );

  return RegistrationScreenWidgetModel(
    model,
    authGuard: appScope.authGuard,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class RegistrationScreenWidgetModel
    extends WidgetModel<RegistrationScreenWidget, RegistrationScreenModel>
    implements IRegistrationScreenWidgetModel {
  final AuthGuard authGuard;
  final AppRouter appRouter;
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  bool _isAgreePrivacyPolicy = false;

  RegistrationScreenWidgetModel(
    super.model, {
    required this.authGuard,
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
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 409) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Пользователь с таким email уже существует',
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Некорректный email',
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
  void onAgreePrivacyPolicy(bool value) {
    _isAgreePrivacyPolicy = value;
  }

  @override
  TextEditingController get nameTextController => _nameTextController;

  @override
  TextEditingController get emailTextController => _emailTextController;

  @override
  TextEditingController get passwordTextController => _passwordTextController;

  @override
  TextEditingController get confirmPasswordTextController =>
      _confirmPasswordTextController;

  @override
  Future<void> onCompleteRegistration() async {
    try {
      if (_nameTextController.text.isEmpty ||
          _emailTextController.text.isEmpty ||
          _passwordTextController.text.isEmpty ||
          _confirmPasswordTextController.text.isEmpty) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Заполните все поля',
        );
        return;
      }
      if (_passwordTextController.text != _confirmPasswordTextController.text) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Пароли не совпадают',
        );
        return;
      }
      if (!_isAgreePrivacyPolicy) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Примите условия политики конфиденциальности',
        );
        return;
      }

      final config = Environment<AppConfig>.instance().config;

      final user = AuthorizedUserEntity(
        name: _nameTextController.text,
        email: _emailTextController.text,
        password: _passwordTextController.text,
        deviceId: config.deviceId,
        deviceOs: config.deviceOs,
        deviceName: config.deviceName,
        agreeToTerms: true,
      );

      await model.register(entity: user);

      await model.setSubscribe(
          tariffId: 2); // TODO: заглушка для базового тарифа

      await model.saveUserService.saveAuthUser(entity: user);

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
    } on DioException catch (e) {
      log('Error: ${e.response?.statusCode.toString() ?? 'Unknown error'}');
      onErrorHandle(e);
    }
  }

  @override
  Future<void> openPrivacyPolicy() async {
    await stackRouter.root.push(
      PrivacyPolicyRoute(),
    );
  }

  @override
  void goBack() {
    stackRouter.pop();
  }
}
