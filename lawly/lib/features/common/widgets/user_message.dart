import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';
import 'package:lawly/l10n/l10n.dart';

class UserMessage extends StatelessWidget {
  final MessageEntity message;
  final bool isBotTyping;

  const UserMessage({
    super.key,
    required this.message,
    required this.isBotTyping,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: mediaQuery.size.width * 0.2,
            bottom: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: textBold16DarkBlueW400.copyWith(
                          color: white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatDateTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: lightGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isBotTyping)
          Padding(
            padding: EdgeInsets.only(
              right: mediaQuery.size.width * 0.05,
              bottom: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Аватар бота (такой же как в BotMessage)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: lightGray,
                  child: SvgPicture.asset(
                    CommonIcons.botIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(lightBlue, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 12),

                // Контейнер с текстом "AI печатает" и анимированными точками
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: lightGray,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.ai_typing,
                          style: textBold16DarkBlueW400,
                        ),
                        // const TypewriterAnimatedDots(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd.MM.yy HH:mm').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
