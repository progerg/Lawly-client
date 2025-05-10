import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/auth_remote_data_source.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/navigation/service/router.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final AuthRemoteDataSource _authRemoteDataSource;
  final TokenLocalDataSource _tokenLocalDataSource;
  final AuthBloc _authBloc;
  final AppRouter _appRouter;

  bool _isTokenRefresh = false;

  final _pendingRequests = <RequestOptions, Completer<Response>>{};

  AuthInterceptor({
    required Dio dio,
    required AuthRemoteDataSource authRemoteDataSource,
    required TokenLocalDataSource tokenLocalDataSource,
    required AuthBloc authBloc,
    required AppRouter appRouter,
  })  : _dio = dio,
        _authRemoteDataSource = authRemoteDataSource,
        _tokenLocalDataSource = tokenLocalDataSource,
        _authBloc = authBloc,
        _appRouter = appRouter;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = _tokenLocalDataSource.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await _retryWithRefreshedToken(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        await _handleLogout();
        return handler.next(e);
      }
    }

    return handler.next(err);
  }

  Future<Response> _retryWithRefreshedToken(
      RequestOptions requestOptions) async {
    final completer = Completer<Response>();
    _pendingRequests[requestOptions] = completer;

    if (!_isTokenRefresh) {
      _isTokenRefresh = true;

      try {
        await _refreshToken();

        for (final request in _pendingRequests.keys) {
          final accessToken = _tokenLocalDataSource.getAccessToken();
          request.headers['Authorization'] = 'Bearer $accessToken';

          try {
            final response = await _dio.fetch(request);
            _pendingRequests[request]!.complete(response);
          } catch (e) {
            _pendingRequests[request]!.completeError(e);
            rethrow;
          }
        }
      } catch (e) {
        for (final request in _pendingRequests.keys) {
          _pendingRequests[request]!.completeError(e);
          rethrow;
        }
      } finally {
        _isTokenRefresh = false;
        _pendingRequests.clear();
      }
    }

    return completer.future;
  }

  Future<void> _refreshToken() async {
    final config = Environment<AppConfig>.instance().config;

    final refreshToken = _tokenLocalDataSource.getRefreshToken();
    if (refreshToken == null) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'No refresh token available',
      );
    }

    try {
      final response = await _authRemoteDataSource.refreshTokens(
        deviceId: config.deviceId,
        deviceOs: config.deviceOs,
        deviceName: config.deviceName,
        refreshToken: refreshToken,
      );

      await _tokenLocalDataSource.saveAccessToken(response.accessToken);
      await _tokenLocalDataSource.saveRefreshToken(response.refreshToken);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Failed to refresh token',
        error: e,
      );
    }
  }

  Future<void> _handleLogout() async {
    await _tokenLocalDataSource.clearTokens();

    _authBloc.add(AuthEvent.loggedOut());
    _appRouter.push(const ProfileRouter());
    log('Logout');
  }
}
