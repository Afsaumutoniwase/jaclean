import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends CartEvent {
  final String image;
  final String name;
  final String price;

  const AddItem({required this.image, required this.name, required this.price});

  @override
  List<Object> get props => [image, name, price];
}

class RemoveItem extends CartEvent {
  final String name;

  const RemoveItem({required this.name});

  @override
  List<Object> get props => [name];
}

class ClearCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<Map<String, String>> cartItems;

  const CartUpdated(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final List<Map<String, String>> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ClearCart>(_onClearCart);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    _cartItems.add({'image': event.image, 'name': event.name, 'price': event.price});
    emit(CartUpdated(List.from(_cartItems)));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    final index = _cartItems.indexWhere((item) => item['name'] == event.name);
    if (index != -1) {
      _cartItems.removeAt(index);
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _cartItems.clear();
    emit(CartUpdated(List.from(_cartItems)));
  }
}