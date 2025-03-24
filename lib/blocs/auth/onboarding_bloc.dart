import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingNextPage extends OnboardingEvent {}

class OnboardingPreviousPage extends OnboardingEvent {}

class OnboardingSubmit extends OnboardingEvent {
  final String userName;
  final String selectedAvatar;
  final String selectedLocation;
  final String selectedCenter;
  final bool acceptedTerms;

  const OnboardingSubmit({
    required this.userName,
    required this.selectedAvatar,
    required this.selectedLocation,
    required this.selectedCenter,
    required this.acceptedTerms,
  });

  @override
  List<Object> get props => [
        userName,
        selectedAvatar,
        selectedLocation,
        selectedCenter,
        acceptedTerms,
      ];
}

// States
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingPreviousPage>(_onPreviousPage);
    on<OnboardingSubmit>(_onSubmit);
  }

  void _onNextPage(OnboardingNextPage event, Emitter<OnboardingState> emit) {
    emit(OnboardingLoading());
    // Logic to handle next page
    emit(OnboardingInitial());
  }

  void _onPreviousPage(OnboardingPreviousPage event, Emitter<OnboardingState> emit) {
    emit(OnboardingLoading());
    // Logic to handle previous page
    emit(OnboardingInitial());
  }

  Future<void> _onSubmit(OnboardingSubmit event, Emitter<OnboardingState> emit) async {
    emit(OnboardingLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'userName': event.userName,
          'selectedAvatar': event.selectedAvatar,
          'selectedLocation': event.selectedLocation,
          'selectedCenter': event.selectedCenter,
          'acceptedTerms': event.acceptedTerms,
        });
        emit(OnboardingSuccess());
      } else {
        emit(OnboardingError('User not authenticated'));
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}