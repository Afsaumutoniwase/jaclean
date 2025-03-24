import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProducts extends MarketEvent {}

class AddProduct extends MarketEvent {
  final Map<String, dynamic> product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];
}

// States
abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<Map<String, dynamic>> myProductsForSale;
  final List<Map<String, dynamic>> myCharityDonations;

  const MarketLoaded(this.myProductsForSale, this.myCharityDonations);

  @override
  List<Object> get props => [myProductsForSale, myCharityDonations];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketInitial()) {
    on<LoadUserProducts>(_onLoadUserProducts);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onLoadUserProducts(LoadUserProducts event, Emitter<MarketState> emit) async {
    emit(MarketLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userProductsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('products')
            .get();

        final userProducts = userProductsSnapshot.docs.map((doc) => doc.data()).toList();

        final myProductsForSale = userProducts
            .where((product) => product['section'] == 'Sell')
            .map((product) => {
                  'name': product['name'],
                  'price': product['price'],
                  'image': product['image'],
                })
            .toList();

        final myCharityDonations = userProducts
            .where((product) => product['section'] == 'Charity Donation')
            .map((product) => {
                  'name': product['name'],
                  'price': product['price'],
                  'image': product['image'],
                })
            .toList();

        emit(MarketLoaded(myProductsForSale, myCharityDonations));
      } else {
        emit(const MarketError("User not logged in"));
      }
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<MarketState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('products')
            .add(event.product);

        add(LoadUserProducts());
      } else {
        emit(const MarketError("User not logged in"));
      }
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }
}