import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';

class AuthTextField extends StatelessWidget {
  final String textAbove;
  final TextEditingController controller;
  final String labelText;
  final bool? isPassword;

  const AuthTextField({
    super.key,
    required this.textAbove,
    required this.controller,
    required this.labelText,
    this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            bottom: 10,
          ),
          child: Text(
            textAbove,
            style: textBold24DarkBlueW600,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: lightGray,
            boxShadow: [
              BoxShadow(
                color: shadowBlack,
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ?? false,
            decoration: InputDecoration(
              hintText: labelText,
              hintStyle: textBold15DarkBlueAlpha50W700,
              contentPadding: EdgeInsets.only(left: 20),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            style: textBold15DarkBlueW700,
            cursorColor: darkBlue,
          ),
        ),
      ],
    );
  }
}
