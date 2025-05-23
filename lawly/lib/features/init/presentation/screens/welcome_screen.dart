import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/res/welcome_res.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:provider/provider.dart';

const double _horizontalPadding = 74;
const double _topOffset = 151;
const double _bottomOffset = 71;

@RoutePage()
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = [
    WelcomeRes.welcomePicture1,
    WelcomeRes.welcomePicture2,
    WelcomeRes.welcomePicture3,
  ];
  late final PageController _pageController;
  late final IAppScope _scope;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    FlutterNativeSplash.remove();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = context.read<IAppScope>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageTexts = [
      context.l10n.first_slogan,
      context.l10n.second_slogan,
      context.l10n.third_slogan,
    ];
    return Scaffold(
      backgroundColor: milkyWhite,
      body: PageView.builder(
        itemCount: _pages.length,
        controller: _pageController,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(
            top: _topOffset,
            bottom: _bottomOffset,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                _pages[index],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Text(
                  pageTexts[index],
                  style: textBold20DarkBlueW700,
                  textAlign: TextAlign.center,
                ),
              ),
              LawlyCustomButton(
                onPressed: () => _handlePageChange(index),
                text: index == _pages.length - 1
                    ? context.l10n.start_text
                    : context.l10n.next_text,
                iconPath: CommonIcons.arrowForwardIcon,
                padding: EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageChange(int index) {
    if (index < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      unawaited(_executeFisrtLaunch());
      context.router.replaceAll([const HomeRouter()]);
    }
  }

  Future<void> _executeFisrtLaunch() async {
    // Первый запуск совершен
    AppMetrica.reportEvent('first_launch');

    await _scope.initService.setFirstLaunch(false);
  }
}
