import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/features/common/domain/entity/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const _NotAuthorizedState()) {
    on<AuthEvent>(_onEvent);
  }

  void _onEvent(AuthEvent event, Emitter<AuthState> emit) {
    if (event is _LoggedInEvent) {
      _onLoggedIn(event, emit);
    } else if (event is _LoggedOutEvent) {
      _onLoggedOut(event, emit);
    }
  }

  void _onLoggedIn(_LoggedInEvent event, Emitter<AuthState> emit) {
    emit(AuthState.authorized(authorizedUser: event.authorizedUser));
  }

  void _onLoggedOut(_LoggedOutEvent event, Emitter<AuthState> emit) {
    emit(const AuthState.notAuthorized());
  }
}
