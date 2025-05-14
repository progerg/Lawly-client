import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';

part 'sub_event.dart';
part 'sub_state.dart';
part 'sub_bloc.freezed.dart';

class SubBloc extends Bloc<SubEvent, SubState> {
  SubBloc() : super(const _UnsubState()) {
    on<SubEvent>(_onEvent);
  }

  void _onEvent(SubEvent event, Emitter<SubState> emit) {
    if (event is _SetSubEvent) {
      _onSetSub(event, emit);
    } else if (event is _RemoveSubEvent) {
      _onRemoveSub(event, emit);
    }
  }

  void _onSetSub(_SetSubEvent event, Emitter<SubState> emit) {
    emit(SubState.sub(subscribeEntity: event.subscribeEntity));
  }

  void _onRemoveSub(_RemoveSubEvent event, Emitter<SubState> emit) {
    emit(const SubState.unsub());
  }
}
