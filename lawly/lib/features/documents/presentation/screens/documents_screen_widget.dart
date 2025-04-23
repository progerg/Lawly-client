import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
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
      body: Center(
        child: Text(
          'Documents Screen',
        ),
      ),
    );
  }
}
