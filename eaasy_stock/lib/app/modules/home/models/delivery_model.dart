class Delivery {
  final String trackingCode;
  final String registerDate;

  Delivery({required this.trackingCode, required this.registerDate});

  Map<String, dynamic> toJson() {
    return {
      'trackingCode': trackingCode,
      'registerDate': registerDate,
    };
  }
}