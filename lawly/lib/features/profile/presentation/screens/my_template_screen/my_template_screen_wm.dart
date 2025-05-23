import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/profile/presentation/screens/my_template_screen/my_template_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/my_template_screen/my_template_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class IMyTemplateScreenWidgetModel implements IWidgetModel {
  String get title;

  void onDownload();

  void goBack();
}

MyTemplateScreenWidgetModel defaultMyTemplateScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();

  final model = MyTemplateScreenModel(
    templateService: appScope.templateService,
  );

  return MyTemplateScreenWidgetModel(
    model,
    stackRouter: context.router,
    l10n: context.l10n,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class MyTemplateScreenWidgetModel
    extends WidgetModel<MyTemplateScreenWidget, MyTemplateScreenModel>
    implements IMyTemplateScreenWidgetModel {
  final StackRouter stackRouter;
  final AppLocalizations l10n;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  MyTemplateScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.l10n,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

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
          context.l10n.error_download_template,
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.template_not_found,
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
  String get title => context.l10n.my_templates;

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onDownload() async {
    try {
      if (widget.template.isEmpty) {
        final fileBytes = await model.templateService.downloadEmptyTemplate(
          templateId: widget.template.templateId,
        );

        final directory = await _getDownloadDirectory();
        if (directory == null) {
          _scaffoldMessengerWrapper.showSnackBar(
            context,
            l10n.no_access_source,
          );
          return;
        }
        final newFilePath = '${directory.path}/${widget.template.name}.docx';
        final newFile = File(newFilePath);
        await newFile.writeAsBytes(fileBytes);

        await OpenFile.open(newFilePath);
      } else {
        await OpenFile.open(widget.template.filePath);
      }
    } on Exception catch (e) {
      onErrorHandle(e);
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getDownloadsDirectory();
  }
}
