import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';

class LawlyCircularIndicator extends StatelessWidget {
  final Color colorIndicator;

  const LawlyCircularIndicator({
    super.key,
    this.colorIndicator = darkBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: colorIndicator,
      ),
    );
  }
}
