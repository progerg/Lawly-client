import 'dart:async';
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
import 'package:lawly/features/navigation/domain/enity/profile/profile_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IProfileScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<UserInfoEntity> get userInfoState;

  String get title;

  String get username;

  String get email;

  void openPrivacyPolicy();

  void onOpenSettings();

  void onOpenSubs();

  void onLogout();
}

ProfileScreenWidgetModel defaultProfileScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = ProfileScreenModel(
    authBloc: appScope.authBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    authService: appScope.authService,
    userInfoService: appScope.userInfoService,
    saveUserService: appScope.saveUserService,
  );
  return ProfileScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class ProfileScreenWidgetModel
    extends WidgetModel<ProfileScreenWidget, ProfileScreenModel>
    implements IProfileScreenWidgetModel {
  final AppRouter appRouter;
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _userInfoState = UnionStateNotifier<UserInfoEntity>.loading();

  @override
  String get title => context.l10n.profile_app_bar_title;

  @override
  String get username =>
      model.saveUserService.getAuthUser()?.name ?? context.l10n.no_name;

  @override
  String get email => model.saveUserService.getAuthUser()?.email ?? '';

  @override
  UnionStateNotifier<UserInfoEntity> get userInfoState => _userInfoState;

  ProfileScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    unawaited(_loadUserInfo());
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
      } else if (error.response?.statusCode == 409) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_subscription,
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_validation_data,
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
  Future<void> onOpenSettings() async {
    await stackRouter.push(createSettingsRoute());
  }

  @override
  Future<void> openPrivacyPolicy() async {
    await stackRouter.push(createPrivacyPolicyRoute());
  }

  @override
  Future<void> onOpenSubs() async {
    final newTariff = await stackRouter.push(createSubscribeRoute());
    if (newTariff != null) {
      unawaited(_loadUserInfo());
    }
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

  Future<void> _loadUserInfo() async {
    final previousData = _userInfoState.value.data;
    _userInfoState.loading(previousData);

    try {
      final userInfoData = await model.getUserInfo();
      _userInfoState.content(userInfoData);
    } on Exception catch (e) {
      _userInfoState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
