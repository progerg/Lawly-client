import 'package:equatable/equatable.dart';
import 'package:lawly/api/models/auth/authorized_user_model.dart';

abstract class UserEntity {
  bool get isAuthorized;
}

class AuthorizedUserEntity extends Equatable implements UserEntity {
  final String email;
  final String password;
  final String deviceId;
  final String deviceOs;
  final String deviceName;
  final String? name;
  final bool? agreeToTerms;

  const AuthorizedUserEntity({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceOs,
    required this.deviceName,
    this.name,
    this.agreeToTerms,
  });

  @override
  bool get isAuthorized => true;

  @override
  List<Object?> get props => [
        email,
        password,
        deviceId,
        deviceOs,
        deviceName,
        name,
        agreeToTerms,
      ];

  AuthorizedUserModel toModel() {
    return AuthorizedUserModel(
      email: email,
      password: password,
      deviceId: deviceId,
      deviceOs: deviceOs,
      deviceName: deviceName,
      name: name,
      agreeToTerms: agreeToTerms,
    );
  }

  AuthorizedUserEntity copyWith({
    String? email,
    String? password,
    String? deviceId,
    String? deviceOs,
    String? deviceName,
    String? name,
    bool? agreeToTerms,
  }) =>
      AuthorizedUserEntity(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        deviceId: deviceId ?? this.deviceId,
        deviceOs: deviceOs ?? this.deviceOs,
        deviceName: deviceName ?? this.deviceName,
        agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      );
}
