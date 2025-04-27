import 'package:equatable/equatable.dart';

abstract class UserEntity {
  bool get isAuthorized;
}

class AuthorizedUserEntity extends Equatable implements UserEntity {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;

  const AuthorizedUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  bool get isAuthorized => true;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
      ];
}
