import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ServiceDetailEvent extends Equatable {
  const ServiceDetailEvent();

  @override
  List<Object> get props => [];
}

class SchedulePickup extends ServiceDetailEvent {
  final String serviceType;
  final double quantity;
  final DateTime date;
  final String time;
  final String wasteType;
  final String location;
  final String paymentOption;
  final double cost;

  const SchedulePickup({
    required this.serviceType,
    required this.quantity,
    required this.date,
    required this.time,
    required this.wasteType,
    required this.location,
    required this.paymentOption,
    required this.cost,
  });

  @override
  List<Object> get props => [serviceType, quantity, date, time, wasteType, location, paymentOption, cost];
}

// States
abstract class ServiceDetailState extends Equatable {
  const ServiceDetailState();

  @override
  List<Object> get props => [];
}

class ServiceDetailInitial extends ServiceDetailState {}

class ServiceDetailLoading extends ServiceDetailState {}

class ServiceDetailSuccess extends ServiceDetailState {}

class ServiceDetailError extends ServiceDetailState {
  final String message;

  const ServiceDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  ServiceDetailBloc() : super(ServiceDetailInitial()) {
    on<SchedulePickup>(_onSchedulePickup);
  }

  Future<void> _onSchedulePickup(
    SchedulePickup event,
    Emitter<ServiceDetailState> emit,
  ) async {
    emit(ServiceDetailLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      emit(ServiceDetailSuccess());
    } catch (e) {
      emit(ServiceDetailError(e.toString()));
    }
  }
}