// class BankAccount {
//   String id;
//   String email;
//   String bankName;
//   String accountNumber;
//
//   BankAccount({
//     required this.id,
//     required this.email,
//     required this.bankName,
//     required this.accountNumber,
//   });
//
//   factory BankAccount.fromJson(String id, Map<String, dynamic> json) {
//     return BankAccount(
//       id: id,
//       email: json['email'],
//       bankName: json['bankName'],
//       accountNumber: json['accountNumber'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'bankName': bankName,
//       'accountNumber': accountNumber,
//     };
//   }
// }

class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
  });

  factory BankAccount.fromJson(String id, Map<String, dynamic> json) {
    return BankAccount(
      id: id,
      bankName: json['bankName'] ?? 'Unknown Bank', // Default value if null
      accountNumber:
          json['accountNumber'] ?? 'Unknown Account', // Default value if null
    );
  }
}
