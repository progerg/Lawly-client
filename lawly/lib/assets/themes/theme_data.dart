import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';

final defaultTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Montserrat',
  textTheme: textTheme,
  primaryTextTheme: textTheme,
  scaffoldBackgroundColor: milkyWhite,
);

const textTheme = TextTheme(bodyLarge: textRegular);
