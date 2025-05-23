import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

abstract class ITemplateEditFieldScreenWidgetModel implements IWidgetModel {
  TextEditingController get textEditingController;

  void onEnter();

  void onImproveText();

  void goBack();
}

TemplateEditFieldScreenWidgetModel
    defaultTemplateEditFieldScreenWidgetModelFactory(BuildContext context) {
  final appScope = context.read<IAppScope>();

  final model = TemplateEditFieldScreenModel(
    templateService: appScope.templateService,
  );

  return TemplateEditFieldScreenWidgetModel(
    model,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class TemplateEditFieldScreenWidgetModel extends WidgetModel<
        TemplateEditFieldScreenWidget, TemplateEditFieldScreenModel>
    implements ITemplateEditFieldScreenWidgetModel {
  final StackRouter stackRouter;

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  TextEditingController get textEditingController => _textEditingController;

  TemplateEditFieldScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _textEditingController.text = widget.fieldEntity.value ?? '';
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 400) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_when_improve_text,
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
  void onEnter() {
    stackRouter.pop(_textEditingController.text);
  }

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onImproveText() async {
    try {
      _showLoaderOverlay();

      final improvedTextEntity = await model.improveText(
        text: _textEditingController.text,
      );

      _textEditingController.text = improvedTextEntity.improvedText;

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
}
