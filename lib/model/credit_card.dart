// credit_card.dart

class CreditCard {
  final String cardHolderName;
  final String cardNumber;
  final String CVV;
  final String expiryDate;
  final String cardType;

  CreditCard({
    required this.cardHolderName,
    required this.cardNumber,
    required this.CVV,
    required this.expiryDate,
    required this.cardType,
  });

  // Convert a CreditCard instance into a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'Card Holder Name': cardHolderName,
      'Card Number': cardNumber,
      'CVV': CVV,
      'Expiry Date': expiryDate,
      'Card Type': cardType,
    };
  }

  // Create a CreditCard instance from a map (for Firebase retrieval)
  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      cardHolderName: map['Card Holder Name'],
      cardNumber: map['Card Number'],
      CVV: map['CVV'],
      expiryDate: map['Expiry Date'],
      cardType: map['Card Type'],
    );
  }
}