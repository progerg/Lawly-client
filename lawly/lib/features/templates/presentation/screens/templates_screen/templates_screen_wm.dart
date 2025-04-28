import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';

abstract class ITemplatesScreenWidgetModel implements IWidgetModel {
  String get title;
}

TemplatesScreenWidgetModel defaultTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final model = TemplatesScreenModel();
  return TemplatesScreenWidgetModel(model);
}

class TemplatesScreenWidgetModel
    extends WidgetModel<TemplatesScreenWidget, TemplatesScreenModel>
    implements ITemplatesScreenWidgetModel {
  @override
  String get title => context.l10n.template_app_bar_title;

  TemplatesScreenWidgetModel(super.model);
}
