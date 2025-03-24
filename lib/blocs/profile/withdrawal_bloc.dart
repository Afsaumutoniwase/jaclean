import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ------------------ Events ------------------

abstract class WithdrawalEvent extends Equatable {
  const WithdrawalEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrentBalance extends WithdrawalEvent {}

class ProcessWithdrawal extends WithdrawalEvent {
  final double amount;

  const ProcessWithdrawal(this.amount);

  @override
  List<Object> get props => [amount];
}

// ------------------ States ------------------

abstract class WithdrawalState extends Equatable {
  const WithdrawalState();

  @override
  List<Object> get props => [];
}

class WithdrawalInitial extends WithdrawalState {}

class WithdrawalLoading extends WithdrawalState {}

class WithdrawalLoaded extends WithdrawalState {
  final double currentBalance;
  final String bankName;
  final String accountNumber;
  final String accountName;

  const WithdrawalLoaded({
    required this.currentBalance,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  @override
  List<Object> get props => [currentBalance, bankName, accountNumber, accountName];
}

class WithdrawalSuccess extends WithdrawalState {
  final double newBalance;

  const WithdrawalSuccess({required this.newBalance});

  @override
  List<Object> get props => [newBalance];
}

class WithdrawalFailure extends WithdrawalState {
  final String error;

  const WithdrawalFailure(this.error);

  @override
  List<Object> get props => [error];
}

// ------------------ Bloc ------------------

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  WithdrawalBloc() : super(WithdrawalInitial()) {
    on<FetchCurrentBalance>(_onFetchCurrentBalance);
    on<ProcessWithdrawal>(_onProcessWithdrawal);
  }

  Future<void> _onFetchCurrentBalance(
    FetchCurrentBalance event,
    Emitter<WithdrawalState> emit,
  ) async {
    emit(WithdrawalLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const WithdrawalFailure("No user signed in"));
        return;
      }

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      double balance = 10000.0; // Default if not yet set

      if (snapshot.exists && snapshot.data()?['balance'] != null) {
        balance = (snapshot.data()?['balance'] as num).toDouble();
      } else {
        // Save initial balance
        await userDoc.set({'balance': balance}, SetOptions(merge: true));
      }

      // You may also retrieve stored bank details here
      final bankName = snapshot.data()?['bankName'] ?? 'Sample Bank';
      final accountNumber = snapshot.data()?['accountNumber'] ?? '1234567890';
      final accountName = snapshot.data()?['accountName'] ?? 'John Doe';

      print("Fetched balance: $balance");

      emit(WithdrawalLoaded(
        currentBalance: balance,
        bankName: bankName,
        accountNumber: accountNumber,
        accountName: accountName,
      ));
    } catch (e) {
      emit(WithdrawalFailure(e.toString()));
    }
  }

  Future<void> _onProcessWithdrawal(
    ProcessWithdrawal event,
    Emitter<WithdrawalState> emit,
  ) async {
    emit(WithdrawalLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const WithdrawalFailure("No user signed in"));
        return;
      }

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      double currentBalance = (snapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;

      print("Processing withdrawal: current balance = $currentBalance, withdrawal amount = ${event.amount}");

      if (currentBalance >= event.amount) {
        final newBalance = currentBalance - event.amount;

        // Update balance
        await userDoc.update({'balance': newBalance});

        // Add withdrawal record
        await FirebaseFirestore.instance.collection('withdrawals').add({
          'userId': user.uid,
          'amount': event.amount,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Withdrawal successful. New balance: $newBalance");

        emit(WithdrawalSuccess(newBalance: newBalance));
      } else {
        print("Insufficient funds: current balance = $currentBalance, withdrawal amount = ${event.amount}");
        emit(const WithdrawalFailure("Insufficient balance"));
      }
    } catch (e) {
      emit(WithdrawalFailure(e.toString()));
    }
  }
}
