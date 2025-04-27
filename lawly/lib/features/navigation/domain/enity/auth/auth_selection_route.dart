import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

final authSelectionRoute = AutoRoute(
  page: AuthSelectionRoute.page,
  path: AuthRoutePaths.authSelection,
  initial: true,
);
