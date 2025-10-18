import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:van_view_app/core/services/auth_services.dart';
import 'package:van_view_app/themes/styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _checkAuthStatus() async {
    final isAuthenticated = await AuthService().checkAuthStatus();
    if (!mounted) return;

    if (isAuthenticated) {
      context.go('/main');
    } else {
      context.go('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: AppIconSizes.extraLarge,
              color: AppColors.onPrimary,
            ),
            const SizedBox(height: 20),
            Text(
              'Van View',
              style: AppTextStyles.headMain.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.onPrimary),
          ],
        ),
      ),
    );
  }
}
