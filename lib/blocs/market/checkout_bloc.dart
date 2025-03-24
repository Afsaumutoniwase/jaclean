import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jaclean/blocs/market/cart_bloc.dart';
import 'dart:async';

// Events
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class LoadCartItems extends CheckoutEvent {}

class PlaceOrder extends CheckoutEvent {
  final String paymentMethod;
  final String shippingMethod;
  final String address;
  final double total;

  const PlaceOrder({
    required this.paymentMethod,
    required this.shippingMethod,
    required this.address,
    required this.total,
  });

  @override
  List<Object> get props => [paymentMethod, shippingMethod, address, total];
}

// States
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final List<Map<String, String>> cartItems;
  final double total;

  const CheckoutLoaded(this.cartItems, this.total);

  @override
  List<Object> get props => [cartItems, total];
}

class CheckoutSuccess extends CheckoutState {
  final double total;

  const CheckoutSuccess(this.total);

  @override
  List<Object> get props => [total];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartBloc cartBloc;
  late final StreamSubscription cartSubscription;

  CheckoutBloc({required this.cartBloc}) : super(CheckoutInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<PlaceOrder>(_onPlaceOrder);

    cartSubscription = cartBloc.stream.listen((state) {
      if (state is CartUpdated) {
        add(LoadCartItems());
      }
    });
  }

  void _onLoadCartItems(LoadCartItems event, Emitter<CheckoutState> emit) {
    if (cartBloc.state is CartUpdated) {
      final cartState = cartBloc.state as CartUpdated;
      double total = cartState.cartItems.fold(0, (sum, item) => sum + double.parse(item['price']!.replaceAll('₦', '').replaceAll(',', '')));
      emit(CheckoutLoaded(List.from(cartState.cartItems), total));
    }
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      // Simulate placing an order
      await Future.delayed(const Duration(seconds: 2));
      emit(CheckoutSuccess(event.total));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    cartSubscription.cancel();
    return super.close();
  }
}