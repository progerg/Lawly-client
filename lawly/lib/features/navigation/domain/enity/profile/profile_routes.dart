import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createProfileRouter() => AutoRoute(
      page: ProfileRouter.page,
      path: AppRoutePaths.profileRootPath,
      children: [
        AutoRoute(
          page: ProfileRoute.page,
          path: AppRoutePaths.profilePath,
        ),
      ],
    );
