import 'package:flutter/material.dart';
import 'package:van_view_app/core/services/auth_services.dart';

class AppNav extends StatefulWidget implements PreferredSizeWidget {
  final Text title;
  const AppNav({super.key, required this.title});

  @override
  State<AppNav> createState() => _AppNavState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppNavState extends State<AppNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            Navigator.of(context).pushNamed('/login');
            return await AuthService().logout();
          },
        ),
        title: Text(
          widget.title.data!,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge, // TextTheme의 headlineLarge 사용
        ),
      ),
    );
  }
}
