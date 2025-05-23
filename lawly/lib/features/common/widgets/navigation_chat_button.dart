import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';

class NavigationChatButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final ArrowDirection arrowDirection;

  const NavigationChatButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.arrowDirection,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (arrowDirection == ArrowDirection.right)
              Icon(
                Icons.arrow_back,
                color: lightBlue,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              text,
              style: textBold16DarkBlueW700.copyWith(
                color: lightBlue,
              ),
            ),
            const SizedBox(width: 8),
            if (arrowDirection == ArrowDirection.left)
              Icon(
                Icons.arrow_forward,
                color: lightBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

enum ArrowDirection {
  left,
  right,
}
