import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'market/market_page.dart'; // Import the MarketPage
import 'market/add_product_page.dart'; // Import the AddProductPage
import 'map_page.dart'; // Import the MapPage
import 'package:latlong2/latlong.dart'; // Import LatLng
import 'services/recycling_centers_page.dart'; // Import the RecyclingCentersPage
import 'market/shopping_cart.dart'; // Import the ShoppingCartPage
import 'services/service_detail_page.dart'; // Import the ServiceDetailPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4), // Light green background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // Greeting & Cart Icon Section in One Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToShoppingCartPage(context), // Navigate to the shopping cart page
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black87,
                          size: 26,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Contributions Section
            _buildContributionsSection(),

            const SizedBox(height: 28),

            // Quick Actions
            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(context, "Buy or sell\nE-waste", Icons.shopping_cart_outlined, MarketPage()),
                _buildQuickAction(context, "Donate\nE-waste", Icons.volunteer_activism_outlined, const AddProductPage()),
                _buildQuickAction(context, "Schedule\nPickup", Icons.schedule, ServiceDetailPage(serviceType: 'recycling')),
                _buildQuickAction(context, "Find Recycling\nCenters", Icons.location_searching_outlined, RecyclingCentersPage()),
              ],
            ),

            const SizedBox(height: 28),

            // Recycling Center Section
            const Text("Recycling center", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("This is the closest location to you", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 10),
            _buildRecyclingCenter(context, "Remera E4 E-waste Center", "Kg st 101, Kigali Rwanda", LatLng(-1.944072, 30.089233)),

            const SizedBox(height: 28),

            // Recent Activities
            const Text("Recent Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRecentActivity("Your laptop product listed and active"),

            const SizedBox(height: 28),

            // Featured Blogs
            const Text("Featured blogs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  /// **Builds the Contributions Section**
  Widget _buildContributionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your contributions so far",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildContributionCard(
              title: "Waste recycled",
              value: "15 kg",
              description: "You add up to 0.1% of people saving the planet. Thank you!",
              icon: Icons.delete_outline,
              iconColor: Colors.green,
            ),
            _buildContributionCard(
              title: "CO₂ emission\nsaved",
              value: "0.4 kg",
              description: "",
              icon: Icons.factory_outlined,
              iconColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  /// **Creates a Contribution Card**
  Widget _buildContributionCard({
    required String title,
    required String value,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: iconColor,
                letterSpacing: -0.5,
              ),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// **Builds the Quick Action buttons**
  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Widget? destination) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 28, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Builds the Recycling Center section**
  Widget _buildRecyclingCenter(BuildContext context, String name, String address, LatLng location) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.green),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(address),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapPage(
                  name: name,
                  address: address,
                  location: location,
                ),
              ),
            );
          },
          child: const Text("View map", style: TextStyle(color: Colors.green)),
        ),
      ),
    );
  }

  /// **Builds the Recent Activity section**
  Widget _buildRecentActivity(String activity) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.notifications_none_outlined, color: Colors.green),
        title: Text(activity),
        trailing: TextButton(
          onPressed: () {},
          child: const Text("View product", style: TextStyle(color: Colors.green)),
        ),
      ),
    );
  }

  void _navigateToShoppingCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingCartPage()), // Navigate to the shopping cart page
    );
  }
}