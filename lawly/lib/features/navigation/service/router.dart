import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/chat/presentation/chat_root_screen.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_widget.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_wm.dart';
import 'package:lawly/features/documents/presentation/documents_root_screen.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_widget.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_wm.dart';
import 'package:lawly/features/init/presentation/screens/welcome_screen.dart';
import 'package:lawly/features/init/service/init_service.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/chat/chat_routes.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_routes.dart';
import 'package:lawly/features/navigation/domain/enity/init/init_routes.dart';
import 'package:lawly/features/navigation/domain/enity/profile/profile_routes.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/profile/presentation/profile_root_screen.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_wm.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/templates_root_screen.dart';
import 'package:lawly/features/nav_bar/presentation/widgets/nav_bar_widget.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_wm.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'ScreenWidget|Screen|Widget,Route')
class AppRouter extends RootStackRouter {
  final InitService _initService;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: BaseRouter.page,
          path: AppRoutePaths.basePath,
          initial: true,
          children: [
            welcomeRoute.copyWith(
              initial: _initService.isFirstLaunch,
            ),
            CustomRoute(
              initial: !_initService.isFirstLaunch,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              page: HomeRouter.page,
              path: AppRoutePaths.homePath,
              children: [
                createTemplateRouter(),
                createDocumentRouter(),
                createChatRouter(),
                createProfileRouter(),
              ],
            ),
          ],
        ),
      ];

  AppRouter({required InitService initService}) : _initService = initService;
}

/// Реализация пустого экрана
@RoutePage(name: 'BaseRouter')
class EmptyRouterPage extends AutoRouter {
  /// @nodoc
  const EmptyRouterPage({super.key});
}
