import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DropPointMap extends StatelessWidget {
  final List<dynamic> dropPoints; // Data dari AppState

  const DropPointMap({super.key, required this.dropPoints});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(1.1275, 104.0417), // Koordinat awal
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: dropPoints.map((point) => Marker(
            point: LatLng(point.lat, point.lng),
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          )).toList(),
        ),
      ],
    );
  }
}