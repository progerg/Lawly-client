import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/auth/presentation/screens/privacy_policy_screen/privacy_policy_screen_model.dart';
import 'package:lawly/features/auth/presentation/screens/privacy_policy_screen/privacy_policy_screen_widget.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IPrivacyPolicyScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<String> get privacyPolicyState;

  void goBack();
}

PrivacyPolicyScreenWidgetModel defaultPrivacyPolicyScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();

  final model = PrivacyPolicyScreenModel(
    documentsService: appScope.documentsService,
  );

  return PrivacyPolicyScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class PrivacyPolicyScreenWidgetModel
    extends WidgetModel<PrivacyPolicyScreenWidget, PrivacyPolicyScreenModel>
    implements IPrivacyPolicyScreenWidgetModel {
  final AppRouter appRouter;
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _privacyPolicyState = UnionStateNotifier<String>.loading();

  @override
  UnionStateNotifier<String> get privacyPolicyState => _privacyPolicyState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    unawaited(_loadPrivacyPolicy());
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException &&
        (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError ||
            error.error is SocketException)) {
      _scaffoldMessengerWrapper.showSnackBar(
        context,
        context.l10n.error_connection_problems,
      );
    }
  }

  PrivacyPolicyScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  Future<void> _loadPrivacyPolicy() async {
    final previousData = _privacyPolicyState.value.data;
    _privacyPolicyState.loading(previousData);

    try {
      final privacyPolicyData = await model.getPrivacyPolicy();
      _privacyPolicyState.content(privacyPolicyData.content);
    } on Exception catch (e) {
      _privacyPolicyState.failure(e, previousData);
      onErrorHandle(e);
    }
  }

  @override
  void goBack() {
    stackRouter.pop();
  }
}
