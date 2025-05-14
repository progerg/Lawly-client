part of 'sub_bloc.dart';

@freezed
class SubState with _$SubState {
  SubscribeEntity? get currentSubOrNull =>
      this is _SubState ? (this as _SubState).subscribeEntity : null;

  const SubState._();

  const factory SubState.sub({required SubscribeEntity subscribeEntity}) =
      _SubState;
  const factory SubState.unsub() = _UnsubState;
}
