import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/template/template_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';

AutoRoute createTemplateRouter() => AutoRoute(
      path: AppRoutePaths.templateRootPath,
      page: TemplatesRouter.page,
      children: [
        AutoRoute(
          page: TemplatesRoute.page,
          path: AppRoutePaths.templatesPath,
        ),
        templateNoAuthRoute,
        templateDownloadRoute,
        customTemplateRoute,
      ],
    );

PageRouteInfo createTemplateNoAuthRoute({
  required TemplateEntity template,
}) =>
    TemplateNoAuthRoute(template: template);

PageRouteInfo createTemplateDownloadRoute({
  required String filePath,
  String? imageUrl,
}) =>
    TemplateDownloadRoute(
      filePath: filePath,
      imageUrl: imageUrl,
    );

PageRouteInfo createCustomTemplate() => CustomTemplateRoute();

PageRouteInfo createTemplateEditFieldRoute({
  required FieldEntity fieldEntity,
}) =>
    TemplateEditFieldRoute(fieldEntity: fieldEntity);

final templateNoAuthRoute = CustomRoute(
  page: TemplateNoAuthRoute.page,
  path: TemplateRoutePaths.templateNoAuth,
  transitionsBuilder: TransitionsBuilders.slideLeft,
);

final customTemplateRoute = CustomRoute(
  page: CustomTemplateRoute.page,
  path: TemplateRoutePaths.customTemplate,
  transitionsBuilder: TransitionsBuilders.slideLeft,
);

final templateDownloadRoute = CustomRoute(
  page: TemplateDownloadRoute.page,
  path: TemplateRoutePaths.templateDownload,
  transitionsBuilder: TransitionsBuilders.slideLeft,
);

final templateEditFieldRoute = CustomRoute(
  page: TemplateEditFieldRoute.page,
  path: TemplateRoutePaths.templateEditField,
  transitionsBuilder: TransitionsBuilders.fadeIn,
  opaque: false,
);
