import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class WithdrawalSuccessEvent extends Equatable {
  const WithdrawalSuccessEvent();

  @override
  List<Object> get props => [];
}

class GoBackEvent extends WithdrawalSuccessEvent {}

// States
abstract class WithdrawalSuccessState extends Equatable {
  const WithdrawalSuccessState();

  @override
  List<Object> get props => [];
}

class WithdrawalSuccessInitial extends WithdrawalSuccessState {}

class WithdrawalSuccessNavigatingBack extends WithdrawalSuccessState {}

// BLoC
class WithdrawalSuccessBloc extends Bloc<WithdrawalSuccessEvent, WithdrawalSuccessState> {
  WithdrawalSuccessBloc() : super(WithdrawalSuccessInitial()) {
    on<GoBackEvent>(_onGoBackEvent);
  }

  void _onGoBackEvent(GoBackEvent event, Emitter<WithdrawalSuccessState> emit) {
    emit(WithdrawalSuccessNavigatingBack());
  }
}
