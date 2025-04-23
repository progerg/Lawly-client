import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/bottom_nav_tab_icons.dart';
import 'package:lawly/features/navigation/service/router.dart';

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

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: _routes,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: milkyWhite,
          elevation: 0,
          items: _bottomBarItems,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            if (index == tabsRouter.activeIndex) {
              tabsRouter.setActiveIndex(index);
            } else {
              tabsRouter.setActiveIndex(index);
            }
          },
        );
      },
    );
  }
}
