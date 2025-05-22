import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
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

  const _AiChatView({
    required this.onGoToLawyerChatScreen,
    required this.onSend,
    required this.scrollController,
    required this.textController,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
