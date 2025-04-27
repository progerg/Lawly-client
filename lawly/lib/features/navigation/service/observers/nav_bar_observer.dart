import 'package:flutter/material.dart';

enum NavBarElement {
  template,
  document,
  chat,
  profile,
}

class NavBarObserver {
  final ValueNotifier<bool> isBottomNavBarVisible = ValueNotifier<bool>(true);

  final ValueNotifier<NavBarElement> currentNavBarElement =
      ValueNotifier<NavBarElement>(NavBarElement.template);

  void showBottoNavBar() {
    isBottomNavBarVisible.value = true;
  }

  void hideBottomNavBar() {
    isBottomNavBarVisible.value = false;
  }

  void setNavBarElement(NavBarElement element) {
    currentNavBarElement.value = element;
  }
}
