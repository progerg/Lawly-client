import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/domain/enity/profile/profile_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IProfileScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<UserInfoEntity> get userInfoState;

  ValueNotifier<String?> get avatarImagePathState;

  String get title;

  String get username;

  String get email;

  void onUpdateAvatar();

  void openPrivacyPolicy();

  void onOpenSettings();

  void onOpenSubs();

  void onOpenMyTemplates();

  void onLogout();
}

ProfileScreenWidgetModel defaultProfileScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = ProfileScreenModel(
    authBloc: appScope.authBloc,
    subBloc: appScope.subBloc,
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

  final _avatarImagePathState = ValueNotifier<String?>(null);

  @override
  String get title => context.l10n.profile_app_bar_title;

  @override
  ValueNotifier<String?> get avatarImagePathState => _avatarImagePathState;

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
    unawaited(_loadSavedAvatarPath());
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
  Future<void> onOpenMyTemplates() async {
    await stackRouter.push(createMyTemplatesRoute());
  }

  @override
  Future<void> onUpdateAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Ограничиваем размер для экономии места
        maxHeight: 800,
      );

      if (image != null) {
        // Получаем директорию для хранения
        final appDir = await _getDownloadDirectory();
        if (appDir == null) throw Exception('Cannot access app directory');

        // Генерируем уникальное имя файла на основе времени
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final avatarPath = '${appDir.path}/$fileName';

        // Копируем файл из временной директории в постоянную
        final tempFile = File(image.path);
        final permanentFile = await tempFile.copy(avatarPath);

        // Обновляем значение в ValueNotifier
        _avatarImagePathState.value = permanentFile.path;

        // Сохраняем путь к аватару
        await model.saveUserAvatarPath(permanentFile.path);

        // Очищаем старые файлы аватаров для экономии места
        // await _cleanOldAvatars(permanentFile.path);
      }
    } catch (e) {
      // Обработка ошибок
      log('Error picking and saving image: $e');
      // Можно также показать уведомление пользователю
      _showErrorMessage(
        context.l10n.no_success_update_avatar,
      );
    }
  }

  @override
  Future<void> onLogout() async {
    try {
      final config = Environment<AppConfig>.instance().config;

      await model.logout(deviceId: config.deviceId);

      await model.tokenLocalDataSource.clearTokens();

      model.authBloc.add(AuthEvent.loggedOut());

      model.subBloc.add(SubEvent.removeSub());

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

  Future<void> _loadSavedAvatarPath() async {
    try {
      final savedPath = await model.getUserAvatarPath();
      if (savedPath != null && savedPath.isNotEmpty) {
        final file = File(savedPath);
        if (await file.exists()) {
          _avatarImagePathState.value = savedPath;
        } else {
          // Файл не существует, очищаем сохраненный путь
          await model.saveUserAvatarPath('');
        }
      }
    } catch (e) {
      log('Error loading saved avatar: $e');
      _showErrorMessage(
        context.l10n.no_success_load_avatar,
      );
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
    }
    return await getTemporaryDirectory();
  }

  void _showErrorMessage(String message) {
    _scaffoldMessengerWrapper.showSnackBar(
      context,
      message,
    );
  }
}
