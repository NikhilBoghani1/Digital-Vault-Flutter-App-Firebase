import 'package:digital_vault/const/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';

  String formatAccountNumber(String accountNumber) {
    return accountNumber
        .replaceAllMapped(RegExp(r'.{3}'), (match) => "${match.group(0)} ")
        .trim();
  }

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

  //------------------------------------------------
  bool _notificationsEnabled = false;

  void _showNotificationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Notification Settings"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enable notifications?"),
              SizedBox(height: 10),
              CupertinoSwitch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled =
                        value; // Update the notification state
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can add more functionality here for the OK action if needed
              },
            ),
          ],
        );
      },
    );
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Constants myConstants = Constants();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(email.isNotEmpty ? "Hey, $email" : "Loading..."),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         await _auth.signOut();
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //             builder: (_) => LoginRegisterScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            width: 46,
                            height: 46,
                            "assets/images/user_profile.png",
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: CupertinoColors.systemRed.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hi, $name",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 16,
                                color: CupertinoColors.inactiveGray,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Good Morning",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () => _showNotificationDialog(context),
                        icon: Image.asset(
                          color: Colors.black,
                          width: 22,
                          height: 22,
                          "assets/images/bell.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28),
                width: 350,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: _buildBankAccountList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankAccountList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('bankAccounts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Shimmer.fromColors(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 28),
              width: 350,
              height: 160,
            ),
            highlightColor: Colors.grey,
            baseColor: Colors.black12,
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Text("No bank accounts found.");
        }

        // Get the first bank account document
        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 25, bottom: 11),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bank: ${data['bankName'] ?? 'Unknown'}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: myConstants.RobotoR,
                    ),
                  ),
                  SizedBox(height: 90),
                  Text(
                    // "${data['accountNumber'] ?? 'Unknown'}",
                    formatAccountNumber(data['accountNumber'] ?? 'Unknown'),
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
