import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_detail_page.dart';
import 'user_service.dart';
import 'service_card.dart';
import '../market/market_page.dart'; // Import the market page
import 'recycling_centers_page.dart'; // Import the recycling centers page
import '../market/add_product_page.dart'; // Import the add product page
import '../market/shopping_cart.dart'; // Import the shopping cart page

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ServiceCard(
                    icon: Icons.recycling,
                    iconColor: Colors.green,
                    title: 'Recycling Pickup',
                    subtitle: 'Schedule collection of recyclables',
                    onTap: () => _navigateToServiceDetail(context, 'recycling'),
                  ),
                  ServiceCard(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.amber,
                    title: 'Buy or Sell Product',
                    subtitle: 'Request waste pickup',
                    onTap: () => _navigateToMarketPage(context), // Navigate to the market page
                  ),
                  ServiceCard(
                    icon: Icons.card_giftcard,
                    iconColor: Colors.purple,
                    title: 'Donate items',
                    subtitle: 'Giveaway reusable goods',
                    onTap: () => _navigateToAddProductPage(context), // Navigate to the add product page
                  ),
                  ServiceCard(
                    icon: Icons.location_city,
                    iconColor: Colors.blue,
                    title: 'Recycling centers',
                    subtitle: 'Find our recycling centers',
                    onTap: () => _navigateToRecyclingCentersPage(context), // Navigate to the recycling centers page
                  ),
                ],
              ),
            ),
          ],
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
              FutureBuilder<String?>(
                future: UserService.getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  return Text(
                    snapshot.data ?? "User",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black54),
            onPressed: () => _navigateToShoppingCartPage(context), // Navigate to the shopping cart page
          ),
        ],
      ),
    );
  }

  void _navigateToServiceDetail(BuildContext context, String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceDetailPage(serviceType: serviceType)),
    );
  }

  void _navigateToMarketPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarketPage()), // Assuming MarketPage is the market page
    );
  }

  void _navigateToRecyclingCentersPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecyclingCentersPage()), // Navigate to the recycling centers page
    );
  }

  void _navigateToAddProductPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()), // Navigate to the add product page
    );
  }

  void _navigateToShoppingCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingCartPage()), // Navigate to the shopping cart page
    );
  }
}