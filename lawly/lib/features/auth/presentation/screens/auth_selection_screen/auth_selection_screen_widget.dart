import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/auth/presentation/screens/auth_selection_screen/auth_selection_screen_wm.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class AuthSelectionScreenWidget
    extends ElementaryWidget<IAuthSelectionScreenWidgetModel> {
  const AuthSelectionScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultAuthSelectionScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAuthSelectionScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.authTitle,
          style: textBold32DarkBlueW700,
        ),
        elevation: 0,
        backgroundColor: milkyWhite,
      ),
      body: _AuthSelectionForm(
        authSelectionText: wm.authSelectionText,
        onAuth: wm.onAuth,
        onRegistration: wm.onRegistration,
      ),
    );
  }
}

class _AuthSelectionForm extends StatelessWidget {
  final String authSelectionText;

  final VoidCallback onAuth;

  final VoidCallback onRegistration;

  const _AuthSelectionForm({
    required this.authSelectionText,
    required this.onAuth,
    required this.onRegistration,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            CommonIcons.authLogo,
          ),
          // Image.asset(
          //   CommonRes.authLogo,
          //   scale: mediaQuery.size.width / 50,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.1,
            ),
            child: Text(
              authSelectionText,
              style: textBold24DarkBlueW700,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LawlyCustomButton(
                onPressed: onAuth,
                text: context.l10n.enter,
                iconPath: CommonIcons.loginIcon,
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.1,
                ),
                colorButton: white,
                colorText: darkBlue,
              ),
              const SizedBox(height: 27),
              LawlyCustomButton(
                onPressed: onRegistration,
                text: context.l10n.registration,
                iconPath: CommonIcons.addIcon,
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
