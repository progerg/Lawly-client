// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SubEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubEvent()';
  }
}

/// @nodoc
class $SubEventCopyWith<$Res> {
  $SubEventCopyWith(SubEvent _, $Res Function(SubEvent) __);
}

/// @nodoc

class _SetSubEvent implements SubEvent {
  const _SetSubEvent({required this.subscribeEntity});

  final SubscribeEntity subscribeEntity;

  /// Create a copy of SubEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SetSubEventCopyWith<_SetSubEvent> get copyWith =>
      __$SetSubEventCopyWithImpl<_SetSubEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SetSubEvent &&
            (identical(other.subscribeEntity, subscribeEntity) ||
                other.subscribeEntity == subscribeEntity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subscribeEntity);

  @override
  String toString() {
    return 'SubEvent.setSub(subscribeEntity: $subscribeEntity)';
  }
}

/// @nodoc
abstract mixin class _$SetSubEventCopyWith<$Res>
    implements $SubEventCopyWith<$Res> {
  factory _$SetSubEventCopyWith(
          _SetSubEvent value, $Res Function(_SetSubEvent) _then) =
      __$SetSubEventCopyWithImpl;
  @useResult
  $Res call({SubscribeEntity subscribeEntity});
}

/// @nodoc
class __$SetSubEventCopyWithImpl<$Res> implements _$SetSubEventCopyWith<$Res> {
  __$SetSubEventCopyWithImpl(this._self, this._then);

  final _SetSubEvent _self;
  final $Res Function(_SetSubEvent) _then;

  /// Create a copy of SubEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? subscribeEntity = null,
  }) {
    return _then(_SetSubEvent(
      subscribeEntity: null == subscribeEntity
          ? _self.subscribeEntity
          : subscribeEntity // ignore: cast_nullable_to_non_nullable
              as SubscribeEntity,
    ));
  }
}

/// @nodoc

class _RemoveSubEvent implements SubEvent {
  const _RemoveSubEvent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RemoveSubEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubEvent.removeSub()';
  }
}

/// @nodoc
mixin _$SubState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SubState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubState()';
  }
}

/// @nodoc
class $SubStateCopyWith<$Res> {
  $SubStateCopyWith(SubState _, $Res Function(SubState) __);
}

/// @nodoc

class _SubState extends SubState {
  const _SubState({required this.subscribeEntity}) : super._();

  final SubscribeEntity subscribeEntity;

  /// Create a copy of SubState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubStateCopyWith<_SubState> get copyWith =>
      __$SubStateCopyWithImpl<_SubState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubState &&
            (identical(other.subscribeEntity, subscribeEntity) ||
                other.subscribeEntity == subscribeEntity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subscribeEntity);

  @override
  String toString() {
    return 'SubState.sub(subscribeEntity: $subscribeEntity)';
  }
}

/// @nodoc
abstract mixin class _$SubStateCopyWith<$Res>
    implements $SubStateCopyWith<$Res> {
  factory _$SubStateCopyWith(_SubState value, $Res Function(_SubState) _then) =
      __$SubStateCopyWithImpl;
  @useResult
  $Res call({SubscribeEntity subscribeEntity});
}

/// @nodoc
class __$SubStateCopyWithImpl<$Res> implements _$SubStateCopyWith<$Res> {
  __$SubStateCopyWithImpl(this._self, this._then);

  final _SubState _self;
  final $Res Function(_SubState) _then;

  /// Create a copy of SubState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? subscribeEntity = null,
  }) {
    return _then(_SubState(
      subscribeEntity: null == subscribeEntity
          ? _self.subscribeEntity
          : subscribeEntity // ignore: cast_nullable_to_non_nullable
              as SubscribeEntity,
    ));
  }
}

/// @nodoc

class _UnsubState extends SubState {
  const _UnsubState() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _UnsubState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubState.unsub()';
  }
}

// dart format on
