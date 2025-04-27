import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_wm.dart';
import 'package:lawly/features/common/widgets/auth_text_field.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class RegistrationScreenWidget
    extends ElementaryWidget<IRegistrationScreenWidgetModel> {
  const RegistrationScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultRegistrationScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IRegistrationScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: milkyWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
      ),
      body: _RegistrationForm(
        onRegistration: wm.onCompleteRegistration,
        nameController: wm.nameTextController,
        emailController: wm.emailTextController,
        passwordController: wm.passwordTextController,
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final VoidCallback onRegistration;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _RegistrationForm({
    required this.onRegistration,
    required this.nameController,
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
                context.l10n.reg_welcome,
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
                    textAbove: context.l10n.name,
                    controller: nameController,
                    labelText: context.l10n.name_claim,
                  ),
                  const SizedBox(height: 16),
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
              onPressed: onRegistration,
              text: context.l10n.registration,
              iconPath: CommonIcons.addIcon,
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
