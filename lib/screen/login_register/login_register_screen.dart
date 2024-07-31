import 'package:digital_vault/screen/login/login_screen.dart';
import 'package:digital_vault/screen/register/register_screen.dart';
import 'package:flutter/material.dart';

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen; // Toggle between login and register
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginScreen
        ? LoginScreen(onSwitch: toggleScreens)
        : RegisterScreen(onSwitch: toggleScreens);
  }
}
