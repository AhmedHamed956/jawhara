// To parse this JSON data, do
//
//     final paymentMethods = paymentMethodsFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/model/cart/cart.dart';
import 'package:jawhara/model/cart/checkout.dart';

class PaymentMethods {
  PaymentMethods({
    this.paymentMethods,
    this.totals,
  });

  List<PaymentMethod> paymentMethods;
  Checkout totals;

  factory PaymentMethods.fromRawJson(String str) => PaymentMethods.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
    paymentMethods: json["payment_methods"] == null ? null : List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
    totals: json["totals"] == null ? null : Checkout.fromJson(json["totals"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_methods": paymentMethods == null ? null : List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
    "totals": totals == null ? null : totals.toJson(),
  };
}

class PaymentMethod {
  PaymentMethod({
    this.code,
    this.title,
  });

  String code;
  String title;
  bool selected = false;

  factory PaymentMethod.fromRawJson(String str) => PaymentMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    code: json["code"] == null ? null : json["code"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "title": title == null ? null : title,
  };
}

// class Totals {
//   Totals({
//     this.grandTotal,
//     this.baseGrandTotal,
//     this.subtotal,
//     this.baseSubtotal,
//     this.discountAmount,
//     this.baseDiscountAmount,
//     this.subtotalWithDiscount,
//     this.baseSubtotalWithDiscount,
//     this.shippingAmount,
//     this.baseShippingAmount,
//     this.shippingDiscountAmount,
//     this.baseShippingDiscountAmount,
//     this.taxAmount,
//     this.baseTaxAmount,
//     this.weeeTaxAppliedAmount,
//     this.shippingTaxAmount,
//     this.baseShippingTaxAmount,
//     this.subtotalInclTax,
//     this.shippingInclTax,
//     this.baseShippingInclTax,
//     this.baseCurrencyCode,
//     this.quoteCurrencyCode,
//     this.couponCode,
//     this.itemsQty,
//   });
//
//   double grandTotal;
//   int baseGrandTotal;
//   dynamic subtotal;
//   dynamic baseSubtotal;
//   int discountAmount;
//   int baseDiscountAmount;
//   double subtotalWithDiscount;
//   double baseSubtotalWithDiscount;
//   int shippingAmount;
//   int baseShippingAmount;
//   int shippingDiscountAmount;
//   int baseShippingDiscountAmount;
//   dynamic taxAmount;
//   dynamic baseTaxAmount;
//   dynamic weeeTaxAppliedAmount;
//   int shippingTaxAmount;
//   int baseShippingTaxAmount;
//   int subtotalInclTax;
//   int shippingInclTax;
//   int baseShippingInclTax;
//   String baseCurrencyCode;
//   String quoteCurrencyCode;
//   String couponCode;
//   int itemsQty;
//
//   factory Totals.fromRawJson(String str) => Totals.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Totals.fromJson(Map<String, dynamic> json) => Totals(
//     grandTotal: json["grand_total"] == null ? null : json["grand_total"].toDouble(),
//     baseGrandTotal: json["base_grand_total"] == null ? null : json["base_grand_total"],
//     subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
//     baseSubtotal: json["base_subtotal"] == null ? null : json["base_subtotal"].toDouble(),
//     discountAmount: json["discount_amount"] == null ? null : json["discount_amount"],
//     baseDiscountAmount: json["base_discount_amount"] == null ? null : json["base_discount_amount"],
//     subtotalWithDiscount: json["subtotal_with_discount"] == null ? null : json["subtotal_with_discount"].toDouble(),
//     baseSubtotalWithDiscount: json["base_subtotal_with_discount"] == null ? null : json["base_subtotal_with_discount"].toDouble(),
//     shippingAmount: json["shipping_amount"] == null ? null : json["shipping_amount"],
//     baseShippingAmount: json["base_shipping_amount"] == null ? null : json["base_shipping_amount"],
//     shippingDiscountAmount: json["shipping_discount_amount"] == null ? null : json["shipping_discount_amount"],
//     baseShippingDiscountAmount: json["base_shipping_discount_amount"] == null ? null : json["base_shipping_discount_amount"],
//     taxAmount: json["tax_amount"] == null ? null : json["tax_amount"].toDouble(),
//     baseTaxAmount: json["base_tax_amount"] == null ? null : json["base_tax_amount"].toDouble(),
//     weeeTaxAppliedAmount: json["weee_tax_applied_amount"],
//     shippingTaxAmount: json["shipping_tax_amount"] == null ? null : json["shipping_tax_amount"],
//     baseShippingTaxAmount: json["base_shipping_tax_amount"] == null ? null : json["base_shipping_tax_amount"],
//     subtotalInclTax: json["subtotal_incl_tax"] == null ? null : json["subtotal_incl_tax"],
//     shippingInclTax: json["shipping_incl_tax"] == null ? null : json["shipping_incl_tax"],
//     baseShippingInclTax: json["base_shipping_incl_tax"] == null ? null : json["base_shipping_incl_tax"],
//     baseCurrencyCode: json["base_currency_code"] == null ? null : json["base_currency_code"],
//     quoteCurrencyCode: json["quote_currency_code"] == null ? null : json["quote_currency_code"],
//     couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
//     itemsQty: json["items_qty"] == null ? null : json["items_qty"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "grand_total": grandTotal == null ? null : grandTotal,
//     "base_grand_total": baseGrandTotal == null ? null : baseGrandTotal,
//     "subtotal": subtotal == null ? null : subtotal,
//     "base_subtotal": baseSubtotal == null ? null : baseSubtotal,
//     "discount_amount": discountAmount == null ? null : discountAmount,
//     "base_discount_amount": baseDiscountAmount == null ? null : baseDiscountAmount,
//     "subtotal_with_discount": subtotalWithDiscount == null ? null : subtotalWithDiscount,
//     "base_subtotal_with_discount": baseSubtotalWithDiscount == null ? null : baseSubtotalWithDiscount,
//     "shipping_amount": shippingAmount == null ? null : shippingAmount,
//     "base_shipping_amount": baseShippingAmount == null ? null : baseShippingAmount,
//     "shipping_discount_amount": shippingDiscountAmount == null ? null : shippingDiscountAmount,
//     "base_shipping_discount_amount": baseShippingDiscountAmount == null ? null : baseShippingDiscountAmount,
//     "tax_amount": taxAmount == null ? null : taxAmount,
//     "base_tax_amount": baseTaxAmount == null ? null : baseTaxAmount,
//     "weee_tax_applied_amount": weeeTaxAppliedAmount,
//     "shipping_tax_amount": shippingTaxAmount == null ? null : shippingTaxAmount,
//     "base_shipping_tax_amount": baseShippingTaxAmount == null ? null : baseShippingTaxAmount,
//     "subtotal_incl_tax": subtotalInclTax == null ? null : subtotalInclTax,
//     "shipping_incl_tax": shippingInclTax == null ? null : shippingInclTax,
//     "base_shipping_incl_tax": baseShippingInclTax == null ? null : baseShippingInclTax,
//     "base_currency_code": baseCurrencyCode == null ? null : baseCurrencyCode,
//     "quote_currency_code": quoteCurrencyCode == null ? null : quoteCurrencyCode,
//     "coupon_code": couponCode == null ? null : couponCode,
//     "items_qty": itemsQty == null ? null : itemsQty,
//   };
// }

