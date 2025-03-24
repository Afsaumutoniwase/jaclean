import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AddCardEvent extends Equatable {
  const AddCardEvent();

  @override
  List<Object> get props => [];
}

class SubmitCardDetails extends AddCardEvent {
  final String cardholderName;
  final String cardNumber;
  final String expirationDate;
  final String cvv;

  const SubmitCardDetails({
    required this.cardholderName,
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
  });

  @override
  List<Object> get props => [cardholderName, cardNumber, expirationDate, cvv];
}

// States
abstract class AddCardState extends Equatable {
  const AddCardState();

  @override
  List<Object> get props => [];
}

class AddCardInitial extends AddCardState {}

class AddCardLoading extends AddCardState {}

class AddCardSuccess extends AddCardState {}

class AddCardError extends AddCardState {
  final String message;

  const AddCardError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  AddCardBloc() : super(AddCardInitial()) {
    on<SubmitCardDetails>(_onSubmitCardDetails);
  }

  Future<void> _onSubmitCardDetails(SubmitCardDetails event, Emitter<AddCardState> emit) async {
    emit(AddCardLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      emit(AddCardSuccess());
    } catch (e) {
      emit(AddCardError(e.toString()));
    }
  }
}