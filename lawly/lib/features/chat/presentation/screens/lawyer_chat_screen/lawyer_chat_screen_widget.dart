import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_message_entity.dart';
import 'package:lawly/features/chat/presentation/screens/lawyer_chat_screen/lawyer_chat_screen_wm.dart';
import 'package:lawly/features/common/widgets/bot_message.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:lawly/features/common/widgets/navigation_chat_button.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class LawyerChatScreenWidget
    extends ElementaryWidget<ILawyerChatScreenWidgetModel> {
  const LawyerChatScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultLawyerChatScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ILawyerChatScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
      ),
      body: UnionStateListenableBuilder<List<LawyerMessageEntity>>(
        unionStateListenable: wm.lawyerMessagesState,
        builder: (context, data) {
          return _LawyerAnswersView(
            scrollController: wm.scrollController,
            onGoToLawyerChatScreen: wm.onGoToAiChatScreen,
            onOpenFile: wm.onOpenFile,
            messages: data,
          );
        },
        loadingBuilder: (context, data) {
          if (data != null && data.isNotEmpty) {
            return _LawyerAnswersView(
              scrollController: wm.scrollController,
              onGoToLawyerChatScreen: wm.onGoToAiChatScreen,
              onOpenFile: wm.onOpenFile,
              messages: data,
            );
          }
          return LawlyCircularIndicator();
        },
        failureBuilder: (context, e, data) {
          if (data != null && data.isNotEmpty) {
            return _LawyerAnswersView(
              scrollController: wm.scrollController,
              onGoToLawyerChatScreen: wm.onGoToAiChatScreen,
              onOpenFile: wm.onOpenFile,
              messages: data,
            );
          }
          return LawlyErrorConnection();
        },
      ),
    );
  }
}

class _LawyerAnswersView extends StatelessWidget {
  final List<LawyerMessageEntity> messages;
  final ScrollController scrollController;
  final VoidCallback onGoToLawyerChatScreen;
  final void Function(int messageId) onOpenFile;

  const _LawyerAnswersView({
    required this.messages,
    required this.scrollController,
    required this.onGoToLawyerChatScreen,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    return UnfocusGestureDetector(
      child: Center(
        child: Column(
          children: [
            /// кнопка "Перейти к юристу"
            Align(
              alignment: Alignment.centerLeft,
              child: NavigationChatButton(
                text: context.l10n.go_to_chat_bot,
                onTap: onGoToLawyerChatScreen,
                arrowDirection: ArrowDirection.right,
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
                  return Column(
                    children: [
                      _LawyerMessage(
                        message: message,
                        onOpenFile: () => onOpenFile(message.messageId),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LawyerMessage extends StatelessWidget {
  final LawyerMessageEntity message;
  final VoidCallback onOpenFile;

  const _LawyerMessage({
    required this.message,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        right: mediaQuery.size.width * 0.05,
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар юриста
          CircleAvatar(
            radius: 16,
            backgroundColor: lightGray,
            child: SvgPicture.asset(
              CommonIcons.lawyerIcon, // Путь к иконке бота
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(lightBlue, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),

          // Сообщение от юриста
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.note,
                    style: textBold16DarkBlueW400,
                  ),
                  const SizedBox(height: 16),
                  if (message.hasFile)
                    GestureDetector(
                      onTap: onOpenFile,
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            color: lightBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.download,
                            style: textBold16DarkBlueW700,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LawyerDocument extends StatelessWidget {
  const _LawyerDocument();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        right: mediaQuery.size.width * 0.05,
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.download,
                        style: textBold16DarkBlueW700,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.file_present,
                        color: lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
