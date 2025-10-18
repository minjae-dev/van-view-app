import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // 현재 위치 권한 상태 확인
  Future<LocationPermission> getLocationPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  // 위치 권한 요청
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // 위치 서비스 활성화 확인
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // 현재 위치 가져오기
  // 현재 위치 가져오기 (상태 관리 및 UI 반영 포함)
  Future<void> getCurrentLocation(
    BuildContext context,
    void Function(void Function()) setState,
    bool mounted,
    Function(Position) onPositionUpdate,
    Function(String) onStatusUpdate,
  ) async {
    try {
      debugPrint('현재 플랫폼: ${Platform.operatingSystem}');

      // 1. 위치 서비스가 활성화 여부
      bool serviceEnabled = await isLocationServiceEnabled();
      debugPrint('위치 서비스 활성화 여부: $serviceEnabled');

      if (!serviceEnabled) {
        onStatusUpdate('위치 서비스가 비활성화.');
        debugPrint('Location services are disabled.');
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('설정에서 위치 서비스를 활성화해주세요.')),
          );
        }
        return;
      }

      // 2. 현재 위치 권한 상태 확인
      LocationPermission permission = await getLocationPermissionStatus();
      debugPrint('현재 권한 상태: $permission');

      // 3. 권한이 거부된 경우 요청
      if (permission == LocationPermission.denied) {
        onStatusUpdate('위치 권한을 요청 중');
        permission = await requestLocationPermission();
        debugPrint('권한 요청 후 상태: $permission');

        if (permission == LocationPermission.denied) {
          onStatusUpdate('위치 권한이 거부되었습니다.');
          debugPrint('Location permissions are denied');
          return;
        }
      }

      // 4. 권한이 영구적으로 거부된 경우
      if (permission == LocationPermission.deniedForever) {
        onStatusUpdate('위치 권한이 영구적으로 거부되었습니다.\n설정에서 권한을 허용해주세요.');
        debugPrint('Location permissions are permanently denied.');
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('설정 > 개인정보 보호 및 보안 > 위치 서비스에서 앱 권한을 허용해주세요.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // 5. 위치 정보 가져오기
      onStatusUpdate('현재 위치를 가져오는 중');

      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      onPositionUpdate(position);
      onStatusUpdate(
        '위치: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
      );

      debugPrint('현재 위치: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      onStatusUpdate('위치 정보 오류: $e');
      debugPrint('위치 정보 가져오기 오류: $e');
    }
  }
}
