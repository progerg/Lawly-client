part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  AuthorizedUserEntity? get authorizedUserOrNull => this is _AuthorizedState
      ? (this as _AuthorizedState).authorizedUser
      : null;

  bool get isAuthorized => this is _AuthorizedState;

  bool get isNotAuthorized => !isAuthorized;

  const AuthState._();

  const factory AuthState.authorized(
      {required AuthorizedUserEntity authorizedUser}) = _AuthorizedState;
  const factory AuthState.notAuthorized() = _NotAuthorizedState;
}
