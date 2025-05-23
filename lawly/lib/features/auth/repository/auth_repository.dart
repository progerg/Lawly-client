import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/api/data_sources/remote/user_service/auth_remote_data_source.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

abstract class IAuthRepository {
  Future<void> signIn({
    required AuthorizedUserEntity entity,
  });

  Future<void> register({
    required AuthorizedUserEntity entity,
  });

  Future<void> logout({
    required String deviceId,
  });
}

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final TokenLocalDataSource _tokenLocalDataSource;

  AuthRepository(
      {required AuthRemoteDataSource authRemoteDataSource,
      required TokenLocalDataSource tokenLocalDataSource})
      : _tokenLocalDataSource = tokenLocalDataSource,
        _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<void> signIn({
    required AuthorizedUserEntity entity,
  }) async {
    try {
      final response = await _authRemoteDataSource.login(
        request: entity.toModel(),
      );

      // TODO: логи
      log('Access token (AUTH): ${response.accessToken}');
      log('Refresh token (AUTH): ${response.refreshToken}');

      _tokenLocalDataSource.saveAccessToken(response.accessToken);
      _tokenLocalDataSource.saveRefreshToken(response.refreshToken);
    } on DioException catch (e) {
      log(e.response?.statusCode.toString() ?? 'Unknown error');
      rethrow;
    }
  }

  @override
  Future<void> register({required AuthorizedUserEntity entity}) async {
    try {
      final response = await _authRemoteDataSource.register(
        request: entity.toModel(),
      );

      // TODO: логи
      log('Access token (REG): ${response.accessToken}');
      log('Refresh token (REG): ${response.refreshToken}');

      _tokenLocalDataSource.saveAccessToken(response.accessToken);
      _tokenLocalDataSource.saveRefreshToken(response.refreshToken);
    } on DioException catch (e) {
      log(e.response?.statusCode.toString() ?? 'Unknown error');
      rethrow;
    }
  }

  @override
  Future<void> logout({
    required String deviceId,
  }) async {
    try {
      final refreshToken = _tokenLocalDataSource.getRefreshToken() ?? '';

      await _authRemoteDataSource.logout(
        deviceId: deviceId,
        refreshToken: refreshToken,
      );
    } on DioException catch (e) {
      log(e.response?.statusCode.toString() ?? 'Unknown error');
      rethrow;
    }
  }
}
