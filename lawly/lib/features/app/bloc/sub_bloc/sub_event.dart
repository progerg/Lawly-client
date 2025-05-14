part of 'sub_bloc.dart';

@freezed
class SubEvent with _$SubEvent {
  const factory SubEvent.setSub({required SubscribeEntity subscribeEntity}) =
      _SetSubEvent;
  const factory SubEvent.removeSub() = _RemoveSubEvent;
}
