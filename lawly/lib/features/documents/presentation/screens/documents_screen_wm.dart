import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_model.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';

abstract class IDocumentsScreenWidgetModel implements IWidgetModel {
  String get title;
}

DocumentsScreenWidgetModel defaultDocumentsScreenWidgetModelFactory(
    BuildContext context) {
  final model = DocumentsScreenModel();
  return DocumentsScreenWidgetModel(model);
}

class DocumentsScreenWidgetModel
    extends WidgetModel<DocumentsScreenWidget, DocumentsScreenModel>
    implements IDocumentsScreenWidgetModel {
  @override
  String get title => context.l10n.document_app_bar_title;

  DocumentsScreenWidgetModel(super.model);
}
