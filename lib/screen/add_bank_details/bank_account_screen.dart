import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/model/bank_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class BankAccountScreen extends StatefulWidget {
  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountHoldername = TextEditingController();
  final TextEditingController IFSCcode = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedType;
  final List<String> _accountType = ['Savings', 'Current', 'Business'];

  Future<void> _addBankAccount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Create a BankAccount instance
      BankAccount newAccount = BankAccount(
        accountHolderName: accountHoldername.text.trim(),
        bankName: bankNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        IFSCCode: IFSCcode.text.trim(),
        accountType: _selectedType ?? '', // Safely handle null selection
      );

      // Reference to the user's document in the 'users' collection
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Add bank account to the user's 'bankAccounts' sub-collection using the model's toMap method
      await userDocRef.collection('bankAccounts').add(newAccount.toMap());

      // Clear the text fields after adding
      bankNameController.clear();
      accountNumberController.clear();
      IFSCcode.clear();
      accountHoldername.clear();
      setState(() {
        _selectedType = null; // Reset _selectedType
      });

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bank account added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

/*  Future<void> _addBankAccount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Reference to the user's document in the 'users' collection
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Add bank account to the user's 'bankAccounts' sub-collection
      await userDocRef.collection('bankAccounts').add({
        'Account Holder': accountHoldername.text.trim(),
        'bankName': bankNameController.text.trim(),
        'accountNumber': accountNumberController.text.trim(),
        'IFSCCode': IFSCcode.text.trim(),
        'accountType': _selectedType,
      });

      // Clear the text fields after adding
      bankNameController.clear();
      accountNumberController.clear();
      IFSCcode.clear();
      accountHoldername.clear();
      _accountType.clear();

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bank account added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }*/

  @override
  void initState() {
    super.initState();
    accountNumberController.addListener(_formatAccountNumber);
  }

  void _formatAccountNumber() {
    // Get current input without spaces
    String currentText = accountNumberController.text.replaceAll(' ', '');

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
    if (formattedText.toString() != accountNumberController.text) {
      accountNumberController.value = TextEditingValue(
        text: formattedText.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: formattedText.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    accountNumberController.removeListener(_formatAccountNumber);
    accountNumberController.dispose();
    super.dispose();
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Add Bank Account'),
      // ),
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
                color: CupertinoColors.systemYellow.withOpacity(0.2),
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.left_chevron),
                      SizedBox(width: 10),
                      Text(
                        'Add Bank Account',
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
                        "assets/images/bank.png",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 32),
            //   child: Text(
            //     'Bank Name',
            //     style: TextStyle(
            //       fontFamily: myConstants.RobotoR,
            //       fontSize: 17,
            //       color: CupertinoColors.black.withOpacity(0.7),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: bankNameController,
                decoration: InputDecoration(
                  hintText: 'Bank Name',
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
                controller: accountHoldername,
                decoration: InputDecoration(
                  hintText: 'Account Holder Name',
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
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: InputDecoration(
                  hintText: 'Account Number',
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
                controller: IFSCcode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: InputDecoration(
                  hintText: 'IFSC Code',
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
              child: DropdownButton<String>(
                hint: Text(
                  "Account Type",
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
                    _accountType.map<DropdownMenuItem<String>>((String value) {
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
                onPressed: _addBankAccount,
                child: Text(
                  'Add Bank Account',
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
