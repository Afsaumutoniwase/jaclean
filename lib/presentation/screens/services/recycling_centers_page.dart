import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/blocs/services/recycling_centers_bloc.dart';

class RecyclingCentersPage extends StatelessWidget {
  const RecyclingCentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecyclingCentersBloc()..add(LoadRecyclingCenters()),
      child: Scaffold(
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
                child: BlocBuilder<RecyclingCentersBloc, RecyclingCentersState>(
                  builder: (context, state) {
                    if (state is RecyclingCentersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RecyclingCentersLoaded) {
                      return ListView.builder(
                        itemCount: state.centers.length,
                        itemBuilder: (context, index) {
                          final center = state.centers[index];
                          return Column(
                            children: [
                              _buildCenterCard(center['city']!, center['address']!),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      );
                    } else if (state is RecyclingCentersError) {
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

  Widget _buildCenterCard(String city, String address) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: const Icon(Icons.location_on, color: Colors.white),
        ),
        title: Text(city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(address, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}