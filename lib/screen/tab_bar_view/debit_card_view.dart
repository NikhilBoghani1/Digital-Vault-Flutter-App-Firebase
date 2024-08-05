import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../const/constants.dart';

class DebitCardView extends StatefulWidget {
  const DebitCardView({super.key});

  @override
  State<DebitCardView> createState() => _DebitCardViewState();
}

class _DebitCardViewState extends State<DebitCardView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatAccountNumber(String accountNumber) {
    return accountNumber
        .replaceAllMapped(RegExp(r'.{4}'), (match) => "${match.group(0)} ")
        .trim();
  }

  bool _isCVVVisible = false;
  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: StreamBuilder(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .collection('debit_cards')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No bank accounts found."));
            }

            // Get the list of bank account documents
            final bankAccounts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bankAccounts.length,
              itemBuilder: (context, index) {
                final account =
                    bankAccounts[index].data() as Map<String, dynamic>;
                final accountId = bankAccounts[index].id; // Get document ID
                String cardType = snapshot.data!.docs[index]["Card Type"];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: 330,
                  height: 195,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(
                                  cardType == 'Visa'
                                      ? "assets/images/visa.png"
                                      : cardType == 'Mastercard'
                                          ? "assets/images/card.png"
                                          : "assets/images/creadit.png", // Optional default image
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${snapshot.data!.docs[index]["Card Holder Name"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: myConstants.RobotoR,
                          ),
                        ),
                        Text(
                          formatAccountNumber(
                              snapshot.data!.docs[index]["Card Number"]),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: myConstants.RobotoR,
                          ),
                        ),
                        Text(
                          "${snapshot.data!.docs[index]["Expiry Date"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: myConstants.RobotoR,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCVVVisible =
                                      !_isCVVVisible; // Toggle the visibility
                                });
                              },
                              child: Text(
                                _isCVVVisible
                                    ? "${snapshot.data!.docs[index]["CVV"]}"
                                    : '***',
                                // Mask the CVV when not visible
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: myConstants.RobotoR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )),
      ),
    );
  }
}
