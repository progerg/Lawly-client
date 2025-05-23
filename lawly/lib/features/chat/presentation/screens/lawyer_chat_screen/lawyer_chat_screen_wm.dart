import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_message_entity.dart';
import 'package:lawly/features/chat/presentation/screens/lawyer_chat_screen/lawyer_chat_screen_model.dart';
import 'package:lawly/features/chat/presentation/screens/lawyer_chat_screen/lawyer_chat_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ILawyerChatScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<LawyerMessageEntity>> get lawyerMessagesState;

  ScrollController get scrollController;

  String get title;

  void onGoToAiChatScreen();

  void onOpenFile(int messageId);
}

LawyerChatScreenWidgetModel defaultLawyerChatScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();
  final model = LawyerChatScreenModel(
    chatService: appScope.chatService,
  );
  return LawyerChatScreenWidgetModel(
    model,
    stackRouter: context.router,
    l10n: context.l10n,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class LawyerChatScreenWidgetModel
    extends WidgetModel<LawyerChatScreenWidget, LawyerChatScreenModel>
    implements ILawyerChatScreenWidgetModel {
  final StackRouter stackRouter;
  final AppLocalizations l10n;

  final _lawyerMessagesState =
      UnionStateNotifier<List<LawyerMessageEntity>>.loading();

  final ScrollController _scrollController = ScrollController();

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  bool _isLoadingMessages = false;

  int _offset = 0;

  @override
  String get title => context.l10n.lawyers_feedbacks;

  @override
  UnionStateNotifier<List<LawyerMessageEntity>> get lawyerMessagesState =>
      _lawyerMessagesState;

  @override
  ScrollController get scrollController => _scrollController;

  LawyerChatScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required this.l10n,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _setupScrollListener();

    unawaited(_loadLawyerMessages());
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException) {
      if (error.response?.statusCode == 403) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.access_banned,
        );
      } else if (error.response?.statusCode == 404) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.requests_not_found,
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Future<void> onGoToAiChatScreen() async {
    stackRouter.pop();
  }

  @override
  Future<void> onOpenFile(int messageId) async {
    _showLoaderOverlay();

    try {
      final fileBytes = await model.getLawyerDocuments(messageId: messageId);

      final directory = await _getDownloadDirectory();

      final newFilePath =
          '${directory!.path}/${l10n.doc_from_lawyer} ${DateTime.now().millisecondsSinceEpoch}.docx';
      final newFile = File(newFilePath);
      await newFile.writeAsBytes(fileBytes);

      _hideLoaderOverlay();

      await OpenFile.open(newFilePath);
    } catch (e) {
      _hideLoaderOverlay();
      _scaffoldMessengerWrapper.showSnackBar(
        context,
        l10n.file_open_error,
      );
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

  void _showLoaderOverlay() {
    context.loaderOverlay.show();
  }

  void _hideLoaderOverlay() {
    context.loaderOverlay.hide();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMessages) {
        _loadLawyerMessages();
      }
    });
  }

  Future<void> _loadLawyerMessages() async {
    // Защита от параллельных загрузок
    if (_isLoadingMessages) return;
    _isLoadingMessages = true;

    final previousData = _lawyerMessagesState.value.data;
    _lawyerMessagesState.loading(previousData);

    try {
      final currentDate = DateTime.now();
      final totalMessages = await model.getLawyerMessages(
        startDate: currentDate
            .subtract(Duration(days: _offset + model.defaultLimit))
            .toString(),
        endDate: currentDate.subtract(Duration(days: _offset)).toString(),
      );

      // Проверка, нужно ли продолжать загрузку
      if ((previousData?.length ?? 0) < totalMessages.total) {
        _offset += model.defaultLimit;
      } else {
        // Если больше нет сообщений, просто возвращаем текущий список
        if (totalMessages.responses.isEmpty && previousData == null) {
          _lawyerMessagesState.content(
            [
              LawyerMessageEntity(
                messageId: -2,
                note: l10n.lawyer_welocome,
                hasFile: false,
              ),
            ],
          );
        }
        if (previousData != null) {
          _lawyerMessagesState.content(previousData);
        }
        _isLoadingMessages = false;
        return;
      }

      final oldMessages = totalMessages.responses;

      // Проверка на дубликаты по ID
      // final existingIds =
      //     previousData?.map((msg) => msg.messageId).toSet() ?? <int>{};
      // final uniqueMessages = oldMessages
      //     .where((msg) => !existingIds.contains(msg.messageId))
      //     .toList();
      List<LawyerMessageEntity> updatedMessages;
      if (oldMessages.isEmpty && previousData == null) {
        updatedMessages = [
          LawyerMessageEntity(
            messageId: -2,
            note: l10n.lawyer_welocome,
            hasFile: false,
          ),
        ];
      } else if (previousData != null) {
        updatedMessages = [
          ...previousData,
          // ...uniqueMessages,
          ...oldMessages,
        ];
      } else {
        updatedMessages = oldMessages;
      }

      _lawyerMessagesState.content(updatedMessages);
    } on Exception catch (e) {
      _lawyerMessagesState.failure(e, previousData);
      onErrorHandle(e);
    } finally {
      _isLoadingMessages = false;
    }
  }
}
