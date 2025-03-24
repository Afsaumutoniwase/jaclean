import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/blocs/services/service_bloc.dart';
import 'package:jaclean/blocs/services/user_bloc.dart';
import 'service_card.dart';
import 'service_detail_page.dart';
import 'recycling_centers_page.dart';
import 'package:jaclean/presentation/screens/market/add_product_page.dart';
import 'package:jaclean/presentation/screens/market/market_page.dart';
import 'package:jaclean/presentation/screens/market/shopping_cart.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServiceBloc()..add(LoadServices()),
        ),
        BlocProvider(
          create: (context) => UserBloc()..add(LoadUser()),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    if (state is ServiceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ServiceLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          final service = state.services[index];
                          return ServiceCard(
                            icon: service['icon'],
                            iconColor: service['iconColor'],
                            title: service['title'],
                            subtitle: service['subtitle'],
                            onTap: () => service['onTap'](context),
                          );
                        },
                      );
                    } else if (state is ServiceError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.black54)),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2));
                  } else if (state is UserLoaded) {
                    return Text(
                      state.userName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    );
                  } else if (state is UserError) {
                    return Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    );
                  } else {
                    return const Text(
                      'User',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    );
                  }
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black54),
            onPressed: () => _navigateToShoppingCartPage(context),
          ),
        ],
      ),
    );
  }

  void _navigateToShoppingCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingCartPage()),
    );
  }
}