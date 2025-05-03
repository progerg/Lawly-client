import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_routes.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_routes.dart';
import 'package:lawly/features/navigation/domain/enity/profile/profile_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createProfileRouter(List<AutoRouteGuard> guards) => AutoRoute(
      page: ProfileRouter.page,
      path: AppRoutePaths.profileRootPath,
      children: [
        authRouter,
        RedirectRoute(
          path: '',
          redirectTo: AppRoutePaths.profilePath,
        ),
        AutoRoute(
          page: ProfileRoute.page,
          path: AppRoutePaths.profilePath,
          guards: guards,
        ),
        subscribeRoute,
        privacyPolicyRoute,
        settingsRoute,
      ],
    );

PageRouteInfo createPrivacyPolicyRoute() => PrivacyPolicyRoute();

PageRouteInfo createSettingsRoute() => SettingsRoute();

PageRouteInfo createSubscribeRoute() => SubRoute();

final settingsRoute = AutoRoute(
  page: SettingsRoute.page,
  path: ProfileRoutePaths.settings,
);

final subscribeRoute = AutoRoute(
  page: SubRoute.page,
  path: ProfileRoutePaths.subscribe,
);
