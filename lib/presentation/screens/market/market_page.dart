import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shopping_cart.dart';
import 'product_detail_page.dart';
import 'add_product_page.dart';
import '../../utils/bottom_nav.dart'; // Import the correct file where MainBottomNavBar is defined

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String selectedCategory = "E-Waste";

  Future<String?> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data()?['userName'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add space above the "Hello" part
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello,",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 4),
              FutureBuilder<String?>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  return Text(
                    snapshot.data ?? "User",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 16),
              _buildScrollableCategorySection(),
              const SizedBox(height: 16),
              _buildScrollableProductGrid(context),
              const SizedBox(height: 20),
              const Text(
                "Charity Donations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 16),
              _buildScrollableCharityGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // bottomNavigationBar: const MainBottomNavBar(), // Use the bottom navigation bar from main.dart
    );
  }

  Widget _buildCategoryButton(String category, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Search items...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildScrollableCategorySection() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryButton("All", isSelected: selectedCategory == "All"),
          _buildCategoryButton("E-Waste", isSelected: selectedCategory == "E-Waste"),
          _buildCategoryButton("Clothing", isSelected: selectedCategory == "Clothing"),
          _buildCategoryButton("Appliances", isSelected: selectedCategory == "Appliances"),
          _buildCategoryButton("Metal Waste", isSelected: selectedCategory == "Metal Waste"),
          _buildCategoryButton("Construction", isSelected: selectedCategory == "Construction"),
        ],
      ),
    );
  }

  Widget _buildScrollableProductGrid(BuildContext context) {
    List<Widget> items;
    if (selectedCategory == "All") {
      items = [
        _buildMarketItem(context, "Dell Optiplex", "₦79,000", "assets/images/laptop1.png"),
        _buildMarketItem(context, "Google Pixel 9pro XL", "₦189,000", "assets/images/pixel9.png"),
        _buildMarketItem(context, "JBL Home", "₦69,000", "assets/images/jbl_home.png"),
        _buildMarketItem(context, "Clothing Item 1", "₦5,000", "assets/images/clothes1.png"),
      ];
    } else if (selectedCategory == "E-Waste") {
      items = [
        _buildMarketItem(context, "Dell Optiplex", "₦79,000", "assets/images/laptop1.png"),
        _buildMarketItem(context, "Google Pixel 9pro XL", "₦189,000", "assets/images/pixel9.png"),
        _buildMarketItem(context, "JBL Home", "₦69,000", "assets/images/jbl_home.png"),
      ];
    } else if (selectedCategory == "Clothing") {
      items = [
        _buildMarketItem(context, "Clothing Item 1", "₦5,000", "assets/images/clothes1.png"),
        _buildMarketItem(context, "Clothing Item 2", "₦7,000", "assets/images/clothes2.png"),
        _buildMarketItem(context, "Clothing Item 3", "₦6,000", "assets/images/clothes3.jpeg"),
        _buildMarketItem(context, "Clothing Item 4", "₦8,000", "assets/images/clothes4.jpeg"),
      ];
    } else if (selectedCategory == "Appliances") {
      items = [
        _buildMarketItem(context, "House Appliance Item 1", "₦15,000", "assets/images/pot.jpeg"),
        _buildMarketItem(context, "House Appliance 2", "₦18,000", "assets/images/vase1.jpeg"),
        _buildMarketItem(context, "House Appliance 3", "₦25,000", "assets/images/table.jpeg"),
        _buildMarketItem(context, "House Appliance 4", "₦20,000", "assets/images/gas.jpeg"),
      ];
    } else if (selectedCategory == "Metal Waste") {
      items = [
        _buildMarketItem(context, "Metal Waste Item 1", "₦10,000", "assets/images/metal1.jpeg"),
        _buildMarketItem(context, "Metal Waste Item 2", "₦12,000", "assets/images/metal2.jpeg"),
        _buildMarketItem(context, "Metal Waste Item 3", "₦15,000", "assets/images/metal3.jpeg"),
        _buildMarketItem(context, "Metal Waste Item 4", "₦20,000", "assets/images/metal4.jpeg"),
      ];
    } else if (selectedCategory == "Construction") {
      items = [
        _buildMarketItem(context, "Construction Item 1", "₦50,000", "assets/images/construction1.jpeg"),
        _buildMarketItem(context, "Construction Item 2", "₦70,000", "assets/images/construction2.jpeg"),
        _buildMarketItem(context, "Construction Item 3", "₦60,000", "assets/images/construction3.jpeg"),
        _buildMarketItem(context, "Construction Item 4", "₦80,000", "assets/images/construction4.jpeg"),
      ];
    } else {
      items = [];
    }

    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  Widget _buildScrollableCharityGrid() {
    return SizedBox(
      height: 270,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMarketItem(null, "Dell Optiplex", "FREE", "assets/images/laptop1.png"),
          _buildMarketItem(null, "Clothes", "FREE", "assets/images/clothes1.png"),
          _buildMarketItem(null, "Big Pot", "FREE", "assets/images/pot.jpeg"),
        ],
      ),
    );
  }

  Widget _buildMarketItem(BuildContext? context, String name, String price, String image) {
    return GestureDetector(
      onTap: context != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    image: image,
                    name: name,
                    price: price,
                    oldPrice: price == "FREE" ? "" : "₦100,000",
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: 160,
        height: 200,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                const Icon(Icons.favorite_border, color: Colors.green),
              ],
            ),
            const SizedBox(height: 8),
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
      ),
    );
  }
}