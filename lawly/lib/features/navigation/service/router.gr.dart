// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AuthRootScreen]
class AuthRouter extends PageRouteInfo<void> {
  const AuthRouter({List<PageRouteInfo>? children})
    : super(AuthRouter.name, initialChildren: children);

  static const String name = 'AuthRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthRootScreen();
    },
  );
}

/// generated route for
/// [AuthScreenWidget]
class AuthRoute extends PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultAuthScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         AuthRoute.name,
         args: AuthRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthRouteArgs>(
        orElse: () => const AuthRouteArgs(),
      );
      return AuthScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    this.wmFactory = defaultAuthScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [AuthSelectionScreenWidget]
class AuthSelectionRoute extends PageRouteInfo<AuthSelectionRouteArgs> {
  AuthSelectionRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultAuthSelectionScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         AuthSelectionRoute.name,
         args: AuthSelectionRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'AuthSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthSelectionRouteArgs>(
        orElse: () => const AuthSelectionRouteArgs(),
      );
      return AuthSelectionScreenWidget(
        key: args.key,
        wmFactory: args.wmFactory,
      );
    },
  );
}

class AuthSelectionRouteArgs {
  const AuthSelectionRouteArgs({
    this.key,
    this.wmFactory = defaultAuthSelectionScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'AuthSelectionRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [ChatRootScreen]
class ChatRouter extends PageRouteInfo<void> {
  const ChatRouter({List<PageRouteInfo>? children})
    : super(ChatRouter.name, initialChildren: children);

  static const String name = 'ChatRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatRootScreen();
    },
  );
}

/// generated route for
/// [ChatScreenWidget]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultChatScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>(
        orElse: () => const ChatRouteArgs(),
      );
      return ChatScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    this.wmFactory = defaultChatScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [DocumentsRootScreen]
class DocumentsRouter extends PageRouteInfo<void> {
  const DocumentsRouter({List<PageRouteInfo>? children})
    : super(DocumentsRouter.name, initialChildren: children);

  static const String name = 'DocumentsRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DocumentsRootScreen();
    },
  );
}

/// generated route for
/// [DocumentsScreenWidget]
class DocumentsRoute extends PageRouteInfo<DocumentsRouteArgs> {
  DocumentsRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultDocumentsScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         DocumentsRoute.name,
         args: DocumentsRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'DocumentsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DocumentsRouteArgs>(
        orElse: () => const DocumentsRouteArgs(),
      );
      return DocumentsScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class DocumentsRouteArgs {
  const DocumentsRouteArgs({
    this.key,
    this.wmFactory = defaultDocumentsScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'DocumentsRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [EmptyRouterPage]
class BaseRouter extends PageRouteInfo<void> {
  const BaseRouter({List<PageRouteInfo>? children})
    : super(BaseRouter.name, initialChildren: children);

  static const String name = 'BaseRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EmptyRouterPage();
    },
  );
}

/// generated route for
/// [NavBarWidget]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NavBarWidget();
    },
  );
}

/// generated route for
/// [ProfileRootScreen]
class ProfileRouter extends PageRouteInfo<void> {
  const ProfileRouter({List<PageRouteInfo>? children})
    : super(ProfileRouter.name, initialChildren: children);

  static const String name = 'ProfileRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileRootScreen();
    },
  );
}

/// generated route for
/// [ProfileScreenWidget]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultProfileScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => const ProfileRouteArgs(),
      );
      return ProfileScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.wmFactory = defaultProfileScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [RegistrationScreenWidget]
class RegistrationRoute extends PageRouteInfo<RegistrationRouteArgs> {
  RegistrationRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultRegistrationScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         RegistrationRoute.name,
         args: RegistrationRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'RegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegistrationRouteArgs>(
        orElse: () => const RegistrationRouteArgs(),
      );
      return RegistrationScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class RegistrationRouteArgs {
  const RegistrationRouteArgs({
    this.key,
    this.wmFactory = defaultRegistrationScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'RegistrationRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [TemplatesRootScreen]
class TemplatesRouter extends PageRouteInfo<void> {
  const TemplatesRouter({List<PageRouteInfo>? children})
    : super(TemplatesRouter.name, initialChildren: children);

  static const String name = 'TemplatesRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TemplatesRootScreen();
    },
  );
}

/// generated route for
/// [TemplatesScreenWidget]
class TemplatesRoute extends PageRouteInfo<TemplatesRouteArgs> {
  TemplatesRoute({
    Key? key,
    WidgetModelFactory<
          WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
        >
        wmFactory =
        defaultTemplatesScreenWidgetModelFactory,
    List<PageRouteInfo>? children,
  }) : super(
         TemplatesRoute.name,
         args: TemplatesRouteArgs(key: key, wmFactory: wmFactory),
         initialChildren: children,
       );

  static const String name = 'TemplatesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TemplatesRouteArgs>(
        orElse: () => const TemplatesRouteArgs(),
      );
      return TemplatesScreenWidget(key: args.key, wmFactory: args.wmFactory);
    },
  );
}

class TemplatesRouteArgs {
  const TemplatesRouteArgs({
    this.key,
    this.wmFactory = defaultTemplatesScreenWidgetModelFactory,
  });

  final Key? key;

  final WidgetModelFactory<
    WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>
  >
  wmFactory;

  @override
  String toString() {
    return 'TemplatesRouteArgs{key: $key, wmFactory: $wmFactory}';
  }
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeScreen();
    },
  );
}
