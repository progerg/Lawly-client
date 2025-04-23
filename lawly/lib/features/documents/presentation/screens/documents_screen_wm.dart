import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_model.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_widget.dart';

abstract class IDocumentsScreenWidgetModel implements IWidgetModel {}

DocumentsScreenWidgetModel defaultDocumentsScreenWidgetModelFactory(
    BuildContext context) {
  final model = DocumentsScreenModel();
  return DocumentsScreenWidgetModel(model);
}

class DocumentsScreenWidgetModel
    extends WidgetModel<DocumentsScreenWidget, DocumentsScreenModel>
    implements IDocumentsScreenWidgetModel {
  DocumentsScreenWidgetModel(super.model);
}
