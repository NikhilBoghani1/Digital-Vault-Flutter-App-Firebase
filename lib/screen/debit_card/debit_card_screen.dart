import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/model/debit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebitCardScreen extends StatefulWidget {
  const DebitCardScreen({super.key});

  @override
  State<DebitCardScreen> createState() => _DebitCardScreenState();
}

class _DebitCardScreenState extends State<DebitCardScreen> {
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardCVV = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedType;
  final List<String> _cardType = [
    'Visa',
    ' Mastercard',
  ];

  @override
  void initState() {
    super.initState();
    _expiryController.addListener(_formatExpiryDate);
    cardNumber.addListener(_formatAccountNumber);
  }

  @override
  void dispose() {
    _expiryController.dispose();
    cardNumber.removeListener(_formatAccountNumber);
    cardNumber.dispose();
    super.dispose();
  }

  void _formatAccountNumber() {
    // Get current input without spaces
    String currentText = cardNumber.text.replaceAll(' ', '');

    // Format the input by adding space every 4 digits
    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < currentText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText.write(' '); // Add space
      }
      formattedText.write(currentText[i]);
    }

    // Update the controller with the new formatted text
    // It's important to check if the text has changed to avoid infinite loops
    if (formattedText.toString() != cardNumber.text) {
      cardNumber.value = TextEditingValue(
        text: formattedText.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: formattedText.length),
        ),
      );
    }
  }

  void _formatExpiryDate() {
    String text = _expiryController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    String formattedText = '';
    if (text.length >= 2) {
      formattedText =
          '${text.substring(0, 2)}/${text.substring(2, text.length)}';
    } else if (text.length == 1) {
      formattedText = '${text.substring(0, 1)}';
    }

    if (formattedText != _expiryController.text) {
      _expiryController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.fromPosition(
            TextPosition(offset: formattedText.length)),
      );
    }
  }

  Future<void> _addDebitCard() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Create an instance of the DebitCardModel
      DebitCardModel debitCard = DebitCardModel(
        cardHolderName: cardHolderName.text.trim(),
        cardNumber: cardNumber.text.trim(),
        cvv: cardCVV.text.trim(),
        expiryDate: _expiryController.text.trim(),
        cardType: _selectedType,
      );

      // Reference to the user's document in the 'users' collection
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Add bank card details to the user's 'debitDetails' sub-collection
      await userDocRef.collection('debit_cards').add(debitCard.toMap());

      // Clear the text fields after adding
      cardHolderName.clear();
      cardNumber.clear();
      cardCVV.clear();
      _expiryController.clear();
      _selectedType = null; // Resetting selected type

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debit card added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

/*  Future<void> _addDebitCard() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Reference to the user's document in the 'users' collection
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Add bank account to the user's 'bankAccounts' sub-collection
      await userDocRef.collection('debitDetails').add({
        'Card Holder Name': cardHolderName.text.trim(),
        'Card Number': cardNumber.text.trim(),
        'CVV': cardCVV.text.trim(),
        'Expiry Date': _expiryController.text.trim(),
        'Card Type': _selectedType,
      });

      // Clear the text fields after adding
      cardHolderName.clear();
      cardNumber.clear();
      cardCVV.clear();
      _expiryController.clear();
      _cardType.clear();

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debit added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }*/

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: CupertinoColors.activeGreen.withOpacity(0.2),
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.left_chevron),
                      SizedBox(width: 10),
                      Text(
                        'Add Debit Card',
                        style: TextStyle(
                          fontFamily: myConstants.PoppinsSB,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                Positioned(
                  child: Center(
                    child: Image(
                      width: 100,
                      height: 100,
                      image: AssetImage(
                        "assets/images/debit.png",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: cardHolderName,
                decoration: InputDecoration(
                  hintText: 'Card Holder Name',
                  hintStyle: TextStyle(
                    fontFamily: myConstants.RobotoL,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: cardNumber,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: InputDecoration(
                  hintText: 'Card Number',
                  hintStyle: TextStyle(
                    fontFamily: myConstants.RobotoL,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cardCVV,
                      keyboardType: TextInputType.number,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      // ],
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        hintStyle: TextStyle(
                          fontFamily: myConstants.RobotoL,
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      // ],
                      decoration: InputDecoration(
                        hintText: 'MM/YY',
                        hintStyle: TextStyle(
                          fontFamily: myConstants.RobotoL,
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: DropdownButton<String>(
                    hint: Text(
                      "Card Type",
                      style: TextStyle(
                        fontFamily: myConstants.RobotoR,
                      ),
                    ),
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    items:
                        _cardType.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: myConstants.RobotoL,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 17),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _addDebitCard,
                child: Text(
                  'Add Debit Card',
                  style: TextStyle(
                    fontFamily: myConstants.RobotoR,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Expanded(child: BankAccountList()), // Show the bank accounts
          ],
        ),
      ),
    );
  }
}
