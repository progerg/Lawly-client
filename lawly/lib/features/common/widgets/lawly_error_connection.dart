import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/l10n/l10n.dart';

class LawlyErrorConnection extends StatelessWidget {
  const LawlyErrorConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          CommonIcons.authLogo,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.1,
          ),
          child: Column(
            children: [
              Text(
                context.l10n.error_connection_first_part,
                style: textBold24DarkBlueW700,
                textAlign: TextAlign.center,
              ),
              Text(
                context.l10n.error_connection_second_part,
                style: textBold24DarkBlueW700,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        LawlyCircularIndicator(),
        SizedBox(
          height: mediaQuery.size.height * 0.1,
        ),
      ],
    );
  }
}
