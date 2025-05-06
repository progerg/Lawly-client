import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

abstract class ITemplatesScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<TemplateEntity>> get templatesState;

  String get title;

  void onTemplateTap(TemplateEntity template);
}

TemplatesScreenWidgetModel defaultTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplatesScreenModel(
    authBloc: appScope.authBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    saveUserService: appScope.saveUserService,
    templateService: appScope.templateService,
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

  final _templatesState = UnionStateNotifier<List<TemplateEntity>>.loading();

  @override
  UnionStateNotifier<List<TemplateEntity>> get templatesState =>
      _templatesState;

  @override
  String get title => context.l10n.template_app_bar_title;

  TemplatesScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.appRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    checkAuth();

    unawaited(_loadTemplates());
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Ошибка валидации данных',
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

  void checkAuth() {
    final jwtToken = model.tokenLocalDataSource.getAccessToken();
    final user = model.saveUserService.getAuthUser();
    if (jwtToken != null && user != null) {
      model.authBloc.add(AuthEvent.loggedIn(authorizedUser: user));
    } else {
      model.authBloc.add(AuthEvent.loggedOut());
    }
  }

  @override
  Future<void> onTemplateTap(TemplateEntity template) async {
    await stackRouter.push(createTemplateNoAuthRoute(
      template: template,
    ));
  }

  Future<void> _loadTemplates() async {
    final previousData = _templatesState.value.data;
    _templatesState.loading(previousData);

    try {
      final templatesWithTotal = await model.templateService.getTotalTemplates(
        offset: _offset,
      );
      _offset++;
      if (previousData != null) {
        _templatesState.content([
          ...previousData,
          ...templatesWithTotal.templates,
        ]);
      } else {
        _templatesState.content(templatesWithTotal.templates);
      }
    } on Exception catch (e) {
      _templatesState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
