import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class BotMessage extends StatelessWidget {
  final MessageEntity message;

  const BotMessage({
    super.key,
    required this.message,
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
          // Аватар бота
          CircleAvatar(
            radius: 16,
            backgroundColor: lightGray,
            child: SvgPicture.asset(
              CommonIcons.botIcon, // Путь к иконке бота
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(lightBlue, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),

          // Сообщение от бота
          Flexible(
            child: Column(
              children: [
                Container(
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
                      // Text(
                      //   message.content,
                      //   style: textBold16DarkBlueW400,
                      // ),
                      MarkdownBody(
                        data: message.content,
                        styleSheet: MarkdownStyleSheet(
                          p: textBold16DarkBlueW400,
                          h1: textBold16DarkBlueW400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: textBold16DarkBlueW400.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          h3: textBold16DarkBlueW400.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          code: const TextStyle(
                            fontFamily: 'monospace',
                            backgroundColor: Colors.black12,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          blockquoteDecoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onTapLink: (text, href, title) async {
                          // Обработка нажатия на ссылки
                          if (href != null) {
                            final Uri uri = Uri.parse(href);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatDateTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: darkBlue80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
