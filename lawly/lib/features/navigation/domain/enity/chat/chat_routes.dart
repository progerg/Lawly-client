import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createChatRouter() => AutoRoute(
      page: ChatRouter.page,
      path: AppRoutePaths.chatRootPath,
      children: [
        AutoRoute(
          page: ChatRoute.page,
          path: AppRoutePaths.chatPath,
        ),
      ],
    );
