import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

final welcomeRoute = CustomRoute(
  page: WelcomeRoute.page,
  path: AppRoutePaths.welcomePath,
  transitionsBuilder: TransitionsBuilders.fadeIn,
);
