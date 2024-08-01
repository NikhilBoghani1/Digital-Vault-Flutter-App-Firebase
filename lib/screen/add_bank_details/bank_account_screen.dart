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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addBankAccount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Reference to the user's document in the 'users' collection
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Add bank account to the user's 'bankAccounts' sub-collection
      await userDocRef.collection('bankAccounts').add({
        'bankName': bankNameController.text.trim(),
        'accountNumber': accountNumberController.text.trim(),
      });

      // Clear the text fields after adding
      bankNameController.clear();
      accountNumberController.clear();

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
      appBar: AppBar(title: Text('Add Bank Account')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Bank Name',
              style: TextStyle(
                fontFamily: myConstants.RobotoR,
                fontSize: 17,
                color: CupertinoColors.black.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: bankNameController,
              decoration: InputDecoration(
                hintText: 'Bank Name',
                hintStyle: TextStyle(
                  fontFamily: myConstants.RobotoL,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Account Number',
              style: TextStyle(
                fontFamily: myConstants.RobotoR,
                fontSize: 17,
                color: CupertinoColors.black.withOpacity(0.7),
              ),
            ),
          ),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _addBankAccount,
              child: Text('Add Bank Account'),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: BankAccountList()), // Show the bank accounts
        ],
      ),
    );
  }
}

class BankAccountList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('bankAccounts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No bank accounts found.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data != null) {
              final account = BankAccount.fromJson(doc.id, data);
              return ListTile(
                title: Text('Bank: ${account.bankName}'),
                subtitle: Text('Account Number: ${account.accountNumber}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showUpdateDialog(context, account),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          _showDeleteConfirmation(context, account.id),
                    ),
                  ],
                ),
              );
            } else {
              return ListTile(
                title: Text('Error: No data available'),
                subtitle: Text('Document ID: ${doc.id}'),
              );
            }
          }).toList(),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, BankAccount account) {
    final bankNameController = TextEditingController(text: account.bankName);
    final accountNumberController =
        TextEditingController(text: account.accountNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Bank Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bankNameController,
                decoration: InputDecoration(labelText: 'Bank Name'),
              ),
              TextField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  suffixIcon: accountNumberController.text.length == 17
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.check, color: Colors.red),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateBankAccount(account.id, bankNameController.text,
                    accountNumberController.text);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateBankAccount(String id, String bankName, String accountNumber) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bankAccounts')
        .doc(id)
        .update({
      'bankName': bankName,
      'accountNumber': accountNumber,
    }).then((_) {
      // Optionally show a success message
    }).catchError((error) {
      // Handle error
    });
  }

  void _showDeleteConfirmation(BuildContext context, String accountId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Bank Account'),
          content: Text('Are you sure you want to delete this bank account?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteBankAccount(accountId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBankAccount(String id) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bankAccounts')
        .doc(id)
        .delete()
        .then((_) {
      // Optionally show a success message
    }).catchError((error) {
      // Handle error
    });
  }
}
