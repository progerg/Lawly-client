import 'package:elementary/elementary.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';

class AuthSelectionScreenModel extends ElementaryModel {
  final NavBarObserver navBarObserver;

  AuthSelectionScreenModel({
    required this.navBarObserver,
  });
}
