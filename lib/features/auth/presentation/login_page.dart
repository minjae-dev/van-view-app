import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:van_view_app/components/app_form.dart';
import 'package:van_view_app/core/services/auth_services.dart';
import 'package:van_view_app/themes/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isGoogleLoading = false;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final isLoggedIn = await AuthService().login(email, password);
    if (!mounted) return;
    if (isLoggedIn != null) {
      context.go('/main');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')));
    }
  }

  Future<void> _googleLogin() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final authService = AuthService();
      final account = await authService.signInWithGoogle();

      if (!mounted) return;

      if (account != null) {
        // Google 로그인 성공
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${account.displayName}님, 환영합니다!')),
        );
        context.go('/main');
      } else {
        // Google 로그인 실패 또는 취소
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Google 로그인에 실패했습니다.')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google 로그인 오류: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: AppIconSizes.large,
              color: Theme.of(context).primaryColor,
            ),
            AppForm(
              firstInputController: _emailController,
              secondInputController: _passwordController,
              onSubmit: _login,
              buttonText: '로그인',
              firstInputIcon: const Icon(Icons.email),
              secondInputIcon: const Icon(Icons.lock),
              firstInputLabel: '이메일',
              secondInputLabel: '비밀번호',
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGoogleLoading ? null : _googleLogin,
                icon: _isGoogleLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/google.png',
                        width: 24,
                        height: 24,
                      ),
                label: Text(_isGoogleLoading ? '로그인 중...' : '구글 로그인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            TextButton(onPressed: () {}, child: const Text('계정이 없으신가요? 회원가입')),
          ],
        ),
      ),
    );
  }
}
