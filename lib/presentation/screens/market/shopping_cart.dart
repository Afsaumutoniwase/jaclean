import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'cart_provider.dart';
import 'checkout_page.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      return _buildCartItem(
                        context: context,
                        image: item['image']!,
                        name: item['name']!,
                        price: item['price']!,
                      );
                    },
                  );
                },
              ),
            ),
            _buildCouponSection(),
            _buildTotalSection(context),
            _buildContinueButton(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCartItem({required BuildContext context, required String image, required String name, required String price}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset(image, width: 50, height: 50),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("1pcs"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Provider.of<CartProvider>(context, listen: false).removeItem(name);
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.local_offer, color: Colors.grey),
          Text("Add a coupon code", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double total = cart.cartItems.fold(0, (sum, item) => sum + double.parse(item['price']!.replaceAll('₦', '').replaceAll(',', '')));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        const Text("Order and get 34 points - Free shipping", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: cart.cartItems.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutPage()),
                );
              },
        child: const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.handyman), label: "Services"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Reviews"),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
      onTap: (index) {
        Navigator.pushReplacementNamed(context, [
          '/home',
          '/service',
          '/market',
          '/profile',
          '/reviews',
        ][index]);
      },
    );
  }
}