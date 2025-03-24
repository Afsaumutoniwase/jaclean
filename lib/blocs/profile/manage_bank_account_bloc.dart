import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class ManageBankAccountEvent extends Equatable {
  const ManageBankAccountEvent();

  @override
  List<Object> get props => [];
}

class FetchBankDetails extends ManageBankAccountEvent {}

class UpdateBankDetails extends ManageBankAccountEvent {
  final String accountName;
  final String accountNumber;
  final String bankName;

  const UpdateBankDetails({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  @override
  List<Object> get props => [accountName, accountNumber, bankName];
}

// States
abstract class ManageBankAccountState extends Equatable {
  const ManageBankAccountState();

  @override
  List<Object> get props => [];
}

class ManageBankAccountInitial extends ManageBankAccountState {}

class ManageBankAccountLoading extends ManageBankAccountState {}

class ManageBankAccountLoaded extends ManageBankAccountState {
  final String accountName;
  final String accountNumber;
  final String bankName;

  const ManageBankAccountLoaded({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  @override
  List<Object> get props => [accountName, accountNumber, bankName];
}

class ManageBankAccountSuccess extends ManageBankAccountState {}

class ManageBankAccountFailure extends ManageBankAccountState {
  final String error;

  const ManageBankAccountFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class ManageBankAccountBloc extends Bloc<ManageBankAccountEvent, ManageBankAccountState> {
  ManageBankAccountBloc() : super(ManageBankAccountInitial()) {
    on<FetchBankDetails>(_onFetchBankDetails);
    on<UpdateBankDetails>(_onUpdateBankDetails);
  }

  Future<void> _onFetchBankDetails(
      FetchBankDetails event, Emitter<ManageBankAccountState> emit) async {
    emit(ManageBankAccountLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          emit(ManageBankAccountLoaded(
            accountName: doc.data()?['accountName'] ?? '',
            accountNumber: doc.data()?['accountNumber'] ?? '',
            bankName: doc.data()?['bankName'] ?? '',
          ));
        } else {
          emit(const ManageBankAccountFailure("No bank details found"));
        }
      } else {
        emit(const ManageBankAccountFailure("No user is currently signed in"));
      }
    } catch (e) {
      emit(ManageBankAccountFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBankDetails(
      UpdateBankDetails event, Emitter<ManageBankAccountState> emit) async {
    emit(ManageBankAccountLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'accountName': event.accountName,
          'accountNumber': event.accountNumber,
          'bankName': event.bankName,
        });

        emit(ManageBankAccountSuccess());
      } else {
        emit(const ManageBankAccountFailure("No user is currently signed in"));
      }
    } catch (e) {
      emit(ManageBankAccountFailure(e.toString()));
    }
  }
}