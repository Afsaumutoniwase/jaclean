import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends ProfileEvent {}

class SignOutUser extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;

  const ProfileLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class SignOutSuccess extends ProfileState {}

class SignOutFailure extends ProfileState {
  final String error;

  const SignOutFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<SignOutUser>(_onSignOutUser);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      // Fetch user profile logic here
      final Map<String, dynamic> userData = {}; // Replace with actual user data fetching logic
      emit(ProfileLoaded(userData));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onSignOutUser(SignOutUser event, Emitter<ProfileState> emit) async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(SignOutSuccess());
    } catch (e) {
      emit(SignOutFailure(e.toString()));
    }
  }
}