import 'package:auto_route/auto_route.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/navigation/domain/enity/app_route_paths.dart';
import 'package:lawly/features/navigation/domain/enity/auth/auth_routes.dart';
import 'package:lawly/features/navigation/domain/enity/document/document_route_paths.dart';
import 'package:lawly/features/navigation/service/router.dart';

AutoRoute createDocumentRouter(List<AutoRouteGuard> guards) => AutoRoute(
      path: AppRoutePaths.documentRootPath,
      page: DocumentsRouter.page,
      // guards: guards,
      children: [
        authRouter,
        AutoRoute(
          page: DocumentsRoute.page,
          path: AppRoutePaths.documentPath,
          guards: guards,
        ),
      ],
    );

PageRouteInfo createDocumentEditRoute({required DocEntity document}) =>
    DocumentEditRoute(document: document);

final privacyPolicyRoute = AutoRoute(
  page: PrivacyPolicyRoute.page,
  path: DocumentRoutePaths.privacyPolicy,
);

final documentEditRoute = AutoRoute(
  page: DocumentEditRoute.page,
  path: DocumentRoutePaths.documentEdit,
);
