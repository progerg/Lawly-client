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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: milkyWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
      ),
      body: UnfocusGestureDetector(
        child: _RegistrationForm(
          onRegistration: wm.onCompleteRegistration,
          onPrivacyPolicy: wm.openPrivacyPolicy,
          onAgreePrivacyPolicy: wm.onAgreePrivacyPolicy,
          nameController: wm.nameTextController,
          emailController: wm.emailTextController,
          passwordController: wm.passwordTextController,
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatefulWidget {
  final VoidCallback onRegistration;
  final VoidCallback onPrivacyPolicy;
  final void Function(bool) onAgreePrivacyPolicy;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _RegistrationForm({
    required this.onRegistration,
    required this.onPrivacyPolicy,
    required this.onAgreePrivacyPolicy,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<_RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<_RegistrationForm> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = false;
  }

  void onChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;
      widget.onAgreePrivacyPolicy(isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 50,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              CommonIcons.authLogo,
            ),
            const SizedBox(height: 35),
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
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
              child: Column(
                children: [
                  AuthTextField(
                    textAbove: context.l10n.name,
                    controller: widget.nameController,
                    labelText: context.l10n.name_claim,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    textAbove: context.l10n.mail,
                    controller: widget.emailController,
                    labelText: context.l10n.mail_claim,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    textAbove: context.l10n.password,
                    isPassword: true,
                    controller: widget.passwordController,
                    labelText: context.l10n.password_claim,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 33),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: onChanged,
                      checkColor: darkBlue,
                      fillColor: WidgetStateProperty.all(milkyWhite),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onPrivacyPolicy,
                      child: RichText(
                        text: TextSpan(
                          style: textBold12DarkBlueW400,
                          children: [
                            TextSpan(
                                text: context.l10n.privacy_policy_first_part),
                            TextSpan(
                              text: context.l10n.privacy_policy_second_part,
                              style: textBold12DarkBlueW400.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                                text: context.l10n.privacy_policy_third_part),
                            TextSpan(
                              text: context.l10n.privacy_policy_fourth_part,
                              style: textBold12DarkBlueW400.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LawlyCustomButton(
              onPressed: widget.onRegistration,
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
