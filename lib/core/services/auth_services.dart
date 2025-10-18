import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3001'; // 백엔드 URL

  // Google Sign-In 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId:
        '660549205762-iectkjs803ttc6uvk5v1steedijo4p2i.apps.googleusercontent.com',
  );
  // 토큰 저장
  Future<void> saveToken(String token) async {
    final preferenceInstance = await SharedPreferences.getInstance();
    await preferenceInstance.setString('auth_token', token);
  }

  // 토큰 가져오기
  Future<String?> getToken() async {
    final preferenceInstance = await SharedPreferences.getInstance();
    return preferenceInstance.getString('auth_token');
  }

  // 토큰 삭제
  Future<void> removeToken() async {
    final preferenceInstance = await SharedPreferences.getInstance();
    await preferenceInstance.remove('auth_token');
  }

  // 모바일 로그인
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/mobile-login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await saveToken(data['token']);
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  // 인증 상태 확인
  Future<bool> checkAuthStatus() async {
    try {
      // 먼저 Google Sign-In 자동 로그인 시도
      await _googleSignIn.signInSilently();

      // 구글 로그인 상태 확인
      if (isGoogleSignedIn) {
        debugPrint('Google 로그인 상태 유지됨: ${currentGoogleUser?.displayName}');
        return true;
      }

      // Google 로그인이 안되어 있으면 일반 토큰 확인
      final token = await getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/check-mobile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isAuthenticated'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      await removeToken();
      await _googleSignIn.signOut(); // Google Sign-In도 로그아웃
    } catch (e) {
      debugPrint('로그아웃 오류: $e');
    }
  }

  // Google Sign-In 초기화 및 자동 로그인 복원
  Future<void> initializeGoogleSignIn() async {
    try {
      debugPrint('Google Sign-In 초기화 중...');
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        debugPrint('Google 로그인 자동 복원 성공: ${account.displayName}');
      } else {
        debugPrint('저장된 Google 로그인 정보 없음');
      }
    } catch (e) {
      debugPrint('Google Sign-In 초기화 오류: $e');
    }
  }

  // Google Sign-In 로그인
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // 먼저 현재 사용자를 확인
      GoogleSignInAccount? account = _googleSignIn.currentUser;

      // 현재 사용자가 없으면 로그인 시도
      account ??= await _googleSignIn.signIn();

      if (account != null) {
        // 인증 정보 가져오기
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;

        debugPrint('Google User: ${account.displayName}');
        debugPrint('Email: ${account.email}');
        debugPrint('Access Token: ${googleAuth.accessToken}');
        debugPrint('ID Token: ${googleAuth.idToken}');

        // 백엔드로 토큰 전송
        if (googleAuth.idToken != null) {
          await _sendGoogleTokenToBackend(googleAuth.idToken);
        }

        return account;
      }
    } catch (error) {
      debugPrint('Google Sign-In 실패: $error');

      // 상세한 에러 정보 출력
      if (error is PlatformException) {
        debugPrint('Error code: ${error.code}');
        debugPrint('Error message: ${error.message}');
        debugPrint('Error details: ${error.details}');
      }
    }
    return null;
  }

  // Google Sign-In 로그아웃
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  // 현재 Google 로그인 상태 확인
  bool get isGoogleSignedIn => _googleSignIn.currentUser != null;

  // 현재 Google 사용자 정보 가져오기
  GoogleSignInAccount? get currentGoogleUser => _googleSignIn.currentUser;

  // 백엔드로 Google 토큰 전송 (선택적)
  Future<Map<String, dynamic>?> _sendGoogleTokenToBackend(
    String? idToken,
  ) async {
    if (idToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await saveToken(data['token']); // 백엔드에서 받은 토큰 저장
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Google token verification error: $e');
      return null;
    }
  }
}
