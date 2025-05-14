import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_model.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_widget.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_routes.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IDocumentsScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<DocEntity>> get documentsState;

  String get title;

  void onOpenEditDocument(DocEntity document);
}

DocumentsScreenWidgetModel defaultDocumentsScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = DocumentsScreenModel(
    saveUserService: appScope.saveUserService,
    personalDocumentsService: appScope.personalDocumentsService,
  );
  return DocumentsScreenWidgetModel(
    model,
    stackRouter: context.router,
  );
}

class DocumentsScreenWidgetModel
    extends WidgetModel<DocumentsScreenWidget, DocumentsScreenModel>
    implements IDocumentsScreenWidgetModel {
  final StackRouter stackRouter;

  final _documentsState = UnionStateNotifier<List<DocEntity>>.loading();

  @override
  String get title => context.l10n.document_app_bar_title;

  @override
  UnionStateNotifier<List<DocEntity>> get documentsState => _documentsState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    unawaited(_loadDocuments());
  }

  DocumentsScreenWidgetModel(
    super.model, {
    required this.stackRouter,
  });

  @override
  Future<void> onOpenEditDocument(DocEntity document) async {
    final fields = await stackRouter.root.push(
      createDocumentEditRoute(
        document: document,
      ),
    );
    if (fields != null && fields is List<FieldEntity>) {
      final updatedDocument = document.copyWith(fields: fields);

      // Получаем текущий список документов
      final currentDocuments = model.saveUserService.getPersonalDocuments();

      // Создаем обновленный список документов, заменяя старый на новый
      final updatedDocuments = currentDocuments.map((doc) {
        return doc.id == updatedDocument.id ? updatedDocument : doc;
      }).toList();

      // Сохраняем обновленный список
      await model.saveUserService.savePersonalDocuments(
        documents: updatedDocuments,
      );

      // Обновляем UI
      _documentsState.content(updatedDocuments);
    }
  }

  Future<void> _loadDocuments() async {
    final localDocuments = model.saveUserService.getPersonalDocuments();
    _documentsState.loading(localDocuments);
    try {
      final remoteDocuments = await model.getPersonalDocuments();

      // TODO: выбрать через where() чтобы только добавлялись персональные (isPersonal = true)
      final remotePersonalDocuments =
          remoteDocuments.where((doc) => doc.isPersonal).toList();

      final localDocsMap = {for (var doc in localDocuments) doc.id: doc};

      final mergedDocuments = remotePersonalDocuments.map((remoteDoc) {
        // Если документ есть локально - возвращаем его, иначе - документ с бэкенда
        return localDocsMap[remoteDoc.id] ?? remoteDoc;
      }).toList();

      _documentsState.content(mergedDocuments);

      await model.saveUserService.savePersonalDocuments(
        documents: mergedDocuments,
      );
    } on Exception catch (e) {
      _documentsState.failure(e, localDocuments);
    }
  }
}
