import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
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
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Templates Screen',
        ),
      ),
    );
  }
}
