import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_model.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_widget.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IDocumentEditScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<FieldEntity>> get fieldsState;

  String get title;

  void onApproveChanges();

  void goBack();
}

DocumentEditScreenWidgetModel defaultDocumentEditScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = DocumentEditScreenModel(
    saveUserService: appScope.saveUserService,
    personalDocumentsService: appScope.personalDocumentsService,
  );
  return DocumentEditScreenWidgetModel(
    model,
    stackRouter: context.router,
  );
}

class DocumentEditScreenWidgetModel
    extends WidgetModel<DocumentEditScreenWidget, DocumentEditScreenModel>
    implements IDocumentEditScreenWidgetModel {
  final StackRouter stackRouter;

  final _fieldsState = UnionStateNotifier<List<FieldEntity>>.loading();

  @override
  String get title => widget.document.nameRu;

  @override
  UnionStateNotifier<List<FieldEntity>> get fieldsState => _fieldsState;

  DocumentEditScreenWidgetModel(
    super.model, {
    required this.stackRouter,
  });

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(
      widget.document.isPersonal ? _loadFieldsForPersonalDoc() : _loadFields(),
    );
  }

  @override
  void onApproveChanges() {
    stackRouter.pop(widget.document);
  }

  @override
  void goBack() {
    stackRouter.pop();
  }

  Future<void> _loadFieldsForPersonalDoc() async {
    final localDocuments = model.saveUserService.getPersonalDocuments();
    final localDocument = localDocuments
        .where(
          (element) => element.id == widget.document.id,
        )
        .firstOrNull;

    try {
      final remoteDocument = await model.getPersonalDocumentById(
        id: widget.document.id,
      );

      if (localDocument != null && localDocument.fields != null) {
        final localFields = {
          for (var field in localDocument.fields!) field.id: field,
        };
        final mergedFields = remoteDocument.fields?.map((remoteField) {
          final localField = localFields[remoteField.id];
          if (localField != null) {
            return localField;
          }
          return remoteField;
        }).toList();

        _fieldsState.content(mergedFields ?? []);
      } else {
        _fieldsState.content(remoteDocument.fields ?? []);
      }
    } on Exception catch (e) {
      log('Error: ${e.toString()}');
      _fieldsState.failure(e, localDocument?.fields ?? []);
    }
  }

  Future<void> _loadFields() async {
    try {
      final remoteDocument = await model.getPersonalDocumentById(
        id: widget.document.id,
      );

      _fieldsState.content(remoteDocument.fields ?? []);
    } on Exception catch (e) {
      log('Error: ${e.toString()}');
      _fieldsState.failure(e, []);
    }
  }
}
