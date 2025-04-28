import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_wm.dart';
import 'package:lawly/features/common/widgets/auth_text_field.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class AuthScreenWidget extends ElementaryWidget<IAuthScreenWidgetModel> {
  const AuthScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultAuthScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAuthScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: milkyWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
      ),
      body: _AuthForm(
        onAuth: wm.onCompleteAuth,
        emailController: wm.emailController,
        passwordController: wm.passwordController,
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final VoidCallback onAuth;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _AuthForm({
    required this.onAuth,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return UnfocusGestureDetector(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              CommonIcons.authLogo,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
              child: Text(
                context.l10n.auth_welcome,
                style: textBold24DarkBlueW700,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
              child: Column(
                children: [
                  AuthTextField(
                    textAbove: context.l10n.mail,
                    controller: emailController,
                    labelText: context.l10n.mail_claim,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    textAbove: context.l10n.password,
                    controller: passwordController,
                    labelText: context.l10n.password_claim,
                  ),
                ],
              ),
            ),
            LawlyCustomButton(
              onPressed: onAuth,
              text: context.l10n.enter,
              iconPath: CommonIcons.loginIcon,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
