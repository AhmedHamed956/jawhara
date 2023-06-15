class OrderPaymentData {
  String orderId;
  String cardNumber;
  String cardHolderName;
  String expiryDate;
  String ccv;
  String amount;
  String customerEmail;
  String customerName;
  String orderDescription; //Phone type
  String phoneNumber;
  String merchantExtra;
  String lang;
  String paymentOption;

  OrderPaymentData(
      {this.orderId,
      this.cardNumber,
      this.cardHolderName,
      this.expiryDate,
      this.ccv,
      this.amount,
      this.customerEmail,
      this.customerName,
      this.orderDescription,
      this.phoneNumber,
      this.merchantExtra,
      this.lang,
      this.paymentOption});

  Map<String, dynamic> toJson() => {
        "orderId": orderId == null ? null : orderId,
        "cardNumber": cardNumber == null ? null : cardNumber,
        "cardHolderName": cardHolderName == null ? null : cardHolderName,
        "expiryDate": expiryDate == null ? null : expiryDate,
        "ccv": ccv == null ? null : ccv,
        "amount": amount == null ? null : amount,
        "customerEmail": customerEmail == null ? null : customerEmail,
        "customerName": customerName == null ? null : customerName,
        "orderDescription": orderDescription == null ? null : orderDescription,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "merchantExtra": merchantExtra == null ? null : merchantExtra,
        "lang": lang == null ? null : lang,
        "paymentOption": paymentOption == null ? null : paymentOption,
      };
}
