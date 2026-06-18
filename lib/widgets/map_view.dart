import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DropPointMap extends StatelessWidget {
  final List<dynamic> dropPoints; // Data dari AppState
  final LatLng selectedPoint;
  final LatLng destination;

  const DropPointMap({
    super.key,
    required this.dropPoints,
    required this.selectedPoint, // Pastikan namanya 'selectedPoint'
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: selectedPoint,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName:
              'com.example.daurin_app', // PENTING agar tidak 403
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [LatLng(3.5800, 98.6700), selectedPoint, destination], // Rute
              color: Colors.green,
              strokeWidth: 5.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: dropPoints.map((point) {
            final double latitude = (point['lat'] ?? 1.1275).toDouble();
            final double longitude = (point['lng'] ?? 104.0417).toDouble();

            return Marker(
              point: LatLng(latitude, longitude),
              child:
                  const Icon(Icons.location_pin, color: Colors.red, size: 40),
            );
          }).toList(),
        ),
      ],
    );
  }
}
