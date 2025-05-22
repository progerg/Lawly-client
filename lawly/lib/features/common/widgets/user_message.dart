import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/chat/domain/entity/message_entity.dart';

class UserMessage extends StatelessWidget {
  final MessageEntity message;

  const UserMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
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
