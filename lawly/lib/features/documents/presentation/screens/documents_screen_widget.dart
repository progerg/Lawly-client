import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_wm.dart';

@RoutePage()
class DocumentsScreenWidget
    extends ElementaryWidget<IDocumentsScreenWidgetModel> {
  const DocumentsScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultDocumentsScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IDocumentsScreenWidgetModel wm) {
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
          'Documents Screen',
        ),
      ),
    );
  }
}
