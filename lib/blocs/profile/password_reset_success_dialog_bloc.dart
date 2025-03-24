import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class PasswordResetSuccessDialogEvent extends Equatable {
  const PasswordResetSuccessDialogEvent();

  @override
  List<Object> get props => [];
}

class ProceedEvent extends PasswordResetSuccessDialogEvent {}

// States
abstract class PasswordResetSuccessDialogState extends Equatable {
  const PasswordResetSuccessDialogState();

  @override
  List<Object> get props => [];
}

class PasswordResetSuccessDialogInitial extends PasswordResetSuccessDialogState {}

class PasswordResetSuccessDialogProceeding extends PasswordResetSuccessDialogState {}

// BLoC
class PasswordResetSuccessDialogBloc extends Bloc<PasswordResetSuccessDialogEvent, PasswordResetSuccessDialogState> {
  PasswordResetSuccessDialogBloc() : super(PasswordResetSuccessDialogInitial()) {
    on<ProceedEvent>(_onProceedEvent);
  }

  void _onProceedEvent(ProceedEvent event, Emitter<PasswordResetSuccessDialogState> emit) {
    emit(PasswordResetSuccessDialogProceeding());
  }
}