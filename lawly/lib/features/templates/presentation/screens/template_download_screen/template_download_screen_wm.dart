import 'dart:developer';
import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/presentation/screens/template_download_screen/template_download_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/template_download_screen/template_download_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

abstract class ITemplateDownloadScreenWidgetModel implements IWidgetModel {
  String get title;

  TextEditingController get controller;

  void goBack();

  void onSendLawyer();

  void onDownload();
}

TemplateDownloadScreenWidgetModel
    defaultTemplateDownloadScreenWidgetModelFactory(BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplateDownloadScreenModel(
    chatService: appScope.chatService,
  );
  return TemplateDownloadScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class TemplateDownloadScreenWidgetModel extends WidgetModel<
    TemplateDownloadScreenWidget,
    TemplateDownloadScreenModel> implements ITemplateDownloadScreenWidgetModel {
  TemplateDownloadScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  final StackRouter stackRouter;
  final AppRouter appRouter;

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _controller = TextEditingController();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 400) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.uncorrect_request,
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_validation_data,
        );
      } else if (error.response?.statusCode == 500) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.server_error,
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
          context.l10n.no_access_resource, // вместо неизвестной ошибки
        );
      }
    }
  }

  @override
  String get title => context.l10n.template_app_bar_title;

  @override
  TextEditingController get controller => _controller;

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onSendLawyer() async {
    try {
      AppMetrica.reportEvent('send_to_lawyer');

      final response = await model.createLawyerRequest(
        lawyerReqCreateEntity: LawyerReqCreateEntity(
          description: _controller.text,
          documentBytes: widget.fileBytes,
        ),
      );
      log('response: $response');
      _scaffoldMessengerWrapper.showSnackBar(
        context,
        context.l10n.sended_to_lawyer,
      );
    } catch (e) {
      onErrorHandle(e);
    }
  }

  @override
  Future<void> onDownload() async {
    await OpenFile.open(widget.filePath);
  }
}
