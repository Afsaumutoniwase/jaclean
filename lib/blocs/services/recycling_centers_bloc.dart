import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class RecyclingCentersEvent extends Equatable {
  const RecyclingCentersEvent();

  @override
  List<Object> get props => [];
}

class LoadRecyclingCenters extends RecyclingCentersEvent {}

// States
abstract class RecyclingCentersState extends Equatable {
  const RecyclingCentersState();

  @override
  List<Object> get props => [];
}

class RecyclingCentersInitial extends RecyclingCentersState {}

class RecyclingCentersLoading extends RecyclingCentersState {}

class RecyclingCentersLoaded extends RecyclingCentersState {
  final List<Map<String, String>> centers;

  const RecyclingCentersLoaded(this.centers);

  @override
  List<Object> get props => [centers];
}

class RecyclingCentersError extends RecyclingCentersState {
  final String message;

  const RecyclingCentersError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class RecyclingCentersBloc extends Bloc<RecyclingCentersEvent, RecyclingCentersState> {
  RecyclingCentersBloc() : super(RecyclingCentersInitial()) {
    on<LoadRecyclingCenters>(_onLoadRecyclingCenters);
  }

  Future<void> _onLoadRecyclingCenters(
    LoadRecyclingCenters event,
    Emitter<RecyclingCentersState> emit,
  ) async {
    emit(RecyclingCentersLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      final centers = [
        {'city': 'Abuja', 'address': 'Plot 1234, Garki Area 11, Abuja'},
        {'city': 'Port Harcourt', 'address': 'No. 56, Aba Road, Port Harcourt'},
        {'city': 'Lagos', 'address': '12, Adeola Odeku Street, Victoria Island, Lagos'},
        {'city': 'Ibadan', 'address': '15, Ring Road, Ibadan'},
      ];
      emit(RecyclingCentersLoaded(centers));
    } catch (e) {
      emit(RecyclingCentersError(e.toString()));
    }
  }
}