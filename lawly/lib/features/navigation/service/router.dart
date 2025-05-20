import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/auth/presentation/screens/auth_root_screen.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_widget.dart';
import 'package:lawly/features/auth/presentation/screens/auth_screen/auth_screen_wm.dart';
import 'package:lawly/features/auth/presentation/screens/auth_selection_screen/auth_selection_screen_widget.dart';
import 'package:lawly/features/auth/presentation/screens/auth_selection_screen/auth_selection_screen_wm.dart';
import 'package:lawly/features/auth/presentation/screens/privacy_policy_screen/privacy_policy_screen_widget.dart';
import 'package:lawly/features/auth/presentation/screens/privacy_policy_screen/privacy_policy_screen_wm.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_widget.dart';
import 'package:lawly/features/auth/presentation/screens/registration_screen/registration_screen_wm.dart';
import 'package:lawly/features/chat/presentation/chat_root_screen.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_widget.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_wm.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/documents/presentation/documents_root_screen.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_widget.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_wm.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_widget.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_wm.dart';
import 'package:lawly/features/init/presentation/screens/welcome_screen.dart';
import 'package:lawly/features/init/service/init_service.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_route.dart';
import 'package:lawly/features/navigation/domain/enity/auth/registration_route.dart';
import 'package:lawly/features/navigation/domain/enity/chat/chat_routes.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_routes.dart';
import 'package:lawly/features/navigation/domain/enity/init/init_routes.dart';
import 'package:lawly/features/navigation/domain/enity/profile/profile_routes.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_routes.dart';
import 'package:lawly/features/navigation/service/guards/auth_guard.dart';
import 'package:lawly/features/profile/presentation/profile_root_screen.dart';
import 'package:lawly/features/profile/presentation/screens/my_template_screen/my_template_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/my_template_screen/my_template_screen_wm.dart';
import 'package:lawly/features/profile/presentation/screens/my_templates_screen/my_templates_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/my_templates_screen/my_templates_screen_wm.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_wm.dart';
import 'package:lawly/features/profile/presentation/screens/settings_screen/settings_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/settings_screen/settings_screen_wm.dart';
import 'package:lawly/features/profile/presentation/screens/sub_screen/sub_screen_widget.dart';
import 'package:lawly/features/profile/presentation/screens/sub_screen/sub_screen_wm.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/custom_template_screen/custom_template_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/custom_template_screen/custom_template_screen_wm.dart';
import 'package:lawly/features/templates/presentation/screens/template_download_screen/template_download_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/template_download_screen/template_download_screen_wm.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_wm.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_wm.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_widget.dart';
import 'package:lawly/features/templates/presentation/screens/templates_root_screen.dart';
import 'package:lawly/features/nav_bar/presentation/widgets/nav_bar_widget.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_wm.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'ScreenWidget|Screen|Widget,Route')
class AppRouter extends RootStackRouter {
  final InitService _initService;
  final AuthGuard _authGuard;

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
            authRoute.copyWith(fullscreenDialog: true),
            registrationRoute.copyWith(fullscreenDialog: true),
            privacyPolicyRoute.copyWith(fullscreenDialog: true),
            documentEditRoute.copyWith(fullscreenDialog: true),
            templateEditFieldRoute.copyWith(fullscreenDialog: true),
            CustomRoute(
              initial: !_initService.isFirstLaunch,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              page: HomeRouter.page,
              path: AppRoutePaths.homePath,
              children: [
                createTemplateRouter(),
                createDocumentRouter([_authGuard]),
                createChatRouter([_authGuard]),
                createProfileRouter([_authGuard]),
              ],
            ),
          ],
        ),
      ];

  AppRouter({required InitService initService, required AuthGuard authGuard})
      : _initService = initService,
        _authGuard = authGuard;
}

/// Реализация пустого экрана
@RoutePage(name: 'BaseRouter')
class EmptyRouterPage extends AutoRouter {
  /// @nodoc
  const EmptyRouterPage({super.key});
}
