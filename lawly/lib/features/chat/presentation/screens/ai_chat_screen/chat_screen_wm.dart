import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';
import 'package:lawly/features/chat/presentation/screens/ai_chat_screen/chat_screen_widget.dart';
import 'package:lawly/features/chat/presentation/screens/ai_chat_screen/chat_screen_model.dart';
import 'package:lawly/features/navigation/domain/enity/chat/chat_routes.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:union_state/union_state.dart';

abstract class IChatScreenWidgetModel implements IWidgetModel {
  UnionStateNotifier<List<MessageEntity>> get messagesState;

  ScrollController get scrollController;

  TextEditingController get textController;

  String get title;

  void onSend();

  void onGoToLawyerChatScreen();
}

ChatScreenWidgetModel defaultChatScreenWidgetModelFactory(
    BuildContext context) {
  final appScope = context.read<IAppScope>();

  final model = ChatScreenModel(
    chatService: appScope.chatService,
    webSocketService: appScope.webSocketService,
  );
  return ChatScreenWidgetModel(
    model,
    stackRouter: context.router,
    scaffoldMessengerWrapper: appScope.scaffoldMessengerWrapper,
  );
}

class ChatScreenWidgetModel
    extends WidgetModel<ChatScreenWidget, ChatScreenModel>
    implements IChatScreenWidgetModel {
  final StackRouter stackRouter;

  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _messagesState = UnionStateNotifier<List<MessageEntity>>.loading();

  final _scrollController = ScrollController();

  final _textController = TextEditingController();

  int _offset = 0;

  bool _isLoadingMessages = false;

  // Добавляем подписку на WebSocket
  StreamSubscription? _webSocketSubscription;

  @override
  String get title => context.l10n.ai_consult;

  @override
  UnionStateNotifier<List<MessageEntity>> get messagesState => _messagesState;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  TextEditingController get textController => _textController;

  ChatScreenWidgetModel(
    super.model, {
    required this.stackRouter,
    required ScaffoldMessengerWrapper scaffoldMessengerWrapper,
  }) : _scaffoldMessengerWrapper = scaffoldMessengerWrapper;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadMessages());

    _setupScrollListener();

    unawaited(_initWebSocketConnection());
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
      } else if (error.response?.statusCode == 409) {
        _scaffoldMessengerWrapper.showSnackBar(
          context,
          context.l10n.no_sub_with_functions,
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
    _webSocketSubscription?.cancel();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Future<void> onSend() async {
    final unhandleText = _textController.text.trim();

    if (unhandleText.isEmpty) {
      return;
    }
    _textController.clear();

    try {
      if (!model.webSocketService.isConnected) {
        await model.webSocketService.connect();
      }

      final newMessage = MessageEntity(
        id: 0,
        senderType: "user",
        senderId: 123,
        content: unhandleText,
        createdAt: DateTime.now().toIso8601String(),
        status: "sending",
      );

      final previousData = _messagesState.value.data;
      _messagesState.loading(previousData);
      List<MessageEntity> updatedMessages;
      if (previousData != null) {
        updatedMessages = [
          newMessage,
          ...previousData,
        ];
      } else {
        updatedMessages = [newMessage];
      }
      _messagesState.content(updatedMessages);

      await model.webSocketService.sendMessage(unhandleText);
    } catch (e) {
      log('Ошибка отправки сообщения: $e');
      _scaffoldMessengerWrapper.showSnackBar(
        context,
        context.l10n.error_connection_problems,
      );
    }

    // final newAnswer = MessageEntity(
    //   id: 0,
    //   senderType: "bot",
    //   senderId: 999,
    //   content: text,
    //   createdAt: DateTime.now().toIso8601String(),
    //   status: "sending",
    // );

    // final previousData2 = _messagesState.value.data;
    // _messagesState.loading(previousData2);
    // List<MessageEntity> updatedMessages2;
    // if (previousData2 != null) {
    //   updatedMessages2 = [
    //     ...[newAnswer],
    //     ...previousData2,
    //   ];
    // } else {
    //   updatedMessages2 = [newAnswer];
    // }
    // _messagesState.content(updatedMessages2);
  }

  @override
  Future<void> onGoToLawyerChatScreen() async {
    await stackRouter.push(
      createLawyerChatRoute(),
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Проверяем, доскроллил ли пользователь до верха списка
      // (позиция скролла близка к верхнему краю)
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMessages) {
        _loadMessages();
      }
    });
  }

  Future<void> _initWebSocketConnection() async {
    try {
      if (!model.webSocketService.isConnected) {
        await model.webSocketService.connect();
      }

      _webSocketSubscription = model.webSocketService.messageStream.listen(
        _handleWebSocketMessage,
        onError: (error) {
          log('WebSocket error: $error');
          _scaffoldMessengerWrapper.showSnackBar(
            context,
            context.l10n.error_connection_problems,
          );
        },
      );
    } catch (e) {
      log('WebSocket connection error: $e');
      onErrorHandle(e);
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      // Убедимся, что у нас Map
      final data = message is Map ? Map<String, dynamic>.from(message) : null;
      if (data == null) return;

      final messageType = data['type'] as String?;

      switch (messageType) {
        // Обработка статуса подключения
        case 'connection_status':
          final status = data['status'] as String?;
          log('WebSocket connection status: $status');
          break;

        // Обработка получения сообщения
        case 'message_received':
          final messageId = data['message_id']?.toString();
          final status = data['status'] as String?;

          log('Message $messageId status: $status');
          break;

        // Обработка ответа от ИИ
        case 'ai_response':
          final messageId = data['message_id']?.toString();
          final userId = data['user_id'];
          final content = data['content'] as String? ?? '';

          log('Received AI response for message $messageId');
          _handleAiResponse(messageId, userId, content);
          break;

        case 'error':
          final errorMessage =
              data['message'] as String? ?? 'Неизвестная ошибка';
          final errorCode = data['error_code']?.toString();

          log('WebSocket error: $errorMessage (code: $errorCode)');
          _handleServerError(errorMessage, errorCode);
          break;

        default:
          log('Unknown message type: $messageType');
      }
    } catch (e) {
      log('Error handling WebSocket message: $e');
    }
  }

  void _handleAiResponse(String? messageId, dynamic userId, String content) {
    // Создаем сообщение с ответом от бота
    final botResponse = MessageEntity(
      id: int.tryParse(messageId ?? '0') ?? 0,
      senderType: "ai",
      senderId: userId is int ? userId : 999,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      status: "delivered",
    );

    // Обновляем список сообщений
    final previousData = _messagesState.value.data;
    List<MessageEntity> updatedMessages;

    if (previousData != null) {
      // Добавляем ответ в начало списка (так как список перевернут)
      updatedMessages = [botResponse, ...previousData];
    } else {
      updatedMessages = [botResponse];
    }

    _messagesState.content(updatedMessages);
  }

  void _handleServerError(String errorMessage, String? errorCode) {
    // Показываем ошибку пользователю

    // _scaffoldMessengerWrapper.showSnackBar(
    //   context,
    //   errorCode != null ? '$errorMessage (код: $errorCode)' : errorMessage,
    // );

    log("Произошла ошибка при обработке запроса: $errorMessage");

    // Опционально: можно добавить сообщение от бота в чат с уведомлением о проблеме
    final botErrorMessage = MessageEntity(
      id: -2, // Специальный ID для системных сообщений
      senderType: "ai",
      senderId: 0,
      content: "Произошла ошибка при обработке запроса",
      createdAt: DateTime.now().toIso8601String(),
      status: "error",
    );

    final previousData = _messagesState.value.data;
    if (previousData != null) {
      _messagesState.content([botErrorMessage, ...previousData]);
    } else {
      _messagesState.content([botErrorMessage]);
    }
  }

  Future<void> _loadMessages() async {
    // Защита от параллельных загрузок
    if (_isLoadingMessages) return;
    _isLoadingMessages = true;

    final previousData = _messagesState.value.data;
    _messagesState.loading(previousData);

    try {
      final totalMessages = await model.getAiMessages(
        offset: _offset,
      );

      // Проверка, нужно ли продолжать загрузку
      if (_offset < totalMessages.total) {
        _offset += model.defaultLimit;
      } else {
        // Если больше нет сообщений, просто возвращаем текущий список
        if (previousData != null) {
          _messagesState.content(previousData);
        }
        _isLoadingMessages = false;
        return;
      }

      final oldMessages = totalMessages.messages;

      // Проверка на дубликаты по ID
      final existingIds = previousData?.map((msg) => msg.id).toSet() ?? <int>{};
      final uniqueMessages =
          oldMessages.where((msg) => !existingIds.contains(msg.id)).toList();
      List<MessageEntity> updatedMessages;
      if (previousData != null) {
        updatedMessages = [
          ...previousData,
          ...uniqueMessages,
        ];
      } else {
        updatedMessages = oldMessages;
      }

      _messagesState.content(updatedMessages);
    } on Exception catch (e) {
      _messagesState.failure(e, previousData);
      onErrorHandle(e);
    } finally {
      _isLoadingMessages = false;
    }
  }

  // Future<void> _loadMessages() async {
  //   if (_isLoadingMessages) return;
  // _isLoadingMessages = true;

  //   final previousData = _messagesState.value.data;
  //   _messagesState.loading(previousData);
  //   // _isLoading = true;

  //   try {
  //     final totalMessages = await model.getAiMessages(
  //       offset: _offset,
  //     );

  //     if (_offset < totalMessages.total) {
  //       _offset += model.defaultLimit;
  //     }

  //     final oldMessages = totalMessages.messages;

  //     List<MessageEntity> updatedMessages;
  //     if (previousData != null) {
  //       updatedMessages = [
  //         ...previousData,
  //         ...oldMessages,
  //       ];
  //     } else {
  //       updatedMessages = oldMessages;
  //     }

  //     _messagesState.content(updatedMessages);
  //     // _isLoading = false;
  //   } on Exception catch (e) {
  //     _messagesState.failure(e, previousData);
  //     onErrorHandle(e);
  //   }
  // }
}
