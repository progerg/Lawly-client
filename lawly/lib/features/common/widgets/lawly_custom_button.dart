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

  const LawlyCustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.colorButton = darkBlue,
    this.colorText = white,
    required this.iconPath,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: colorButton,
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
      ),
    );
  }
}
