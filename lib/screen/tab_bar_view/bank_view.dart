import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_vault/const/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankView extends StatefulWidget {
  const BankView({super.key});

  @override
  State<BankView> createState() => _BankViewState();
}

class _BankViewState extends State<BankView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatAccountNumber(String accountNumber) {
    return accountNumber
        .replaceAllMapped(RegExp(r'.{3}'), (match) => "${match.group(0)} ")
        .trim();
  }

  Future<void> _deleteBankAccount(String accountId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('bankAccounts')
          .doc(accountId)
          .delete();
      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bank account deleted successfully')),
      );
    } catch (e) {
      // Optionally handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting bank account: $e')),
      );
    }
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .collection('bankAccounts')
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

                  return Card(
                    elevation: 10,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bank: ${account['Bank Name'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Account Number: ${formatAccountNumber(account['Account Number'] ?? 'Unknown')}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "IFSC Code: ${account['IFSC Code'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _deleteBankAccount(accountId),
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontFamily: myConstants.RobotoR,
                                color: CupertinoColors.systemRed,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
