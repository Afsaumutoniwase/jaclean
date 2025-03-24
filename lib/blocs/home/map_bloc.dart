import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

// Events
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadMap extends MapEvent {
  final String name;
  final String address;
  final LatLng location;

  const LoadMap({
    required this.name,
    required this.address,
    required this.location,
  });

  @override
  List<Object> get props => [name, address, location];
}

// States
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final String name;
  final String address;
  final LatLng location;

  const MapLoaded({
    required this.name,
    required this.address,
    required this.location,
  });

  @override
  List<Object> get props => [name, address, location];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      // Simulate loading map data
      await Future.delayed(const Duration(seconds: 1));
      emit(MapLoaded(
        name: event.name,
        address: event.address,
        location: event.location,
      ));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }
}