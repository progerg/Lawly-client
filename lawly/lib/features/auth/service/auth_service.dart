import 'package:lawly/features/auth/repository/auth_repository.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

class AuthService {
  final IAuthRepository _authRepository;
  AuthService({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> signIn({required AuthorizedUserEntity entity}) =>
      _authRepository.signIn(entity: entity);

  Future<void> register({required AuthorizedUserEntity entity}) =>
      _authRepository.register(entity: entity);

  Future<void> logout({required String deviceId}) =>
      _authRepository.logout(deviceId: deviceId);
}
