import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'shopping_cart.dart';
import 'package:jaclean/blocs/market/cart_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String oldPrice;

  const ProductDetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0), // Add space from the top and left edge
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0), // Add space from the top and right edge
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(image, height: 250, width: 250),
                ),
              ),
              const SizedBox(height: 16),
              const Text("used", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(
                    oldPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("25%", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.recycling, color: Colors.green),
                  SizedBox(width: 8),
                  Text("E-waste", style: TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Free shipping", style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "This is the description for this product and why it is being sold",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const Text("Similar products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSimilarProducts(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomSection(context),
    );
  }

  Widget _buildSimilarProducts() {
    return SizedBox(
      height: 270,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildProductCard("assets/images/laptop1.png", "Dell Optiplex", "₦79,000"),
          _buildProductCard("assets/images/clothes2.png", "Clothes Item", "₦5,000"),
          _buildProductCard("assets/images/pot.jpeg", "Big Pot", "₦10,000"),
        ],
      ),
    );
  }

  Widget _buildProductCard(String image, String name, String price) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8), // Add space above the icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Limited',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final isInCart = state is CartUpdated && state.cartItems.any((item) => item['name'] == name);
                  return IconButton(
                    icon: Icon(
                      isInCart ? Icons.favorite : Icons.favorite_border,
                      color: isInCart ? Colors.red : Colors.green,
                    ),
                    onPressed: () {
                      if (isInCart) {
                        context.read<CartBloc>().add(RemoveItem(name: name));
                      } else {
                        context.read<CartBloc>().add(AddItem(image: image, name: name, price: price));
                      }
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8), // Add space between the icons and the image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, fit: BoxFit.cover, height: 120, width: double.infinity),
          ),
          const SizedBox(height: 8),
          Text(
            'refurbished',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        children: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final isInCart = state is CartUpdated && state.cartItems.any((item) => item['name'] == name);
              return IconButton(
                icon: Icon(
                  isInCart ? Icons.favorite : Icons.favorite_border,
                  color: isInCart ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  if (isInCart) {
                    context.read<CartBloc>().add(RemoveItem(name: name));
                  } else {
                    context.read<CartBloc>().add(AddItem(image: image, name: name, price: price));
                  }
                },
              );
            },
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.read<CartBloc>().add(AddItem(image: image, name: name, price: price));
              },
              child: const Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}