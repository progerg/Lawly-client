import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/navigation/domain/enity/profile/profile_routes.dart';
import 'package:lawly/features/profile/presentation/screens/my_templates_screen/my_templates_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/my_templates_screen/my_templates_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IMyTemplatesScreenWidgetModel implements IWidgetModel {
  String get title;

  UnionStateNotifier<List<LocalTemplateEntity>> get templatesState;

  void onTapMyTemplate(LocalTemplateEntity template);

  void goBack();

  void onDeleteMyTemplate(int id);
}

MyTemplatesScreenWidgetModel defaultMyTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();

  final model = MyTemplatesScreenModel(
    saveUserService: appScope.saveUserService,
  );

  return MyTemplatesScreenWidgetModel(
    model,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class MyTemplatesScreenWidgetModel
    extends WidgetModel<MyTemplatesScreenWidget, MyTemplatesScreenModel>
    implements IMyTemplatesScreenWidgetModel {
  final StackRouter stackRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;
  final _templatesState =
      UnionStateNotifier<List<LocalTemplateEntity>>.loading();

  MyTemplatesScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadMyTemplates());
  }

  @override
  UnionStateNotifier<List<LocalTemplateEntity>> get templatesState =>
      _templatesState;

  @override
  String get title => context.l10n.my_templates;

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onTapMyTemplate(LocalTemplateEntity template) async {
    await stackRouter.push(
      createMyTemplateRoute(template: template),
    );
  }

  @override
  Future<void> onDeleteMyTemplate(int id) async {
    try {
      await model.removeLocalTemplate(id: id);
      _loadMyTemplates();
    } on Exception catch (e) {
      _templatesState.failure(e);
    }
  }

  Future<void> _loadMyTemplates() async {
    _templatesState.loading();

    try {
      final templates = await model.getMyTemplates();
      _templatesState.content(templates);
    } on Exception catch (e) {
      _templatesState.failure(e);
    }
  }
}
