import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:jaclean/blocs/home/map_bloc.dart';

class MapPage extends StatelessWidget {
  final String name;
  final String address;
  final LatLng location;

  const MapPage({
    Key? key,
    required this.name,
    required this.address,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc()..add(LoadMap(name: name, address: address, location: location)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapLoaded) {
              return FlutterMap(
                options: MapOptions(
                  initialCenter: state.location,
                  // zoom: 14.0,
                  onTap: (tapPosition, point) {
                    // Handle the tap event here
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: state.location,
                        width: 80.0,
                        height: 80.0,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is MapError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Something went wrong!'));
          },
        ),
      ),
    );
  }
}