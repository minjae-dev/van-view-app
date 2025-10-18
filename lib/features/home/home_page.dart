import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:van_view_app/components/app_nav.dart';
import 'package:van_view_app/components/map_box.dart';
import 'package:van_view_app/core/services/location_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String _locationStatus = '위치 정보 확인 중...';

  @override
  void initState() {
    super.initState();
    LocationService().getCurrentLocation(
      context,
      setState,
      mounted,
      (position) {
        setState(() {
          _currentPosition = position;
        });
      },
      (status) {
        setState(() {
          _locationStatus = status;
        });
      },
    );
    debugPrint('현재 위치: $_currentPosition');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNav(title: Text('Van View')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: MapBox(currentPosition: _currentPosition),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
