import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:van_view_app/components/app_form.dart';
import 'package:van_view_app/components/button/my_button.dart';
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

  final _thirdInputController = TextEditingController();
  final _fourthInputController = TextEditingController();

  bool _isSignupSelected = false;
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

  Future<void> _signup() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _thirdInputController.text;

    final isSignedUp = await AuthService().signup(email, password, name);
    if (!mounted) return;
    if (isSignedUp != null) {
      context.go('/main');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.')));
    }
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
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: _isSignupSelected ? 400 : 280,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignupSelected = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: _isSignupSelected
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: _isSignupSelected
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          if (!_isSignupSelected)
                            AppForm(
                              firstInputController: _emailController,
                              secondInputController: _passwordController,
                              firstInputIcon: const Icon(Icons.email),
                              secondInputIcon: const Icon(Icons.lock),
                              firstInputLabel: '이메일',
                              secondInputLabel: '비밀번호',
                              thirdInputLabel: '비밀번호 확인',
                              fourthInputLabel: '이름',
                              isMoreThanTwoInput: _isSignupSelected,
                              thirdInputController: _thirdInputController,
                              fourthInputController: _fourthInputController,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignupSelected = true;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: _isSignupSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _isSignupSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                          if (_isSignupSelected)
                            AppForm(
                              firstInputController: _emailController,
                              secondInputController: _passwordController,
                              firstInputIcon: const Icon(Icons.account_circle),
                              secondInputIcon: const Icon(Icons.lock),
                              firstInputLabel: '이메일',
                              secondInputLabel: '비밀번호',
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyButton(
              image: Icon(Icons.email, size: 24, color: Colors.white),
              text: Text('Login with Email', style: AppTextStyles.button),
              color: Theme.of(context).colorScheme.primary,
              radius: 4.0,
              onPressed: () => _isSignupSelected ? _signup() : _login(),
            ),
            _buildOAuthButton(),
            TextButton(onPressed: () {}, child: const Text('계정이 없으신가요? 회원가입')),
          ],
        ),
      ),
    );
  }

  Widget _buildOAuthButton() {
    return ButtonTheme(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyButton(
            image: Image.asset('assets/images/glogo.png'),
            text: Text('Login With Google', style: AppTextStyles.button),
            color: Theme.of(context).colorScheme.onPrimary,
            radius: 4.0,
            onPressed: _isGoogleLoading ? null : () => _googleLogin(),
          ),
          SizedBox(height: 10),
          MyButton(
            image: Image.asset('assets/images/flogo.png'),
            text: Text('Login With Facebook', style: AppTextStyles.button),
            color: Color(0xFF1877F2),
            radius: 4.0,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook 로그인은 아직 지원되지 않습니다.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
