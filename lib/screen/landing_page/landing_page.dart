import 'package:digital_vault/screen/home/home_screen.dart';
import 'package:digital_vault/screen/login_register/login_register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if user is logged in and navigate accordingly
    if (user != null) {
      return HomeScreen(); // User is logged in, go to Home
    } else {
      return LoginRegisterScreen(); // User is not logged in, go to Login
    }
  }
}
