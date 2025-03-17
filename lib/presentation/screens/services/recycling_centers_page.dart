import 'package:flutter/material.dart';

class RecyclingCentersPage extends StatelessWidget {
  const RecyclingCentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Centers'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white, // Set the white background for the entire page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png', // Ensure you have the logo.png in the assets folder
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Our Recycling Centers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCenterCard('Abuja', 'Plot 1234, Garki Area 11, Abuja'),
                  const SizedBox(height: 16),
                  _buildCenterCard('Port Harcourt', 'No. 56, Aba Road, Port Harcourt'),
                  const SizedBox(height: 16),
                  _buildCenterCard('Lagos', '12, Adeola Odeku Street, Victoria Island, Lagos'),
                  const SizedBox(height: 16),
                  _buildCenterCard('Ibadan', '15, Ring Road, Ibadan'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCard(String city, String address) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.location_on, color: Colors.white),
        ),
        title: Text(city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(address, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}