import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/bottom_nav_tab_icons.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:provider/provider.dart';

final _routes = [
  ...const [
    TemplatesRouter(),
    DocumentsRouter(),
    ChatRouter(),
    ProfileRouter(),
  ],
];

@RoutePage(name: 'HomeRouter')
class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  late final _bottomBarItems = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(BottomNavTabIcons.templateTabIcon),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(BottomNavTabIcons.documentTabIcon),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(BottomNavTabIcons.chatTabIcon),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(BottomNavTabIcons.profileTabIcon),
      label: '',
    ),
  ];

  late final NavBarObserver navBarObserver;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appScope = context.read<IAppScope>();

    navBarObserver = appScope.navBarObserver;
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: _routes,
      bottomNavigationBuilder: (context, tabsRouter) {
        /// Вызывать нужно не здесь. Показывать/скрывать скорее всего через ValueNotifier<bool> через WidgetModel. По имени не работает

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: milkyWhite,
          elevation: 0,
          items: _bottomBarItems,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            navBarObserver.setNavBarElement(_getNavBarElement(index));
            tabsRouter.setActiveIndex(index);
          },
        );
      },
    );
  }

  NavBarElement _getNavBarElement(int index) {
    switch (index) {
      case 0:
        return NavBarElement.template;
      case 1:
        return NavBarElement.document;
      case 2:
        return NavBarElement.chat;
      default:
        return NavBarElement.profile;
    }
  }
}
