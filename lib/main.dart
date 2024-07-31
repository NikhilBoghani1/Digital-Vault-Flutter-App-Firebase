import 'package:digital_vault/service/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAmAxxqvGyHG3GyGzapY1WcgDKNuiNa06c",
      appId: "1:131874061369:android:0136a1d2a7cd41256fa1e8",
      messagingSenderId: "131874061369",
      projectId: "digital-vault-7ef77",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // Entry point for Login/Register
    );
  }
}
