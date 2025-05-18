import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/firebase_options.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

abstract class ITemplatesScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<TemplateEntity>> get templatesState;

  ScrollController get scrollController;

  UnionStateNotifier<bool> get canCreateCustomTemplatesState;

  String get title;

  bool get isLoading;

  UnionStateNotifier<List<TemplateEntity>> get filteredTemplatesState;

  void onCreateCustomTemplate();

  void onSearchQueryChanged(String query);

  void onTemplateTap(TemplateEntity template);
}

TemplatesScreenWidgetModel defaultTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplatesScreenModel(
    authBloc: appScope.authBloc,
    subBloc: appScope.subBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    saveUserService: appScope.saveUserService,
    templateService: appScope.templateService,
    userInfoService: appScope.userInfoService,
    subscribeService: appScope.subscribeService,
  );
  return TemplatesScreenWidgetModel(
    model,
    stackRouter: context.router,
    appRouter: appScope.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class TemplatesScreenWidgetModel
    extends WidgetModel<TemplatesScreenWidget, TemplatesScreenModel>
    implements ITemplatesScreenWidgetModel {
  final StackRouter stackRouter;
  final AppRouter appRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  int _offset = 0;

  bool _isLoading = false;

  Timer? _debounceTimer;

  final _templatesState = UnionStateNotifier<List<TemplateEntity>>.loading();
  final _canCreateCustomTemplates = UnionStateNotifier<bool>.loading();
  final _scrollController = ScrollController();

  @override
  UnionStateNotifier<List<TemplateEntity>> get templatesState =>
      _templatesState;

  @override
  UnionStateNotifier<bool> get canCreateCustomTemplatesState =>
      _canCreateCustomTemplates;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  String get title => context.l10n.template_app_bar_title;

  @override
  bool get isLoading => _isLoading;

  final _searchQuery = ValueNotifier<String>('');
  final _filteredTemplatesState = UnionStateNotifier<List<TemplateEntity>>([]);

  @override
  UnionStateNotifier<List<TemplateEntity>> get filteredTemplatesState =>
      _filteredTemplatesState;

  @override
  void onSearchQueryChanged(String query) {
    _searchQuery.value = query;
    _filterTemplates();
  }

  @override
  Future<void> onCreateCustomTemplate() async {
    await stackRouter.push(
      createCustomTemplate(),
    );
  }

  void _filterTemplates() {
    final query = _searchQuery.value.toLowerCase();

    // Если запрос пустой, показываем все шаблоны
    if (query.isEmpty) {
      final templates = templatesState.value.data;
      if (templates != null) {
        _filteredTemplatesState.content(templates);
      }
      return;
    }

    // Фильтруем шаблоны по названию
    final templates = templatesState.value.data;
    if (templates != null) {
      final filtered = templates
          .where((template) =>
              template.nameRu.toLowerCase().contains(query) ||
              template.name.toLowerCase().contains(query))
          .toList();

      _filteredTemplatesState.content(filtered);
    }
  }

  TemplatesScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.appRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_checkAuth());

    _searchQuery.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 300), _filterTemplates);
    });

    templatesState.addListener(() {
      if (templatesState.value.data != null) {
        _filterTemplates();
      }
    });

    _scrollController.addListener(
      _scrollEndListener,
    );

    unawaited(_loadTemplates());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchQuery.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_sub,
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

//   Future<void> requestNotificationPermissionOnStartup() async {
//   final prefs = await SharedPreferences.getInstance();
//   final bool hasRequestedPermission = prefs.getBool('notification_permission_requested') ?? false;

//   if (!hasRequestedPermission) {
//     await Permission.notification.request();
//     await prefs.setBool('notification_permission_requested', true);
//   }
// }

  void _scrollEndListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      unawaited(_loadTemplates());
    }
  }

  Future<void> _checkAuth() async {
    try {
      final jwtToken = model.tokenLocalDataSource.getAccessToken();
      final user = model.saveUserService.getAuthUser();
      if (jwtToken != null && user != null) {
        final config = Environment<AppConfig>.instance().config;

        model.authBloc.add(AuthEvent.loggedIn(authorizedUser: user));

        final app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        log(app.options.projectId);

        final messaging = FirebaseMessaging.instance;
        if (Platform.isAndroid) {
          // TODO: поправить по FCM

          final token = await messaging.getToken();

          log(token ?? 'no token');

          if (token != null) {
            await model.userInfoService.updateFcmToken(
              fcmToken: token,
              deviceId: config.deviceId,
            );
          }
        }

        // Подтягиваем подписку
        final currentSubscribe = await model.getSubscribe();
        model.subBloc.add(
          SubEvent.setSub(subscribeEntity: currentSubscribe),
        );

        _canCreateCustomTemplates.content(
          currentSubscribe.canCreateCustomTemplates,
        );
      } else {
        model.authBloc.add(AuthEvent.loggedOut());
        model.subBloc.add(SubEvent.removeSub());
        _canCreateCustomTemplates.content(false);
      }
    } on Exception catch (e) {
      onErrorHandle(e);
    }
  }

  @override
  Future<void> onTemplateTap(TemplateEntity template) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await stackRouter.push(createTemplateNoAuthRoute(
      template: template,
    ));
  }

  // Future<void> _loadTemplates() async {
  //   final previousData = _templatesState.value.data;
  //   _templatesState.loading(previousData);

  //   try {
  //     final templatesWithTotal = await model.templateService.getTotalTemplates(
  //       offset: _offset,
  //     );
  //     _offset++;
  //     if (previousData != null) {
  //       final updatedTemplates = [
  //         ...previousData,
  //         ...templatesWithTotal.templates,
  //       ];
  //       _templatesState.content(updatedTemplates);
  //     } else {
  //       _templatesState.content(templatesWithTotal.templates);
  //     }
  //   } on Exception catch (e) {
  //     _templatesState.failure(e, previousData);
  //     onErrorHandle(e);
  //   }
  // }

  Future<void> _loadTemplates() async {
    final previousData = _templatesState.value.data;
    _templatesState.loading(previousData);
    _isLoading = true;

    try {
      final templatesWithTotal = await model.templateService.getTotalTemplates(
        offset: _offset,
      );

      if (_offset < templatesWithTotal.total) {
        _offset += model.limitForTemplates;
      }

      List<TemplateEntity> updatedTemplates;
      if (previousData != null) {
        updatedTemplates = [
          ...previousData,
          ...templatesWithTotal.templates,
        ];
      } else {
        updatedTemplates = templatesWithTotal.templates;
      }

      _templatesState.content(updatedTemplates);
      _isLoading = false;
    } on Exception catch (e) {
      _templatesState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
