part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loggedIn(
      {required AuthorizedUserEntity authorizedUser}) = _LoggedInEvent;
  const factory AuthEvent.loggedOut() = _LoggedOutEvent;
}
