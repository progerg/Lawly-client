import 'package:elementary/elementary.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';

class RegistrationScreenModel extends ElementaryModel {
  final NavBarObserver navBarObserver;

  RegistrationScreenModel({
    required this.navBarObserver,
  });
}
