import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';
import 'package:lawly/features/chat/presentation/screens/ai_chat_screen/chat_screen_wm.dart';
import 'package:lawly/features/common/widgets/bot_message.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:lawly/features/common/widgets/message_input_field.dart';
import 'package:lawly/features/common/widgets/navigation_chat_button.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/features/common/widgets/user_message.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class ChatScreenWidget extends ElementaryWidget<IChatScreenWidgetModel> {
  const ChatScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultChatScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IChatScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
      ),
      body: UnionStateListenableBuilder<List<MessageEntity>>(
        unionStateListenable: wm.messagesState,
        builder: (context, data) {
          return _AiChatView(
            scrollController: wm.scrollController,
            onGoToLawyerChatScreen: wm.onGoToLawyerChatScreen,
            onSend: wm.onSend,
            textController: wm.textController,
            isBotTyping: wm.isBotTyping,
            messages: data,
          );
        },
        loadingBuilder: (context, data) {
          if (data != null && data.isNotEmpty) {
            return _AiChatView(
              scrollController: wm.scrollController,
              onGoToLawyerChatScreen: wm.onGoToLawyerChatScreen,
              onSend: wm.onSend,
              textController: wm.textController,
              isBotTyping: wm.isBotTyping,
              messages: data,
            );
          }
          return LawlyCircularIndicator();
        },
        failureBuilder: (context, e, data) {
          if (data != null && data.isNotEmpty) {
            return _AiChatView(
              scrollController: wm.scrollController,
              onGoToLawyerChatScreen: wm.onGoToLawyerChatScreen,
              onSend: wm.onSend,
              textController: wm.textController,
              isBotTyping: wm.isBotTyping,
              messages: data,
            );
          }
          return LawlyErrorConnection();
        },
      ),
    );
  }
}

class _AiChatView extends StatelessWidget {
  final VoidCallback onGoToLawyerChatScreen;
  final VoidCallback onSend;
  final ScrollController scrollController;
  final TextEditingController textController;
  final List<MessageEntity> messages;
  final ValueNotifier<bool> isBotTyping;

  const _AiChatView({
    required this.onGoToLawyerChatScreen,
    required this.onSend,
    required this.scrollController,
    required this.textController,
    required this.messages,
    required this.isBotTyping,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBotTyping,
        builder: (context, isBotTypingData, child) {
          return UnfocusGestureDetector(
            child: Center(
              child: Column(
                children: [
                  /// кнопка "Перейти к юристу"
                  Align(
                    alignment: Alignment.centerRight,
                    child: NavigationChatButton(
                      text: context.l10n.go_to_lawyer_chat,
                      onTap: onGoToLawyerChatScreen,
                      arrowDirection: ArrowDirection.left,
                    ),
                  ),

                  /// сообщения
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        if (message.senderType == 'ai' ||
                            message.senderType == 'bot') {
                          return BotMessage(
                            message: message,
                          );
                        }
                        return UserMessage(
                          message: message,
                          isBotTyping: isBotTypingData && index == 0,
                        );
                      },
                    ),
                  ),

                  /// поле ввода сообщения
                  MessageInputField(
                    controller: textController,
                    onSend: onSend,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TypewriterAnimatedDots extends StatefulWidget {
  final Color color;
  final double size;

  const TypewriterAnimatedDots({
    Key? key,
    this.color = Colors.black54,
    this.size = 16.0,
  }) : super(key: key);

  @override
  State<TypewriterAnimatedDots> createState() => _TypewriterAnimatedDotsState();
}

class _TypewriterAnimatedDotsState extends State<TypewriterAnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _numDots = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _numDots = (_numDots + 1) % 4;
          _controller.forward(from: 0.0);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _numDots;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          dots,
          style: TextStyle(
            fontSize: widget.size,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        );
      },
    );
  }
}
