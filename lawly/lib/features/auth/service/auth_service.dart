import 'package:lawly/features/auth/repository/auth_repository.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

class AuthService {
  final IAuthRepository _authRepository;
  AuthService({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<AuthorizedUserEntity> signIn() => _authRepository.signIn();
}
