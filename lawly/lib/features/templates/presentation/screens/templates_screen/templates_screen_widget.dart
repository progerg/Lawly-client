import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_wm.dart';

@RoutePage()
class TemplatesScreenWidget
    extends ElementaryWidget<ITemplatesScreenWidgetModel> {
  const TemplatesScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultTemplatesScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITemplatesScreenWidgetModel wm) {
    return Scaffold(
      body: Center(
        child: Text(
          'Templates Screen',
        ),
      ),
    );
  }
}
