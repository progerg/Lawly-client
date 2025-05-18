import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      // child: CircularProgressIndicator(
      //   color: colorIndicator,
      // ),
      child: SpinKitThreeBounce(
        color: lightBlue,
      ),
    );
  }
}
