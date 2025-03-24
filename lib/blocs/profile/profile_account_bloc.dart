import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ProfileAccountEvent extends Equatable {
  const ProfileAccountEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends ProfileAccountEvent {}

class UpdateProfileEvent extends ProfileAccountEvent {
  final String firstName;
  final String lastName;
  final String userName;
  final String? phone;
  final String? email;
  final String? gender;
  final DateTime? dob;

  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.phone,
    this.email,
    this.gender,
    this.dob,
  });

  @override
  List<Object?> get props => [firstName, lastName, userName, phone, email, gender, dob];
}

// States
abstract class ProfileAccountState extends Equatable {
  const ProfileAccountState();

  @override
  List<Object?> get props => [];
}

class ProfileAccountInitial extends ProfileAccountState {}

class ProfileAccountLoading extends ProfileAccountState {}

class ProfileAccountSuccess extends ProfileAccountState {}

class ProfileAccountFailure extends ProfileAccountState {
  final String error;

  const ProfileAccountFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileLoaded extends ProfileAccountState {
  final Map<String, dynamic> userData;

  const ProfileLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

// BLoC
class ProfileAccountBloc extends Bloc<ProfileAccountEvent, ProfileAccountState> {
  ProfileAccountBloc() : super(ProfileAccountInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileAccountState> emit) async {
    emit(ProfileAccountLoading());

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const ProfileAccountFailure("User not authenticated"));
        return;
      }

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        emit(const ProfileAccountFailure("User data not found"));
        return;
      }

      final userData = doc.data()!;
      emit(ProfileLoaded(userData));
    } catch (e) {
      emit(ProfileAccountFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<ProfileAccountState> emit) async {
    emit(ProfileAccountLoading());

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const ProfileAccountFailure("User not authenticated"));
        return;
      }

      final Map<String, dynamic> userData = {
        'firstName': event.firstName,
        'lastName': event.lastName,
        'userName': event.userName,
        'phone': event.phone,
      };

      if (event.email != null && event.email!.isNotEmpty) {
        userData['email'] = event.email;
      }

      if (event.gender != null) {
        userData['gender'] = event.gender;
      }

      if (event.dob != null) {
        userData['dob'] = Timestamp.fromDate(event.dob!);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(userData);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', event.firstName);
      await prefs.setString('lastName', event.lastName);
      await prefs.setString('username', event.userName);

      if (event.phone != null && event.phone!.isNotEmpty) {
        await prefs.setString('phone', event.phone!);
      }

      if (event.email != null && event.email!.isNotEmpty) {
        await prefs.setString('email', event.email!);
      }

      if (event.gender != null) {
        await prefs.setString('gender', event.gender!);
      }

      if (event.dob != null) {
        await prefs.setString('dob', _formatDate(event.dob!));
      }

      emit(ProfileAccountSuccess());
      add(FetchUserProfile()); // Fetch updated profile data
    } catch (e) {
      emit(ProfileAccountFailure(e.toString()));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}