import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';

class LawlyCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color colorButton;
  final Color colorText;
  final String iconPath;
  final EdgeInsetsGeometry padding;
  final Color shadowColor;

  const LawlyCustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.colorButton = darkBlue,
    this.colorText = white,
    this.shadowColor = shadow,
    required this.iconPath,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: colorButton,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: textBold20DarkBlueW700.copyWith(color: colorText),
                ),
                CircleAvatar(
                  backgroundColor: white,
                  radius: 19,
                  child: SvgPicture.asset(
                    iconPath,
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
