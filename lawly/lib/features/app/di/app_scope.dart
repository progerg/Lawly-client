import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lawly/api/data_sources/local/init_local_data_source.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/repository/auth_repository.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/init/repository/i_init_reposioty.dart';
import 'package:lawly/features/init/repository/init_repository.dart';
import 'package:lawly/features/init/service/init_service.dart';
import 'package:lawly/features/navigation/service/guards/auth_guard.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAppScope {
  Dio get dio;

  AppRouter get router;

  SharedPreferences get prefs;

  InitLocalDataSource get initLocalDataSource;

  IInitRepository get initRepository;

  InitService get initService;

  AuthGuard get authGuard;

  AuthBloc get authBloc;

  AuthRepository get authRepository;

  AuthService get authService;

  NavBarObserver get navBarObserver;

  void dispose();

  Future<void> init();
}

class AppScope implements IAppScope {
  @override
  late final Dio dio;

  @override
  late final AppRouter router;

  @override
  late final SharedPreferences prefs;

  @override
  late final InitLocalDataSource initLocalDataSource;

  @override
  late final IInitRepository initRepository;

  @override
  late final InitService initService;

  @override
  late final AuthGuard authGuard;

  @override
  late final AuthBloc authBloc;

  @override
  late final AuthRepository authRepository;

  @override
  late final AuthService authService;

  @override
  late final NavBarObserver navBarObserver;

  @override
  void dispose() {}

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    dio = _initDio();

    initLocalDataSource = InitLocalDataSource(prefs);
    initRepository = InitRepository(initLocalDataSource);
    initService = InitService(initRepository);

    navBarObserver = NavBarObserver();

    authBloc = AuthBloc();

    authRepository = AuthRepository();

    authService = AuthService(
      authRepository: authRepository,
    );

    authGuard = AuthGuard(authBloc: authBloc);

    router = AppRouter(
      initService: initService,
      authGuard: authGuard,
    );
  }

  Dio _initDio() {
    final env = Enviroment<AppConfig>.instance();
    const timeout = Duration(seconds: 30);

    final dio = Dio();

    dio.options
      ..baseUrl = env.config.url
      ..connectTimeout = timeout
      ..receiveTimeout = timeout
      ..sendTimeout = timeout;

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final proxyUrl = env.config.proxyUrl;
      final client = HttpClient()..idleTimeout = const Duration(seconds: 3);
      if (proxyUrl != null && proxyUrl.isNotEmpty) {
        client
          ..findProxy = (uri) {
            return 'PROXY $proxyUrl';
          }
          ..badCertificateCallback = (_, __, ___) {
            return true;
          };
      }

      return client;
    };

    return dio;
  }
}
