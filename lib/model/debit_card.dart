// debit_card_model.dart

class DebitCardModel {
  final String cardHolderName;
  final String cardNumber;
  final String cvv;
  final String expiryDate;
  final String? cardType;

  DebitCardModel({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cvv,
    required this.expiryDate,
    this.cardType,
  });

  // Optional: A method to convert to a Map for Firestore insertion
  Map<String, dynamic> toMap() {
    return {
      'Card Holder Name': cardHolderName,
      'Card Number': cardNumber,
      'CVV': cvv,
      'Expiry Date': expiryDate,
      'Card Type': cardType,
    };
  }

  // Optional: A method to create an instance from a Map
  factory DebitCardModel.fromMap(Map<String, dynamic> map) {
    return DebitCardModel(
      cardHolderName: map['Card Holder Name'] ?? '',
      cardNumber: map['Card Number'] ?? '',
      cvv: map['CVV'] ?? '',
      expiryDate: map['Expiry Date'] ?? '',
      cardType: map['Card Type'],
    );
  }
}