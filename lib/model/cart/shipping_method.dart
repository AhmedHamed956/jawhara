// To parse this JSON data, do
//
//     final shippingMethodsModel = shippingMethodsModelFromJson(jsonString);

import 'dart:convert';

class ShippingMethodsModel {
  ShippingMethodsModel({
    this.shippingMethods,
  });

  List<ShippingMethod> shippingMethods;

  factory ShippingMethodsModel.fromRawJson(String str) => ShippingMethodsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingMethodsModel.fromJson(Map<String, dynamic> json) => ShippingMethodsModel(
    shippingMethods: json["shipping_methods"] == null ? null : List<ShippingMethod>.from(json["shipping_methods"].map((x) => ShippingMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shipping_methods": shippingMethods == null ? null : List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
  };
}

class ShippingMethod {
  ShippingMethod({
    this.carrierCode,
    this.methodCode,
    this.carrierTitle,
    this.methodTitle,
    this.amount,
    this.baseAmount,
    this.available,
    this.errorMessage,
    this.priceExclTax,
    this.priceInclTax,
  });

  String carrierCode;
  String methodCode;
  String carrierTitle;
  String methodTitle;
  dynamic amount;
  dynamic baseAmount;
  bool available;
  dynamic errorMessage;
  dynamic priceExclTax;
  dynamic priceInclTax;
  bool selected = false;

  factory ShippingMethod.fromRawJson(String str) => ShippingMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
    carrierCode: json["carrier_code"] == null ? null : json["carrier_code"],
    methodCode: json["method_code"] == null ? null : json["method_code"],
    carrierTitle: json["carrier_title"] == null ? null : json["carrier_title"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    amount: json["amount"] == null ? null : json["amount"],
    baseAmount: json["base_amount"] == null ? null : json["base_amount"],
    available: json["available"] == null ? null : json["available"],
    errorMessage: json["error_message"],
    priceExclTax: json["price_excl_tax"] == null ? null : json["price_excl_tax"],
    priceInclTax: json["price_incl_tax"] == null ? null : json["price_incl_tax"],
  );

  Map<String, dynamic> toJson() => {
    "carrier_code": carrierCode == null ? null : carrierCode,
    "method_code": methodCode == null ? null : methodCode,
    "carrier_title": carrierTitle == null ? null : carrierTitle,
    "method_title": methodTitle == null ? null : methodTitle,
    "amount": amount == null ? null : amount,
    "base_amount": baseAmount == null ? null : baseAmount,
    "available": available == null ? null : available,
    "error_message": errorMessage,
    "price_excl_tax": priceExclTax == null ? null : priceExclTax,
    "price_incl_tax": priceInclTax == null ? null : priceInclTax,
  };
}
