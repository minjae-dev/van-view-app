import 'package:go_router/go_router.dart';
import 'package:van_view_app/features/auth/presentation/login_page.dart';
import 'package:van_view_app/features/home/home_page.dart';
import 'package:van_view_app/features/splash/presentation/splash_page.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/main', builder: (context, state) => const HomePage()),
    ],
  );
}
