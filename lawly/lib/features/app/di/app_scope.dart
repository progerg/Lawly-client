import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lawly/api/data_sources/local/init_local_data_source.dart';
import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/api/data_sources/remote/doc_service/generate_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/doc_service/templates_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/auth_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/documents_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/subscribe_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/user_remote_data_source.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/core/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/app/domain/entities/auth_interceptor.dart';
import 'package:lawly/features/auth/repository/auth_repository.dart';
import 'package:lawly/features/auth/repository/save_user_repository.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/documents/repository/documents_repository.dart';
import 'package:lawly/features/documents/repository/personal_documents_repository.dart';
import 'package:lawly/features/documents/service/documents_service.dart';
import 'package:lawly/features/documents/service/personal_documents_service.dart';
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
import 'package:lawly/features/templates/repository/template_repository.dart';
import 'package:lawly/features/templates/service/template_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAppScope {
  Dio get dioUserService;

  Dio get dioDocService;

  AppRouter get router;

  SharedPreferences get prefs;

  InitLocalDataSource get initLocalDataSource;

  IInitRepository get initRepository;

  InitService get initService;

  AuthGuard get authGuard;

  AuthBloc get authBloc;

  SubBloc get subBloc;

  AuthRepository get authRepository;

  AuthService get authService;

  NavBarObserver get navBarObserver;

  ScaffoldMessengerWrapper get scaffoldMessengerWrapper;

  TokenLocalDataSource get tokenLocalDataSource;

  AuthRemoteDataSource get authRemoteDataSource;

  SaveUserLocalDataSource get saveUserLocalDataSource;

  SaveUserRepository get saveUserRepository;

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

  TemplatesRemoteDataSource get templatesRemoteDataSource;

  PersonalDocumentsRepository get personalDocumentsRepository;

  PersonalDocumentsService get personalDocumentsService;

  TemplateRepository get templateRepository;

  TemplateService get templateService;

  GenerateRemoteDataSource get generateRemoteDataSource;

  void dispose();

  Future<void> init();
}

class AppScope implements IAppScope {
  @override
  late final Dio dioUserService;

  @override
  late final Dio dioDocService;

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
  late final SubBloc subBloc;

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
  late final SaveUserRepository saveUserRepository;

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
  late final TemplatesRemoteDataSource templatesRemoteDataSource;

  @override
  late final PersonalDocumentsRepository personalDocumentsRepository;

  @override
  late final PersonalDocumentsService personalDocumentsService;

  @override
  late final TemplateRepository templateRepository;

  @override
  late final TemplateService templateService;

  @override
  late final GenerateRemoteDataSource generateRemoteDataSource;

  @override
  void dispose() {}

  @override
  Future<void> init() async {
    final env = Environment<AppConfig>.instance();

    prefs = await SharedPreferences.getInstance();

    dioUserService = _initDio(
      baseUrl: env.config.userServiceUrl,
      proxyUrl: env.config.proxyUrl,
    );

    dioDocService = _initDio(
      baseUrl: env.config.docServiceUrl,
      proxyUrl: env.config.proxyUrl,
    );

    scaffoldMessengerWrapper = ScaffoldMessengerWrapper();

    initLocalDataSource = InitLocalDataSource(prefs);
    initRepository = InitRepository(initLocalDataSource);
    initService = InitService(initRepository);

    authBloc = AuthBloc();
    subBloc = SubBloc();

    authGuard = AuthGuard(authBloc: authBloc);

    router = AppRouter(
      initService: initService,
      authGuard: authGuard,
    );

    saveUserLocalDataSource = SaveUserLocalDataSource(prefs: prefs);
    saveUserRepository = SaveUserRepository(
      saveUserLocalDataSource: saveUserLocalDataSource,
    );
    saveUserService = SaveUserService(
      saveUserRepository: saveUserRepository,
    );

    tokenLocalDataSource = TokenLocalDataSource(prefs: prefs);
    authRemoteDataSource = AuthRemoteDataSource(dioUserService);

    dioUserService.interceptors.add(
      AuthInterceptor(
        dio: dioUserService,
        authRemoteDataSource: authRemoteDataSource,
        tokenLocalDataSource: tokenLocalDataSource,
        authBloc: authBloc,
        subBloc: subBloc,
        appRouter: router,
      ),
    );

    dioDocService.interceptors.add(
      AuthInterceptor(
        dio: dioDocService,
        authRemoteDataSource: authRemoteDataSource,
        tokenLocalDataSource: tokenLocalDataSource,
        authBloc: authBloc,
        subBloc: subBloc,
        appRouter: router,
      ),
    );

    documentsRemoteDataSource = DocumentsRemoteDataSource(dioUserService);
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

    subscribeRemoteDataSource = SubscribeRemoteDataSource(dioUserService);
    subscribeRepository = SubscribeRepository(
      subscribeRemoteDataSource: subscribeRemoteDataSource,
    );
    subscribeService = SubscribeService(
      subscribeRepository: subscribeRepository,
    );

    userRemoteDataSource = UserRemoteDataSource(dioUserService);
    userInfoRepository = UserInfoRepository(
      userRemoteDataSource: userRemoteDataSource,
    );
    userInfoService = UserInfoService(
      userInfoRepository: userInfoRepository,
    );

    templatesRemoteDataSource = TemplatesRemoteDataSource(dioDocService);
    generateRemoteDataSource = GenerateRemoteDataSource(dioDocService);

    personalDocumentsRepository = PersonalDocumentsRepository(
      templatesRemoteDataSource: templatesRemoteDataSource,
    );
    personalDocumentsService = PersonalDocumentsService(
      repository: personalDocumentsRepository,
    );

    templateRepository = TemplateRepository(
      templatesRemoteDataSource: templatesRemoteDataSource,
      generateRemoteDataSource: generateRemoteDataSource,
    );
    templateService = TemplateService(
      templateRepository: templateRepository,
    );
  }

  Dio _initDio({required String baseUrl, String? proxyUrl}) {
    const timeout = Duration(seconds: 30);

    final dio = Dio();

    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = timeout
      ..receiveTimeout = timeout
      ..sendTimeout = timeout;

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
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
