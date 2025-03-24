import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordSubmitted({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [newPassword, confirmPassword];
}

// States
abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  const ChangePasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    if (event.newPassword != event.confirmPassword) {
      emit(const ChangePasswordFailure("Passwords do not match"));
      return;
    }
    if (event.newPassword.isEmpty) {
      emit(const ChangePasswordFailure("Password cannot be empty"));
      return;
    }

    emit(ChangePasswordLoading());

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const ChangePasswordFailure("No user is currently signed in"));
        return;
      }

      await user.updatePassword(event.newPassword);

      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ChangePasswordFailure(e.message ?? "An error occurred"));
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}