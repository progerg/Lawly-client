import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawly/api/models/templates/generate_req_model.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/domain/entity/generate_req_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_model.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:union_state/union_state.dart';

abstract class ITemplateNoAuthScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<TemplateEntity> get templateState;

  Map<String, String> get fieldValues;

  String get title;

  bool get isAuthorized;

  void onFillField({required FieldEntity fieldEntity});

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
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class TemplateNoAuthScreenWidgetModel
    extends WidgetModel<TemplateNoAuthScreenWidget, TemplateNoAuthScreenModel>
    implements ITemplateNoAuthScreenWidgetModel {
  final StackRouter stackRouter;
  final AppRouter appRouter;
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _templateState = UnionStateNotifier<TemplateEntity>.loading();

  final Dio _dio = Dio();

  @override
  UnionStateNotifier<TemplateEntity> get templateState => _templateState;

  @override
  Map<String, String> get fieldValues => model.fieldValues;

  @override
  String get title => context.l10n.template_app_bar_title;

  @override
  bool get isAuthorized => model.authBloc.state.isAuthorized;

  TemplateNoAuthScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.appRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadTemplate());
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Шаблон не найден',
        );
      } else if (error.response?.statusCode == 422) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Ошибка валидации данных',
        );
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Проблемы с подключением к интернету',
        );
      } else {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          'Неизвестная ошибка',
        );
      }
    }
  }

  @override
  void goBack() {
    stackRouter.pop();
  }

  @override
  Future<void> onFillField({required FieldEntity fieldEntity}) async {
    final value = await stackRouter.push(
      createTemplateEditFieldRoute(
        fieldEntity: fieldEntity.copyWith(
          value: model.fieldValues[fieldEntity.name],
        ),
      ),
    );

    if (value != null && value is String) {
      model.fieldValues[fieldEntity.name] = value;
      // _templateState.content(_templateState.value.data!);
      log('Fields Map: ${model.fieldValues.toString()}');
    }
  }

  @override
  Future<void> onDownload() async {
    try {
      // Показываем индикатор загрузки
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );

      // final downloadUrl = widget.template.downloadUrl; // TODO 1
      // final downloadUrl = await model.templateService.getTemplateDownloadById(templateId: templateId); // TODO 2
      final downloadUrl =
          'https://s3.firstvds.ru/lawly-test/uploads/test.docx?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=3BFLCFOLWF578T5PES0U%2F20250504%2Fdefault%2Fs3%2Faws4_request&X-Amz-Date=20250504T234121Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=038146b3c7639d3f2ce0d42f6cc3df3b3e50b2d8599d33cedabe3d80071b3572';
      final fileName = _getFileNameFromUrl(downloadUrl) ?? 'document.docx';

      // Для Android: запрашиваем разрешения
      // if (Platform.isAndroid) {
      //   final status = await Permission.storage.request();
      //   if (!status.isGranted) {
      //     _showErrorMessage('Требуется разрешение на сохранение файлов');
      //     Navigator.of(context).pop(); // Закрываем индикатор загрузки
      //     return;
      //   }
      // }

      // Определяем директорию для сохранения
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        _showErrorMessage('Не удалось получить доступ к хранилищу устройства');
        Navigator.of(context).pop();
        return;
      }

      final savePath = '${directory.path}/$fileName';

      log('START DOWNLOAD');

      // Скачиваем файл
      await _dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Можно обновить прогресс, если нужно
            final progress = received / total;
            print('Загружено: ${(progress * 100).toStringAsFixed(0)}%');
          }
        },
      );

      // Закрываем диалог загрузки
      Navigator.of(context).pop();

      // Показываем успешное сообщение
      _showSuccessMessage('Файл сохранен в $savePath');

      // Предлагаем открыть файл
      final shouldOpen = await _showOpenFileDialog();
      if (shouldOpen == true) {
        await OpenFile.open(savePath);
      }
    } catch (e) {
      // Закрываем диалог загрузки
      Navigator.of(context).pop();
      _showErrorMessage('Ошибка при скачивании: $e');
    }
  }

  // Вспомогательные методы
  String? _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final path = uri.path;
    return path.split('/').last;
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

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<bool?> _showOpenFileDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Файл скачан'),
        content: const Text('Открыть файл сейчас?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  bool _areAllFieldsFilled({required TemplateEntity template}) {
    if (template.customFields == null || template.customFields!.isEmpty) {
      return true;
    }

    for (final field in template.customFields!) {
      if (!model.fieldValues.containsKey(field.name) ||
          model.fieldValues[field.name]!.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<void> onCreateDocument({required TemplateEntity template}) async {
    // if (!_areAllFieldsFilled(template: template)) {
    //   _scaffoldMessengerWrapper.showSnackBar(
    //     context,
    //     'Заполните все поля перед созданием документа',
    //   );
    //   return;
    // }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WillPopScope(
        onWillPop: () async =>
            false, // Предотвращаем закрытие по кнопке "назад"
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Создание документа...',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final fields = model.fieldValues.entries
          .map((e) => FilledFieldModel(name: e.key, value: e.value))
          .toList();

      final generateRequest = GenerateReqEntity(
        templateId: template.id,
        fields: fields,
      );

      log('generateRequest: ${GenerateReqModel.fromEntity(generateRequest).toJson()}');

      final response = await model.templateService.createDocument(
        templateId: template.id,
        customName: template.nameRu,
      );

      final fileBytes = await model.templateService.downloadTemplate(
        generateReqEntity: generateRequest,
        contentType:
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      );

      final directory = await _getDownloadDirectory();
      if (directory == null) {
        _showErrorMessage('Не удалось получить доступ к хранилищу устройства');
        return;
      }
      final newFilePath = '${directory.path}/${template.nameRu}.docx';
      final newFile = File(newFilePath);
      await newFile.writeAsBytes(fileBytes);

      await model.templateService.updateDocument(
        documentCreationId: response.id,
        status: 'completed',
        errorMessage: response.errorMessage,
      );

      Navigator.of(context).pop();

      await OpenFile.open(newFilePath);
    } catch (e) {
      _scaffoldMessengerWrapper.showSnackBar(
        context,
        'Ошибка при создании документа: $e', // TODO: убрать e
      );
    }
  }

  Future<void> _loadTemplate() async {
    final previousData = _templateState.value.data;
    _templateState.loading(previousData);

    try {
      final templateId = widget.template.id;
      final template =
          await model.templateService.getTemplateById(templateId: templateId);
      _templateState.content(template);
    } on Exception catch (e) {
      _templateState.failure(e, previousData);
      onErrorHandle(e);
    }
  }
}
