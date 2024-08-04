// bank_account.dart

class BankAccount {
  String accountHolderName;
  String bankName;
  String accountNumber;
  String IFSCCode;
  String accountType;

  BankAccount({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.IFSCCode,
    required this.accountType,
  });

  // Convert BankAccount instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'Account Holder': accountHolderName,
      'Bank Name': bankName,
      'Account Number': accountNumber,
      'IFSC Code': IFSCCode,
      'Account Type': accountType,
    };
  }

  // Create a BankAccount object from a Map
  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      accountHolderName: map['Account Holder'],
      bankName: map['Bank Name'],
      accountNumber: map['Account Number'],
      IFSCCode: map['IFSC Code'],
      accountType: map['Account Type'],
    );
  }
}