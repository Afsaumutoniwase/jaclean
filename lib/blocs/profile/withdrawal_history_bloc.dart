import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class WithdrawalHistoryEvent extends Equatable {
  const WithdrawalHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchWithdrawalHistory extends WithdrawalHistoryEvent {}

// States
abstract class WithdrawalHistoryState extends Equatable {
  const WithdrawalHistoryState();

  @override
  List<Object> get props => [];
}

class WithdrawalHistoryInitial extends WithdrawalHistoryState {}

class WithdrawalHistoryLoading extends WithdrawalHistoryState {}

class WithdrawalHistoryLoaded extends WithdrawalHistoryState {
  final List<Map<String, dynamic>> withdrawals;

  const WithdrawalHistoryLoaded(this.withdrawals);

  @override
  List<Object> get props => [withdrawals];
}

class WithdrawalHistoryError extends WithdrawalHistoryState {
  final String error;

  const WithdrawalHistoryError(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class WithdrawalHistoryBloc extends Bloc<WithdrawalHistoryEvent, WithdrawalHistoryState> {
  WithdrawalHistoryBloc() : super(WithdrawalHistoryInitial()) {
    on<FetchWithdrawalHistory>(_onFetchWithdrawalHistory);
  }

  Future<void> _onFetchWithdrawalHistory(
      FetchWithdrawalHistory event, Emitter<WithdrawalHistoryState> emit) async {
    emit(WithdrawalHistoryLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const WithdrawalHistoryError("No user signed in"));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('withdrawals')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      final withdrawals = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      emit(WithdrawalHistoryLoaded(withdrawals));
    } catch (e) {
      emit(WithdrawalHistoryError(e.toString()));
    }
  }
}