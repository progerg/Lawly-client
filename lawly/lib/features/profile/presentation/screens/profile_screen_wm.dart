import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_model.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';

abstract class IProfileScreenWidgetModel implements IWidgetModel {}

ProfileScreenWidgetModel defaultProfileScreenWidgetModelFactory(
    BuildContext context) {
  final model = ProfileScreenModel();
  return ProfileScreenWidgetModel(model);
}

class ProfileScreenWidgetModel
    extends WidgetModel<ProfileScreenWidget, ProfileScreenModel>
    implements IProfileScreenWidgetModel {
  ProfileScreenWidgetModel(super.model);
}
