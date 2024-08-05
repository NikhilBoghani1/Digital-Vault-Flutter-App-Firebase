import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/view_credit_card/view_credit_card_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

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
    _fetchBankAccounts();
    _fetchcreditCard();
    _setupDebitCardListener();
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

  List<Map<String, dynamic>> _bankAccounts = [];

  // Method to fetch bank account data from Firestore
  Future<void> _fetchBankAccounts() async {
    _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('bankAccounts')
        .snapshots() // Use snapshots for real-time updates
        .listen((snapshot) {
      List<Map<String, dynamic>> bankAccountList = [];

      // Populate the list with the current documents
      for (var doc in snapshot.docs) {
        bankAccountList.add(doc.data() as Map<String, dynamic>);
      }

      // Update the state with the new list of debit cards
      setState(() {
        _bankAccounts = bankAccountList; // Update variable with new data
      });

      // Print the count of debit cards fetched
      print("Number of debit cards: ${_bankAccounts.length}");
    }, onError: (e) {
      print("Error listening for debit card updates: $e");
    });
  }

  // Method to fetch Credit Card data from Firestore

  List<Map<String, dynamic>> _creditCard = [];

  Future<void> _fetchcreditCard() async {
    // Listen for changes in the debitDetails collection
    _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('credit_cards')
        .snapshots() // Use snapshots for real-time updates
        .listen((snapshot) {
      List<Map<String, dynamic>> credidCardList = [];

      // Populate the list with the current documents
      for (var doc in snapshot.docs) {
        credidCardList.add(doc.data() as Map<String, dynamic>);
      }

      // Update the state with the new list of debit cards
      setState(() {
        _creditCard = credidCardList; // Update variable with new data
      });

      // Print the count of debit cards fetched
      print("Number of debit cards: ${_creditCard.length}");
    }, onError: (e) {
      print("Error listening for debit card updates: $e");
    });
  }

  // Method to fetch Credit Card data from Firestore

  List<Map<String, dynamic>> _debitCard = [];

  void _setupDebitCardListener() {
    // Listen for changes in the debitDetails collection
    _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('debit_cards')
        .snapshots() // Use snapshots for real-time updates
        .listen((snapshot) {
      List<Map<String, dynamic>> debitCardList = [];

      // Populate the list with the current documents
      for (var doc in snapshot.docs) {
        debitCardList.add(doc.data() as Map<String, dynamic>);
      }

      // Update the state with the new list of debit cards
      setState(() {
        _debitCard = debitCardList; // Update variable with new data
      });

      // Print the count of debit cards fetched
      print("Number of debit cards: ${_debitCard.length}");
    }, onError: (e) {
      print("Error listening for debit card updates: $e");
    });
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Constants myConstants = Constants();

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 360,
              child: Stack(
                children: [
                  Container(
                    width: 400,
                    height: 210,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Wel come, $name",
                          style: TextStyle(
                            fontFamily: myConstants.RobotoR,
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.fingerprint_rounded),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 350,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CupertinoColors.systemBlue,
                        ),
                        padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.5),
                                  child: Icon(CupertinoIcons.umbrella),
                                ),
                                Icon(
                                  CupertinoIcons.creditcard,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "$name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: myConstants.RobotoR,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "$email",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: myConstants.RobotoR,
                              ),
                            ),
                            SizedBox(height: 25),
                            Text(
                              "****  ****  ****  1004",
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                        width: 270,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.systemYellow.withOpacity(0.4),
                        ),
                        child: Text(
                          "Totle Bank Account",
                          style: TextStyle(
                            fontFamily: myConstants.RobotoM,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.systemYellow.withOpacity(0.5),
                        ),
                        child: Text(
                          "${_bankAccounts.length}",
                          style: TextStyle(
                            fontFamily: myConstants.PoppinsSB,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 18),
                          width: 270,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: CupertinoColors.activeBlue.withOpacity(0.4),
                          ),
                          child: Text(
                            "Totle Credit Card",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoM,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.activeBlue.withOpacity(0.5),
                        ),
                        child: Text(
                          "${_creditCard.length}",
                          style: TextStyle(
                            fontFamily: myConstants.PoppinsSB,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                        width: 270,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.activeGreen.withOpacity(0.4),
                        ),
                        child: Text(
                          "Totle Debit Card",
                          style: TextStyle(
                            fontFamily: myConstants.RobotoM,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.activeGreen.withOpacity(0.5),
                        ),
                        child: Text(
                          "${_debitCard.length}",
                          style: TextStyle(
                            fontFamily: myConstants.PoppinsSB,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
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
        int bankAccountCount = snapshot.data!.docs.length;
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
