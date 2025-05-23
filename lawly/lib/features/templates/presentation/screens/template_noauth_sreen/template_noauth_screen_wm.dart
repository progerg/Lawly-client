import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lawly/api/models/templates/document_creation_model.dart';
import 'package:lawly/api/models/templates/generate_req_model.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_routes.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/domain/entity/generate_req_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:union_state/union_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ITemplateNoAuthScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<TemplateEntity> get templateState;

  UnionStateNotifier<Map<String, String>> get fieldValuesState;

  /// для получения документов (возможно уже заполненных ранее)
  UnionStateNotifier<List<DocEntity>> get documentState;

  String get title;

  bool get isAuthorized;

  void onFillField({
    required FieldEntity fieldEntity,
    required List<FieldEntity> fields,
  });

  void onFillDocument({
    required DocEntity document,
  });

  void onDownload();

  void onCreateDocument({required TemplateEntity template});

  void goBack();
}

TemplateNoAuthScreenWidgetModel defaultTemplateNoAuthScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = TemplateNoAuthScreenModel(
    authBloc: appScope.authBloc,
    tokenLocalDataSource: appScope.tokenLocalDataSource,
    saveUserService: appScope.saveUserService,
    templateService: appScope.templateService,
  );
  return TemplateNoAuthScreenWidgetModel(
    model,
    stackRouter: context.router,
    appRouter: appScope.router,
    l10n: context.l10n,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class TemplateNoAuthScreenWidgetModel
    extends WidgetModel<TemplateNoAuthScreenWidget, TemplateNoAuthScreenModel>
    implements ITemplateNoAuthScreenWidgetModel {
  final StackRouter stackRouter;
  final AppRouter appRouter;
  final AppLocalizations l10n;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _templateState = UnionStateNotifier<TemplateEntity>.loading();

  final _fieldValuesState = UnionStateNotifier<Map<String, String>>({});

  final _documentState = UnionStateNotifier<List<DocEntity>>([]);

  @override
  UnionStateNotifier<TemplateEntity> get templateState => _templateState;

  @override
  UnionStateNotifier<Map<String, String>> get fieldValuesState =>
      _fieldValuesState;

  @override
  UnionStateNotifier<List<DocEntity>> get documentState => _documentState;

  @override
  String get title => context.l10n.template_app_bar_title;

  @override
  bool get isAuthorized => model.authBloc.state.isAuthorized;

  TemplateNoAuthScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.appRouter,
    required this.l10n,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadTemplate());

    unawaited(AppMetrica.reportEvent('template_screen_opened'));
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 400) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_download_template,
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.template_not_found,
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_validation_data,
        );
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.error_connection_problems,
        );
      } else {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.unknown_error,
        );
      }
    }
  }

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onFillField({
    required FieldEntity fieldEntity,
    required List<FieldEntity> fields,
  }) async {
    final value = await stackRouter.root.push(
      createTemplateEditFieldRoute(
        fieldEntity: fieldEntity.copyWith(
          value: model.fieldValues[fieldEntity.name],
        ),
      ),
    );

    if (value != null && value is String) {
      model.fieldValues[fieldEntity.name] = value;

      final updatedValues = Map<String, String>.from(model.fieldValues);

      _fieldValuesState.content(updatedValues);

      // Отерытие следующего окна поля, если оно не заполнены
      if (model.fieldValues.length != fields.length) {
        for (final field in fields) {
          if (!model.fieldValues.containsKey(field.name)) {
            return await onFillField(fieldEntity: field, fields: fields);
          }
        }
      } else {
        return;
      }

      // log('Fields Map: ${model.fieldValues.toString()}');
    }
  }

  @override
  Future<void> onFillDocument({required DocEntity document}) async {
    final fields = await stackRouter.root.push(
      createDocumentEditRoute(
        document: document,
      ),
    );
    if (fields != null && fields is List<FieldEntity>) {
      final updatedDocument = document.copyWith(
        fields: fields,
        isPersonal: false,
      );

      final currentDocuments = _documentState.value.data ?? [];

      final updatedDocuments = currentDocuments.map((doc) {
        return doc.id == updatedDocument.id ? updatedDocument : doc;
      }).toList();

      _documentState.content(updatedDocuments);

      for (final doc in updatedDocuments) {
        if (!_isFullFillDocument(doc)) {
          return await onFillDocument(document: doc);
        }
      }
      return;
    }
  }

  bool _isFullFillDocument(DocEntity document) =>
      document.fields?.every(
        (field) => field.value != null && field.value!.isNotEmpty,
      ) ??
      false;

  @override
  Future<void> onDownload() async {
    try {
      final fileBytes = await model.templateService.downloadEmptyTemplate(
        templateId: widget.template.id,
      );

      final directory = await _getDownloadDirectory();
      if (directory == null) {
        _showErrorMessage(l10n.no_access_source);
        return;
      }
      final newFilePath = '${directory.path}/${widget.template.name}.docx';
      final newFile = File(newFilePath);
      await newFile.writeAsBytes(fileBytes);

      await OpenFile.open(newFilePath);
    } on Exception catch (e) {
      onErrorHandle(e);
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getDownloadsDirectory();
  }

  void _showErrorMessage(String message) {
    _scaffoldMessengerWrapper.showSnackBar(
      context,
      message,
    );
  }

  // bool _areAllFieldsFilled({required TemplateEntity template}) {
  //   if (template.customFields == null || template.customFields!.isEmpty) {
  //     return true;
  //   }

  //   for (final field in template.customFields!) {
  //     if (!model.fieldValues.containsKey(field.name) ||
  //         model.fieldValues[field.name]!.isEmpty) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  @override
  Future<void> onCreateDocument({required TemplateEntity template}) async {
    try {
      _showLoaderOverlay();

      final customFields = model.fieldValues.entries
          .map((e) => FilledFieldEntity(name: e.key, value: e.value))
          .toList();

      List<FilledFieldEntity> documentFields = [];
      for (final DocEntity document in _documentState.value.data ?? []) {
        documentFields.addAll(
          document.fields?.map(
                (field) => FilledFieldEntity(
                  name: field.name,
                  value: field.value ?? '',
                ),
              ) ??
              [],
        );
      }

      final countAllFields = template.customFields?.length ?? 0;
      final countFilledFields = customFields.length;

      if (countFilledFields / countAllFields <= 0.2) {
        AppMetrica.reportEvent('filled_fields_less_20_percent');
      } else if (countFilledFields / countAllFields > 0.2 &&
          countFilledFields / countAllFields <= 0.6) {
        AppMetrica.reportEvent('filled_fields_less_60_percent');
      } else if (countFilledFields / countAllFields == 1) {
        AppMetrica.reportEvent('filled_fields_100_percent');
      }

      final allFields = [...customFields, ...documentFields];

      final generateRequest = GenerateReqEntity(
        templateId: template.id,
        fields: allFields,
      );

      log('generateRequest: ${GenerateReqModel.fromEntity(generateRequest).toJson()}');

      final response = await model.templateService.createDocument(
        templateId: template.id,
        customName: template.nameRu,
      );
      try {
        AppMetrica.reportEvent('generate_template');

        await model.templateService.updateDocument(
          documentCreationId: response.id,
          status: DocumentCreationStatus.started,
          errorMessage: response.errorMessage,
        );

        final fileBytes = await model.templateService.downloadTemplate(
          generateReqEntity: generateRequest,
        );

        final directory = await _getDownloadDirectory();
        if (directory == null) {
          _showErrorMessage(
            context.l10n.no_access_source,
          );
          _hideLoaderOverlay();
          return;
        }
        final newFilePath =
            '${directory.path}/${template.nameRu} ${DateTime.now().millisecondsSinceEpoch}.docx';
        final newFile = File(newFilePath);
        await newFile.writeAsBytes(fileBytes);

        await model.templateService.updateDocument(
          documentCreationId: response.id,
          status: DocumentCreationStatus.completed,
          errorMessage: response.errorMessage,
        );

        await model.saveUserService.saveLocalTemplates(
          template: LocalTemplateEntity(
            templateId: DateTime.now().millisecondsSinceEpoch,
            name:
                '${template.nameRu} ${l10n.from} ${DateFormat('dd.MM.yy').format(DateTime.now())}',
            filePath: newFilePath,
            imageUrl: template.imageUrl,
            isEmpty: false,
          ),
        );

        _hideLoaderOverlay();

        await stackRouter.push(
          createTemplateDownloadRoute(
            filePath: newFilePath,
            fileBytes: fileBytes,
            imageUrl: template.imageUrl,
          ),
        );
      } catch (e) {
        await model.templateService.updateDocument(
          documentCreationId: response.id,
          status: DocumentCreationStatus.error,
          errorMessage: response.errorMessage,
        );
        rethrow;
      }
    } catch (e) {
      // _scaffoldMessengerWrapper.showSnackBar(
      //   context,
      //   'Ошибка при создании документа: $e', // TODO: убрать e
      // );
      _hideLoaderOverlay();
      onErrorHandle(e);
    }
  }

  Future<void> _loadTemplate() async {
    final localDocuments = model.saveUserService.getPersonalDocuments();

    final localDocsMap = {for (var doc in localDocuments) doc.id: doc};

    final previousData = _templateState.value.data;
    _templateState.loading(previousData);

    try {
      // Получение шаблона
      final templateId = widget.template.id;
      final template =
          await model.templateService.getTemplateById(templateId: templateId);

      // Получение документов (возможно уже заполненных ранее)
      final documents = (template.requiredDocuments ?? []).map((document) {
        if (document.isPersonal) {
          return localDocsMap[document.id] ?? document;
        }
        return document;
      }).toList();

      _templateState.content(template);
      _documentState.content(documents);
    } on Exception catch (e) {
      _templateState.failure(e, previousData);
      onErrorHandle(e);
    }
  }

  void _showLoaderOverlay() {
    context.loaderOverlay.show();
  }

  void _hideLoaderOverlay() {
    context.loaderOverlay.hide();
  }
}
