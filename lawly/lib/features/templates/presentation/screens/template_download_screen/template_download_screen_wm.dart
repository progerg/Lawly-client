import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/di/app_scope.dart';
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

  void onDownload();
}

TemplateDownloadScreenWidgetModel
    defaultTemplateDownloadScreenWidgetModelFactory(BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplateDownloadScreenModel();
  return TemplateDownloadScreenWidgetModel(
    model,
    appRouter: appScope.router,
    stackRouter: context.router,
  );
}

class TemplateDownloadScreenWidgetModel extends WidgetModel<
    TemplateDownloadScreenWidget,
    TemplateDownloadScreenModel> implements ITemplateDownloadScreenWidgetModel {
  TemplateDownloadScreenWidgetModel(
    super.model, {
    required this.appRouter,
    required this.stackRouter,
  });

  final StackRouter stackRouter;
  final AppRouter appRouter;

  final _controller = TextEditingController();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
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
  Future<void> onDownload() async {
    await OpenFile.open(widget.filePath);
  }
}
