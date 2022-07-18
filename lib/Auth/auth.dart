import 'package:flutter/cupertino.dart';
import 'package:food_nerve/Auth/login_page.dart';
import 'package:food_nerve/Auth/register_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(toggleView: toggleView)
      : RegisterPage(toggleView: toggleView);
}
