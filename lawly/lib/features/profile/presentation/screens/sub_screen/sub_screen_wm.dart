import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/presentation/screens/sub_screen/sub_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/sub_screen/sub_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class ISubScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<TariffEntity>> get tariffsState;

  String get title;

  void goBack();
}

SubScreenWidgetModel defaultSubScreenWidgetModelFactory(
  BuildContext context,
) {
  final appScope = context.read<IAppScope>();
  final model = SubScreenModel(
    authBloc: appScope.authBloc,
    subscribeService: appScope.subscribeService,
  );
  return SubScreenWidgetModel(
    model,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class SubScreenWidgetModel extends WidgetModel<SubScreenWidget, SubScreenModel>
    implements ISubScreenWidgetModel {
  final StackRouter stackRouter;

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;
  final _tariffsState = UnionStateNotifier<List<TariffEntity>>.loading();

  SubScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  String get title => context.l10n.subscription;

  @override
  UnionStateNotifier<List<TariffEntity>> get tariffsState => _tariffsState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadTariffs());
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 403) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Нет доступа к ресурсу',
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Нет доступных тарифов',
        );
      } else if (error.response?.statusCode == 422) {
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

  @override
  void goBack() {
    stackRouter.pop();
  }

  Future<void> _loadTariffs() async {
    final previousData = tariffsState.value.data;
    tariffsState.loading(previousData);

    try {
      final tariffsData = await model.getTariffs();
      tariffsState.content(tariffsData);
    } on Exception catch (e) {
      tariffsState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
