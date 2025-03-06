import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hello,", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10), // Adds slight spacing between "Hello," and "Simeon Azeh"
                    Text(
                      "Simeon Azeh",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),

                const Spacer(), // Pushes the cart icon to the right
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
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
                _buildQuickAction("Buy or sell\nE-waste", Icons.shopping_cart_outlined),
                _buildQuickAction("Donate\nE-waste", Icons.volunteer_activism_outlined),
                _buildQuickAction("Schedule\nPickup", Icons.schedule),
                _buildQuickAction("Find Recycling\nCenters", Icons.location_searching_outlined),
              ],
            ),

            const SizedBox(height: 28),

            // Recycling Center Section
            const Text("Recycling center", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("This is the closest location to you", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 10),
            _buildRecyclingCenter("Remera E4 E-waste Center", "Kg st 101, Kigali Rwanda"),

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
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 5),
                const Text("kg ▼", style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ],
        ),
      ),
    );
  }

  /// **Builds the Quick Action buttons**
  Widget _buildQuickAction(String label, IconData icon) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 28, color: Colors.green),
        ),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// **Builds the Recycling Center section**
  Widget _buildRecyclingCenter(String name, String address) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.green),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(address),
        trailing: TextButton(
          onPressed: () {},
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
}
