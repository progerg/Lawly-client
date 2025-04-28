// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent()';
  }
}

/// @nodoc
class $AuthEventCopyWith<$Res> {
  $AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}

/// @nodoc

class _LoggedInEvent implements AuthEvent {
  const _LoggedInEvent({required this.authorizedUser});

  final AuthorizedUserEntity authorizedUser;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoggedInEventCopyWith<_LoggedInEvent> get copyWith =>
      __$LoggedInEventCopyWithImpl<_LoggedInEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoggedInEvent &&
            (identical(other.authorizedUser, authorizedUser) ||
                other.authorizedUser == authorizedUser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authorizedUser);

  @override
  String toString() {
    return 'AuthEvent.loggedIn(authorizedUser: $authorizedUser)';
  }
}

/// @nodoc
abstract mixin class _$LoggedInEventCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory _$LoggedInEventCopyWith(
          _LoggedInEvent value, $Res Function(_LoggedInEvent) _then) =
      __$LoggedInEventCopyWithImpl;
  @useResult
  $Res call({AuthorizedUserEntity authorizedUser});
}

/// @nodoc
class __$LoggedInEventCopyWithImpl<$Res>
    implements _$LoggedInEventCopyWith<$Res> {
  __$LoggedInEventCopyWithImpl(this._self, this._then);

  final _LoggedInEvent _self;
  final $Res Function(_LoggedInEvent) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? authorizedUser = null,
  }) {
    return _then(_LoggedInEvent(
      authorizedUser: null == authorizedUser
          ? _self.authorizedUser
          : authorizedUser // ignore: cast_nullable_to_non_nullable
              as AuthorizedUserEntity,
    ));
  }
}

/// @nodoc

class _LoggedOutEvent implements AuthEvent {
  const _LoggedOutEvent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _LoggedOutEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.loggedOut()';
  }
}

/// @nodoc
mixin _$AuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState()';
  }
}

/// @nodoc
class $AuthStateCopyWith<$Res> {
  $AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}

/// @nodoc

class _AuthorizedState extends AuthState {
  const _AuthorizedState({required this.authorizedUser}) : super._();

  final AuthorizedUserEntity authorizedUser;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthorizedStateCopyWith<_AuthorizedState> get copyWith =>
      __$AuthorizedStateCopyWithImpl<_AuthorizedState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthorizedState &&
            (identical(other.authorizedUser, authorizedUser) ||
                other.authorizedUser == authorizedUser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authorizedUser);

  @override
  String toString() {
    return 'AuthState.authorized(authorizedUser: $authorizedUser)';
  }
}

/// @nodoc
abstract mixin class _$AuthorizedStateCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$AuthorizedStateCopyWith(
          _AuthorizedState value, $Res Function(_AuthorizedState) _then) =
      __$AuthorizedStateCopyWithImpl;
  @useResult
  $Res call({AuthorizedUserEntity authorizedUser});
}

/// @nodoc
class __$AuthorizedStateCopyWithImpl<$Res>
    implements _$AuthorizedStateCopyWith<$Res> {
  __$AuthorizedStateCopyWithImpl(this._self, this._then);

  final _AuthorizedState _self;
  final $Res Function(_AuthorizedState) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? authorizedUser = null,
  }) {
    return _then(_AuthorizedState(
      authorizedUser: null == authorizedUser
          ? _self.authorizedUser
          : authorizedUser // ignore: cast_nullable_to_non_nullable
              as AuthorizedUserEntity,
    ));
  }
}

/// @nodoc

class _NotAuthorizedState extends AuthState {
  const _NotAuthorizedState() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _NotAuthorizedState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.notAuthorized()';
  }
}

// dart format on
