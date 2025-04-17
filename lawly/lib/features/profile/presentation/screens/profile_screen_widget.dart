import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_wm.dart';

@RoutePage()
class ProfileScreenWidget extends ElementaryWidget<IProfileScreenWidgetModel> {
  const ProfileScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultProfileScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IProfileScreenWidgetModel wm) {
    return Scaffold(
      body: Center(
        child: Text(
          'Profile Screen',
        ),
      ),
    );
  }
}
