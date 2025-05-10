import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AuthTextField extends StatefulWidget {
  final String textAbove;
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String? mask;
  final Map<String, String> filter;

  const AuthTextField({
    super.key,
    required this.textAbove,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.mask,
    this.filter = const {},
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isVisiblePassword = false;

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
            widget.textAbove,
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
            textAlignVertical:
                widget.isPassword ? TextAlignVertical.center : null,
            controller: widget.controller,
            obscureText: widget.isPassword ? !_isVisiblePassword : false,
            decoration: InputDecoration(
              hintText: widget.labelText,
              hintStyle: textBold15DarkBlueAlpha50W700,
              contentPadding: EdgeInsets.only(left: 20),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisiblePassword = !_isVisiblePassword;
                        });
                      },
                      icon: Icon(
                        _isVisiblePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ))
                  : null,
            ),
            inputFormatters: [
              MaskTextInputFormatter(
                mask: widget.mask,
                filter: _getFilter(widget.filter),
              ),
            ],
            style: textBold15DarkBlueW700,
            cursorColor: darkBlue,
          ),
        ),
      ],
    );
  }

  Map<String, RegExp> _getFilter(Map<String, String> filter) {
    return filter.map((key, value) {
      return MapEntry(key, RegExp(value));
    });
  }
}
