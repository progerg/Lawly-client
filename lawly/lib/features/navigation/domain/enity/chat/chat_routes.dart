import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_routes.dart';
import 'package:lawly/features/navigation/domain/enity/chat/chat_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createChatRouter(List<AutoRouteGuard> guards) => AutoRoute(
      page: ChatRouter.page,
      path: AppRoutePaths.chatRootPath,
      children: [
        authRouter,
        AutoRoute(
          page: ChatRoute.page,
          path: AppRoutePaths.chatPath,
          guards: guards,
        ),
        customLawyerChatRoute,
      ],
    );

PageRouteInfo createLawyerChatRoute() => LawyerChatRoute();

PageRouteInfo createAiChatRoute() => ChatRoute();

final customLawyerChatRoute = CustomRoute(
  page: LawyerChatRoute.page,
  path: ChatRoutePaths.lawyerChat,
  transitionsBuilder: TransitionsBuilders.slideLeft,
);
