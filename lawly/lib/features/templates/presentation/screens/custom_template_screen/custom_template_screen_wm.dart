import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/presentation/screens/custom_template_screen/custom_template_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/custom_template_screen/custom_template_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ICustomTemplateScreenWidgetModel implements IWidgetModel {
  String get title;

  TextEditingController get controller;

  void goBack();

  void onImproveText();

  void onGenerateTemplate();
}

CustomTemplateScreenWidgetModel defaultCustomTemplateScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = CustomTemplateScreenModel(
    templateService: appScope.templateService,
    saveUserService: appScope.saveUserService,
  );
  return CustomTemplateScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
    l10n: context.l10n,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class CustomTemplateScreenWidgetModel
    extends WidgetModel<CustomTemplateScreenWidget, CustomTemplateScreenModel>
    implements ICustomTemplateScreenWidgetModel {
  CustomTemplateScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
    required this.l10n,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  final StackRouter stackRouter;
  final AppRouter appRouter;
  final AppLocalizations l10n;

  final _controller = TextEditingController();

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

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
          context.l10n.error_create_custom_template,
        );
      } else if (error.response?.statusCode == 403) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_access_for_execution,
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
  String get title => context.l10n.template_app_bar_title;

  @override
  TextEditingController get controller => _controller;

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onGenerateTemplate() async {
    try {
      _showLoaderOverlay();

      final fileBytes = await model.customTemplate(
        description: _controller.text,
      );

      final directory = await _getDownloadDirectory();
      if (directory == null) {
        _showErrorMessage(context.l10n.no_access_source);
        return;
      }
      // final firstWord = _controller.text.split(' ').first;
      final fileName =
          '${l10n.my_template} ${DateTime.now().millisecondsSinceEpoch}';
      final newFilePath = '${directory.path}/$fileName.docx';
      final newFile = File(newFilePath);
      await newFile.writeAsBytes(fileBytes);

      await model.saveLocalTemplates(
        template: LocalTemplateEntity(
          templateId: DateTime.now().millisecondsSinceEpoch,
          name:
              '${l10n.my_template} ${l10n.from} ${DateFormat('dd.MM.yy').format(DateTime.now())}',
          filePath: newFilePath,
          isEmpty: false,
        ),
      );

      _hideLoaderOverlay();

      await stackRouter.push(
        createTemplateDownloadRoute(
          filePath: newFilePath,
          fileBytes: fileBytes,
        ),
      );
    } catch (e) {
      _hideLoaderOverlay();
      onErrorHandle(e);
    }
  }

  @override
  Future<void> onImproveText() async {
    try {
      _showLoaderOverlay();

      final improvedTextEntity = await model.improveText(
        text: _controller.text,
      );

      _controller.text = improvedTextEntity.improvedText;

      _hideLoaderOverlay();
    } catch (e) {
      _hideLoaderOverlay();
      onErrorHandle(e);
    }
  }

  void _showLoaderOverlay() {
    context.loaderOverlay.show();
  }

  void _hideLoaderOverlay() {
    context.loaderOverlay.hide();
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getDownloadsDirectory();
  }

  void _showErrorMessage(String message) {
    _scaffoldMessengerWrapper.showSnackBar(
      context,
      message,
    );
  }
}
