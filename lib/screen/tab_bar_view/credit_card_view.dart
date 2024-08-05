import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_vault/const/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView({super.key});

  @override
  State<CreditCardView> createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> {
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
              .collection('credit_cards')
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
                    color: Colors.blueAccent,
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
/*
Container(
width: 330,
height: 200,
decoration: BoxDecoration(
color: Colors.blueAccent,
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
padding: const EdgeInsets.all(20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
// Bank logo
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Bank Logo',
style: TextStyle(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
Icon(
Icons.credit_card,
color: Colors.white,
size: 40,
),
],
),
// Card number
Text(
'1234 5678 9012 3456',
style: TextStyle(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
// Cardholder name
Text(
'CARDHOLDER NAME',
style: TextStyle(
color: Colors.white,
fontSize: 16,
),
),
// Expiry date
Text(
'12/25',
style: TextStyle(
color: Colors.white,
fontSize: 16,
),
),
// CVV
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
_isCVVVisible ? _cvv : '***',
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
IconButton(
icon: Icon(
_isCVVVisible
? Icons.visibility
    : Icons.visibility_off,
color: Colors.white,
),
onPressed: () {
setState(() {
_isCVVVisible = !_isCVVVisible;
});
},
),
],
),
],
),
),
),*/
