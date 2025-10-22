import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:van_view_app/core/routes/app_routes.dart';
import 'package:van_view_app/core/services/auth_services.dart';
import 'package:van_view_app/themes/app_theme_extension.dart';
import 'package:van_view_app/themes/styles.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google Sign-In 초기화
  await AuthService().initializeGoogleSignIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoute.router,
      title: 'Van-view App',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: AppTextStyles.headline,
          bodyMedium: AppTextStyles.body,
          bodySmall: AppTextStyles.caption,
        ),
        extensions: <ThemeExtension<AppThemeExtension>>[
          const AppThemeExtension(
            paddings: AppPaddings(),
            textStyles: AppTextStyles(),
            colors: AppColors(),
            iconSizes: AppIconSizes(),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
