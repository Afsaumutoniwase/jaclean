import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class BankTransferEvent extends Equatable {
  const BankTransferEvent();

  @override
  List<Object> get props => [];
}

class CompleteBankTransfer extends BankTransferEvent {}

// States
abstract class BankTransferState extends Equatable {
  const BankTransferState();

  @override
  List<Object> get props => [];
}

class BankTransferInitial extends BankTransferState {}

class BankTransferLoading extends BankTransferState {}

class BankTransferSuccess extends BankTransferState {}

class BankTransferError extends BankTransferState {
  final String message;

  const BankTransferError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class BankTransferBloc extends Bloc<BankTransferEvent, BankTransferState> {
  BankTransferBloc() : super(BankTransferInitial()) {
    on<CompleteBankTransfer>(_onCompleteBankTransfer);
  }

  Future<void> _onCompleteBankTransfer(CompleteBankTransfer event, Emitter<BankTransferState> emit) async {
    emit(BankTransferLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      emit(BankTransferSuccess());
    } catch (e) {
      emit(BankTransferError(e.toString()));
    }
  }
}