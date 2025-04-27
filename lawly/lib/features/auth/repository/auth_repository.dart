import 'package:lawly/features/common/domain/entity/user_entity.dart';

abstract class IAuthRepository {
  Future<AuthorizedUserEntity> signIn();
}

class AuthRepository implements IAuthRepository {
  @override
  Future<AuthorizedUserEntity> signIn() => Future.value(
        AuthorizedUserEntity(
          id: '123',
          firstName: 'Саша',
          lastName: 'Самодуров',
          email: 'china@mail.ru',
        ),
      );
}
