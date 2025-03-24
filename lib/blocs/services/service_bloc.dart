import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jaclean/presentation/screens/services/service_detail_page.dart';
import 'package:jaclean/presentation/screens/market/market_page.dart';
import 'package:jaclean/presentation/screens/services/recycling_centers_page.dart';
import 'package:jaclean/presentation/screens/market/add_product_page.dart';
import 'package:jaclean/main.dart';

// Events
abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadServices extends ServiceEvent {}

// States
abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<Map<String, dynamic>> services;

  const ServiceLoaded(this.services);

  @override
  List<Object> get props => [services];
}

class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object> get props => [message];
}

void navigateToTab(BuildContext context, int tabIndex) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => MainScreen(initialIndex: tabIndex)),
    (route) => false,
  );
}

// BLoC
class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceInitial()) {
    on<LoadServices>(_onLoadServices);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      final services = [
        {
          'icon': Icons.recycling,
          'iconColor': Colors.green,
          'title': 'Recycling Pickup',
          'subtitle': 'Schedule collection of recyclables',
          'onTap':
              (BuildContext context) =>
                  _navigateToServiceDetail(context, 'recycling'),
        },
        {
          'icon': Icons.shopping_cart,
          'iconColor': Colors.amber,
          'title': 'Buy or Sell Product',
          'subtitle': 'Request waste pickup',
          'onTap': (BuildContext context) => navigateToTab(context, 2),
        },
        {
          'icon': Icons.card_giftcard,
          'iconColor': Colors.purple,
          'title': 'Donate items',
          'subtitle': 'Giveaway reusable goods',
          'onTap': (BuildContext context) => _navigateToAddProductPage(context),
        },
        {
          'icon': Icons.location_city,
          'iconColor': Colors.blue,
          'title': 'Recycling centers',
          'subtitle': 'Find our recycling centers',
          'onTap':
              (BuildContext context) =>
                  _navigateToRecyclingCentersPage(context),
        },
      ];
      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  void _navigateToServiceDetail(BuildContext context, String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(serviceType: serviceType),
      ),
    );
  }

  void _navigateToMarketPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarketPage()),
    );
  }

  void _navigateToRecyclingCentersPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecyclingCentersPage()),
    );
  }

  void _navigateToAddProductPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()),
    );
  }
}
