import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';

abstract class ITemplatesScreenWidgetModel implements IWidgetModel {}

TemplatesScreenWidgetModel defaultTemplatesScreenWidgetModelFactory(
    BuildContext context) {
  final model = TemplatesScreenModel();
  return TemplatesScreenWidgetModel(model);
}

class TemplatesScreenWidgetModel
    extends WidgetModel<TemplatesScreenWidget, TemplatesScreenModel>
    implements ITemplatesScreenWidgetModel {
  TemplatesScreenWidgetModel(super.model);
}
