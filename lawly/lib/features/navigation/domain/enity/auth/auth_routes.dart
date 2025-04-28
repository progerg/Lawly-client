import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_selection_route.dart';
import 'package:lawly/features/navigation/service/router.dart';

final AutoRoute authRouter = CustomRoute(
  page: AuthRouter.page,
  path: AuthRoutePaths.authRouter,
  transitionsBuilder: TransitionsBuilders.fadeIn,
  children: [authSelectionRoute],
);

PageRouteInfo createAuthRouter() => AuthRouter();
