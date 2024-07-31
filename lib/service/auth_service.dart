// auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User?> registerWithEmailAndPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email.trim(),
  //       password: password.trim(),
  //     );
  //     return userCredential.user; // Return the user
  //   } catch (e) {
  //     print(e);
  //     return null; // Return null if registration failed
  //   }
  // }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e); // Print error to console for debugging
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      // Handle error appropriately for your application
      print("Login error: $e");
      return null; // Return null in case of failure
    }
  }

}