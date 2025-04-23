import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createTemplateRouter() => AutoRoute(
      path: AppRoutePaths.templateRootPath,
      page: TemplatesRouter.page,
      children: [
        AutoRoute(
          page: TemplatesRoute.page,
          path: AppRoutePaths.templatesPath,
        ),
      ],
    );
