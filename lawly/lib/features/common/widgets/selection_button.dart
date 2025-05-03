import 'package:flutter/widgets.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';

class SelectionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color colorButton;
  final Color colorText;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final int maxLines;

  const SelectionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.colorButton = darkBlue,
    this.colorText = white,
    this.borderRadius = 10,
    required this.padding,
    this.textStyle = textBold16DarkBlueW600,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: colorButton,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: textStyle.copyWith(
                      color: colorText,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: maxLines,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
