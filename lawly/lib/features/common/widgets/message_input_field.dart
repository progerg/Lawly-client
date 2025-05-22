import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/l10n/l10n.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 8.0
            : MediaQuery.of(context).padding.bottom + 8.0,
        top: 8.0,
      ),
      decoration: const BoxDecoration(
        color: milkyWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: black,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: context.l10n.message,
                          hintStyle: textBold16DarkBlueW400,
                          border: InputBorder.none,
                        ),
                        style: textBold16DarkBlueW400,
                        cursorColor: darkBlue80,
                        maxLines: null, // Автоматическое увеличение высоты
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Кнопка отправки
          SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: lightBlue,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  if (_hasText) {
                    widget.onSend();
                  }
                },
                child: Center(
                  child: Icon(
                    _hasText ? Icons.send : Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
