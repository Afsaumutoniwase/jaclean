import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class MobileMoneyEvent extends Equatable {
  const MobileMoneyEvent();

  @override
  List<Object> get props => [];
}

class SubmitMobileMoneyPayment extends MobileMoneyEvent {
  final String network;
  final String number;
  final String pin;
  final double amount;

  const SubmitMobileMoneyPayment({
    required this.network,
    required this.number,
    required this.pin,
    required this.amount,
  });

  @override
  List<Object> get props => [network, number, pin, amount];
}

// States
abstract class MobileMoneyState extends Equatable {
  const MobileMoneyState();

  @override
  List<Object> get props => [];
}

class MobileMoneyInitial extends MobileMoneyState {}

class MobileMoneyLoading extends MobileMoneyState {}

class MobileMoneySuccess extends MobileMoneyState {}

class MobileMoneyError extends MobileMoneyState {
  final String message;

  const MobileMoneyError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MobileMoneyBloc extends Bloc<MobileMoneyEvent, MobileMoneyState> {
  MobileMoneyBloc() : super(MobileMoneyInitial()) {
    on<SubmitMobileMoneyPayment>(_onSubmitMobileMoneyPayment);
  }

  Future<void> _onSubmitMobileMoneyPayment(
      SubmitMobileMoneyPayment event, Emitter<MobileMoneyState> emit) async {
    emit(MobileMoneyLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      if (event.pin == "1234") {
        emit(MobileMoneySuccess());
      } else {
        emit(const MobileMoneyError('Invalid PIN'));
      }
    } catch (e) {
      emit(MobileMoneyError(e.toString()));
    }
  }
}