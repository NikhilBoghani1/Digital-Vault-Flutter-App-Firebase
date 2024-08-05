import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/tab_bar_view/bank_view.dart';
import 'package:digital_vault/screen/tab_bar_view/credit_card_view.dart';
import 'package:digital_vault/screen/tab_bar_view/debit_card_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = 'Loading...';
  String email = '';

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
          setState(() {
            name = 'User document does not exist.';
          });
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  void initState() {
    super.initState(); // Moved super.initState first
    _fetchUserName();
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: myConstants.RobotoR),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 0),
            CircleAvatar(
              radius: 40,
              child: Icon(CupertinoIcons.profile_circled, size: 40),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontFamily: myConstants.RobotoR,
                fontSize: 19,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              // Use Expanded here
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bank's",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Credit Card's",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Debit Card's",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      // Ensure that TabBarView takes the rest of the available space.
                      child: TabBarView(
                        children: [
                          BankView(),
                          CreditCardView(),
                          DebitCardView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
