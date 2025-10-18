import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapBox extends StatefulWidget {
  final Position? currentPosition;
  const MapBox({super.key, this.currentPosition});

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(MapBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPosition != widget.currentPosition) {
      _updateMapLocation();
    }
  }

  void _updateMapLocation() {
    final position = widget.currentPosition;
    if (position != null) {
      final latitude = position.latitude;
      final longitude = position.longitude;

      if (!latitude.isNaN &&
          !latitude.isInfinite &&
          !longitude.isNaN &&
          !longitude.isInfinite) {
        final newCenter = LatLng(latitude, longitude);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(newCenter, 15.0);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const vancouverLat = 49.2827;
    const vancouverLng = -123.1207;

    LatLng mapCenter;
    Color markerColor;

    final position = widget.currentPosition;
    if (position != null) {
      final latitude = position.latitude;
      final longitude = position.longitude;

      if (latitude.isNaN ||
          latitude.isInfinite ||
          longitude.isNaN ||
          longitude.isInfinite) {
        mapCenter = const LatLng(vancouverLat, vancouverLng);
        markerColor = Colors.orange;
      } else {
        mapCenter = LatLng(latitude, longitude);
        markerColor = Colors.red;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(mapCenter, 15.0);
        });
      }
    } else {
      mapCenter = const LatLng(vancouverLat, vancouverLng);
      markerColor = Colors.blue;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: mapCenter, initialZoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.vanViewApp',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: mapCenter,
                child: Icon(Icons.location_pin, color: markerColor, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
