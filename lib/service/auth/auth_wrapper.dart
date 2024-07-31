import 'package:digital_vault/screen/home/home_screen.dart';
import 'package:digital_vault/screen/login/login_screen.dart';
import 'package:digital_vault/screen/login_register/login_register_screen.dart';
import 'package:digital_vault/screen/navigation/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return NavigationBarView(); // User is logged in
        } else {
          return LoginRegisterScreen(); // User is not logged in
        }
      },
    );
  }
}