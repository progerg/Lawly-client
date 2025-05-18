import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/theme_data.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:lawly/features/common/widgets/di_scope.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:loader_overlay/loader_overlay.dart';

class App extends StatefulWidget {
  final IAppScope _scope;

  const App({super.key, required IAppScope scope}) : _scope = scope;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DiScope<IAppScope>(
      key: ObjectKey(widget._scope),
      factory: () {
        return widget._scope;
      },
      dispose: (context, scope) => scope.dispose(),
      child: GlobalLoaderOverlay(
        overlayColor: darkBlue80,
        overlayWidgetBuilder: (_) => Center(
          child: SpinKitThreeBounce(
            color: white,
          ),
        ),
        child: MaterialApp.router(
          /// Localization
          locale: _localizations.first,
          localizationsDelegates: _localizationsDelegates,
          supportedLocales: _localizations,

          /// Theme
          theme: defaultTheme,

          /// Routing
          // routeInformationParser: const EmptyRouteParser(),
          routerDelegate: widget._scope.router.delegate(),
          routeInformationParser: widget._scope.router.defaultRouteParser(),

          builder: _builder,
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    final easyLoaingBuilder = EasyLoading.init();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: easyLoaingBuilder(context, child),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          context.l10n.app_name,
        ),
      ),
    );
  }
}

const _localizations = [Locale('ru', 'RU')];

const _localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  AppLocalizations.delegate,
];
