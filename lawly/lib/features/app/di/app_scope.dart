import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lawly/api/data_sources/local/init_local_data_source.dart';
import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/api/data_sources/remote/auth_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/documents_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/subscribe_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_remote_data_source.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/domain/entities/auth_interceptor.dart';
import 'package:lawly/features/auth/repository/auth_repository.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/repository/documents_repository.dart';
import 'package:lawly/features/documents/service/documents_service.dart';
import 'package:lawly/features/init/repository/i_init_reposioty.dart';
import 'package:lawly/features/init/repository/init_repository.dart';
import 'package:lawly/features/init/service/init_service.dart';
import 'package:lawly/features/navigation/service/guards/auth_guard.dart';
import 'package:lawly/features/navigation/service/observers/nav_bar_observer.dart';
import 'package:lawly/features/navigation/service/router.dart';
import 'package:lawly/features/profile/repository/subscribe_repository.dart';
import 'package:lawly/features/profile/repository/user_info_repository.dart';
import 'package:lawly/features/profile/service/subscribe_service.dart';
import 'package:lawly/features/profile/service/user_info_service.dart';
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

  ScaffoldMessengerWrapper get scaffoldMessengerWrapper;

  TokenLocalDataSource get tokenLocalDataSource;

  AuthRemoteDataSource get authRemoteDataSource;

  SaveUserLocalDataSource get saveUserLocalDataSource;

  SaveUserService get saveUserService;

  DocumentsRemoteDataSource get documentsRemoteDataSource;

  DocumentsRepository get documentsRepository;

  DocumentsService get documentsService;

  UserRemoteDataSource get userRemoteDataSource;

  UserInfoRepository get userInfoRepository;

  UserInfoService get userInfoService;

  SubscribeRemoteDataSource get subscribeRemoteDataSource;

  SubscribeRepository get subscribeRepository;

  SubscribeService get subscribeService;

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
  late final ScaffoldMessengerWrapper scaffoldMessengerWrapper;

  @override
  late final TokenLocalDataSource tokenLocalDataSource;

  @override
  late final AuthRemoteDataSource authRemoteDataSource;

  @override
  late final SaveUserLocalDataSource saveUserLocalDataSource;

  @override
  late final SaveUserService saveUserService;

  @override
  late final DocumentsRemoteDataSource documentsRemoteDataSource;

  @override
  late final DocumentsRepository documentsRepository;

  @override
  late final DocumentsService documentsService;

  @override
  late final UserRemoteDataSource userRemoteDataSource;

  @override
  late final UserInfoRepository userInfoRepository;

  @override
  late final UserInfoService userInfoService;

  @override
  late final SubscribeRemoteDataSource subscribeRemoteDataSource;

  @override
  late final SubscribeRepository subscribeRepository;

  @override
  late final SubscribeService subscribeService;

  @override
  void dispose() {}

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    dio = _initDio();

    scaffoldMessengerWrapper = ScaffoldMessengerWrapper();

    initLocalDataSource = InitLocalDataSource(prefs);
    initRepository = InitRepository(initLocalDataSource);
    initService = InitService(initRepository);

    authBloc = AuthBloc();

    authGuard = AuthGuard(authBloc: authBloc);

    router = AppRouter(
      initService: initService,
      authGuard: authGuard,
    );

    saveUserLocalDataSource = SaveUserLocalDataSource(prefs: prefs);
    saveUserService = SaveUserService(
      saveUserLocalDataSource: saveUserLocalDataSource,
    );

    tokenLocalDataSource = TokenLocalDataSource(prefs: prefs);
    authRemoteDataSource = AuthRemoteDataSource(dio);

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        authRemoteDataSource: authRemoteDataSource,
        tokenLocalDataSource: tokenLocalDataSource,
        authBloc: authBloc,
        appRouter: router,
      ),
    );

    documentsRemoteDataSource = DocumentsRemoteDataSource(dio);
    documentsRepository = DocumentsRepository(
      documentsRemoteDataSource: documentsRemoteDataSource,
    );
    documentsService = DocumentsService(
      documentsRepository: documentsRepository,
    );

    navBarObserver = NavBarObserver();

    authRepository = AuthRepository(
      authRemoteDataSource: authRemoteDataSource,
      tokenLocalDataSource: tokenLocalDataSource,
    );

    authService = AuthService(
      authRepository: authRepository,
    );

    subscribeRemoteDataSource = SubscribeRemoteDataSource(dio);
    subscribeRepository = SubscribeRepository(
      subscribeRemoteDataSource: subscribeRemoteDataSource,
    );
    subscribeService = SubscribeService(
      subscribeRepository: subscribeRepository,
    );

    userRemoteDataSource = UserRemoteDataSource(dio);
    userInfoRepository = UserInfoRepository(
      userRemoteDataSource: userRemoteDataSource,
    );
    userInfoService = UserInfoService(
      userInfoRepository: userInfoRepository,
    );
  }

  Dio _initDio() {
    final env = Environment<AppConfig>.instance();
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
