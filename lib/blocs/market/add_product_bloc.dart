import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class SubmitProductDetails extends AddProductEvent {
  final String name;
  final String description;
  final String price;
  final String imagePath;
  final String section;
  final String itemState;

  const SubmitProductDetails({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.section,
    required this.itemState,
  });

  @override
  List<Object> get props => [name, description, price, imagePath, section, itemState];
}

// States
abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;

  const AddProductError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductInitial()) {
    on<SubmitProductDetails>(_onSubmitProductDetails);
  }

  Future<void> _onSubmitProductDetails(SubmitProductDetails event, Emitter<AddProductState> emit) async {
    emit(AddProductLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }
}