import 'package:digital_vault/screen/login_register/login_register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDocument =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDocument.exists) {
          setState(() {
            name = userDocument['name'] ?? 'No name found';
            email = userDocument['email'] ?? 'No email found';
          });
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email.isNotEmpty ? "Hey, $email" : "Loading..."),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginRegisterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          name.isNotEmpty ? 'Welcome, $name!' : 'Loading...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
