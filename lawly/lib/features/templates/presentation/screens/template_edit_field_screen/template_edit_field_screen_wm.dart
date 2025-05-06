import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_widget.dart';

abstract class ITemplateEditFieldScreenWidgetModel implements IWidgetModel {
  TextEditingController get textEditingController;

  void onEnter();

  void goBack();
}

TemplateEditFieldScreenWidgetModel
    defaultTemplateEditFieldScreenWidgetModelFactory(BuildContext context) {
  final model = TemplateEditFieldScreenModel();
  return TemplateEditFieldScreenWidgetModel(
    model,
    stackRouter: context.router,
  );
}

class TemplateEditFieldScreenWidgetModel extends WidgetModel<
        TemplateEditFieldScreenWidget, TemplateEditFieldScreenModel>
    implements ITemplateEditFieldScreenWidgetModel {
  final StackRouter stackRouter;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  TextEditingController get textEditingController => _textEditingController;

  TemplateEditFieldScreenWidgetModel(
    super.model, {
    required this.stackRouter,
  });

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _textEditingController.text = widget.fieldEntity.value ?? '';
  }

  @override
  void onEnter() {
    stackRouter.pop(_textEditingController.text);
  }

  @override
  void goBack() {
    stackRouter.pop();
  }
}
