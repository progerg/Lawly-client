import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createDocumentRouter() => AutoRoute(
      path: AppRoutePaths.documentRootPath,
      page: DocumentsRouter.page,
      children: [
        AutoRoute(
          page: DocumentsRoute.page,
          path: AppRoutePaths.documentPath,
        ),
      ],
    );
