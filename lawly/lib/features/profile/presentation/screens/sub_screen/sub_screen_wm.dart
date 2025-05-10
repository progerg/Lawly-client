import 'dart:async';
import 'dart:developer';
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

  void onSetTariff(int tariffId);

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
      if (error.response?.statusCode == 401) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_access_resource,
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_tariffs,
        );
      } else if (error.response?.statusCode == 409) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_expire_subscription,
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
  Future<void> onSetTariff(int tariffId) async {
    try {
      await model.setSubscribe(tariffId: tariffId);
      stackRouter.pop(true); // передаем true, то есть оформелна подписка
    } on Exception catch (e) {
      onErrorHandle(e);
    }
  }

  @override
  void goBack() {
    stackRouter.pop();
  }

  Future<void> _loadTariffs() async {
    final previousData = _tariffsState.value.data;
    _tariffsState.loading(previousData);

    try {
      final tariffsData = await model.getTariffs();
      // log('Tafiffs: ${tariffsData[0].name} ${tariffsData[0].customTemplates} ${tariffsData[1].name} ${tariffsData[1].customTemplates}');
      tariffsData.sort((a, b) => a.price.compareTo(b.price));
      _tariffsState.content(tariffsData);
    } on Exception catch (e) {
      _tariffsState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
