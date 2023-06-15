// To parse this JSON data, do
//
//     final checkout = checkoutFromJson(jsonString);

import 'dart:convert';

class Checkout {
  Checkout(
      {this.grandTotal,
      this.baseGrandTotal,
      this.subtotal,
      this.baseSubtotal,
      this.discountAmount,
      this.baseDiscountAmount,
      this.subtotalWithDiscount,
      this.baseSubtotalWithDiscount,
      this.shippingAmount,
      this.baseShippingAmount,
      this.shippingDiscountAmount,
      this.baseShippingDiscountAmount,
      this.taxAmount,
      this.baseTaxAmount,
      this.weeeTaxAppliedAmount,
      this.shippingTaxAmount,
      this.baseShippingTaxAmount,
      this.subtotalInclTax,
      this.shippingInclTax,
      this.baseShippingInclTax,
      this.baseCurrencyCode,
      this.quoteCurrencyCode,
      this.couponCode,
      this.itemsQty,
      this.totalSegments});

  dynamic grandTotal;
  dynamic baseGrandTotal;
  dynamic subtotal;
  dynamic baseSubtotal;
  dynamic discountAmount;
  dynamic baseDiscountAmount;
  dynamic subtotalWithDiscount;
  dynamic baseSubtotalWithDiscount;
  dynamic shippingAmount;
  dynamic baseShippingAmount;
  dynamic shippingDiscountAmount;
  dynamic baseShippingDiscountAmount;
  dynamic taxAmount;
  dynamic baseTaxAmount;
  dynamic weeeTaxAppliedAmount;
  dynamic shippingTaxAmount;
  dynamic baseShippingTaxAmount;
  dynamic subtotalInclTax;
  dynamic shippingInclTax;
  dynamic baseShippingInclTax;
  String baseCurrencyCode;
  String quoteCurrencyCode;
  String couponCode;
  dynamic itemsQty;
  List<TotalSegment> totalSegments;

  factory Checkout.fromRawJson(String str) => Checkout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
        grandTotal: json["grand_total"] == null ? null : json["grand_total"].toDouble(),
        baseGrandTotal: json["base_grand_total"] == null ? null : json["base_grand_total"].toDouble(),
        subtotal: json["subtotal"] == null ? null : json["subtotal"],
        baseSubtotal: json["base_subtotal"] == null ? null : json["base_subtotal"],
        discountAmount: json["discount_amount"] == null ? null : json["discount_amount"].toDouble(),
        baseDiscountAmount: json["base_discount_amount"] == null ? null : json["base_discount_amount"].toDouble(),
        subtotalWithDiscount: json["subtotal_with_discount"] == null ? null : json["subtotal_with_discount"].toDouble(),
        baseSubtotalWithDiscount: json["base_subtotal_with_discount"] == null ? null : json["base_subtotal_with_discount"].toDouble(),
        shippingAmount: json["shipping_amount"] == null ? null : json["shipping_amount"],
        baseShippingAmount: json["base_shipping_amount"] == null ? null : json["base_shipping_amount"],
        shippingDiscountAmount: json["shipping_discount_amount"] == null ? null : json["shipping_discount_amount"],
        baseShippingDiscountAmount: json["base_shipping_discount_amount"] == null ? null : json["base_shipping_discount_amount"],
        taxAmount: json["tax_amount"] == null ? null : json["tax_amount"],
        baseTaxAmount: json["base_tax_amount"] == null ? null : json["base_tax_amount"],
        weeeTaxAppliedAmount: json["weee_tax_applied_amount"],
        shippingTaxAmount: json["shipping_tax_amount"] == null ? null : json["shipping_tax_amount"],
        baseShippingTaxAmount: json["base_shipping_tax_amount"] == null ? null : json["base_shipping_tax_amount"],
        subtotalInclTax: json["subtotal_incl_tax"] == null ? null : json["subtotal_incl_tax"],
        shippingInclTax: json["shipping_incl_tax"] == null ? null : json["shipping_incl_tax"],
        baseShippingInclTax: json["base_shipping_incl_tax"] == null ? null : json["base_shipping_incl_tax"],
        baseCurrencyCode: json["base_currency_code"] == null ? null : json["base_currency_code"],
        quoteCurrencyCode: json["quote_currency_code"] == null ? null : json["quote_currency_code"],
        couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
        itemsQty: json["items_qty"] == null ? null : json["items_qty"],
        totalSegments: List<TotalSegment>.from(json["total_segments"].map((x) => TotalSegment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "grand_total": grandTotal == null ? null : grandTotal,
        "base_grand_total": baseGrandTotal == null ? null : baseGrandTotal,
        "subtotal": subtotal == null ? null : subtotal,
        "base_subtotal": baseSubtotal == null ? null : baseSubtotal,
        "discount_amount": discountAmount == null ? null : discountAmount,
        "base_discount_amount": baseDiscountAmount == null ? null : baseDiscountAmount,
        "subtotal_with_discount": subtotalWithDiscount == null ? null : subtotalWithDiscount,
        "base_subtotal_with_discount": baseSubtotalWithDiscount == null ? null : baseSubtotalWithDiscount,
        "shipping_amount": shippingAmount == null ? null : shippingAmount,
        "base_shipping_amount": baseShippingAmount == null ? null : baseShippingAmount,
        "shipping_discount_amount": shippingDiscountAmount == null ? null : shippingDiscountAmount,
        "base_shipping_discount_amount": baseShippingDiscountAmount == null ? null : baseShippingDiscountAmount,
        "tax_amount": taxAmount == null ? null : taxAmount,
        "base_tax_amount": baseTaxAmount == null ? null : baseTaxAmount,
        "weee_tax_applied_amount": weeeTaxAppliedAmount,
        "shipping_tax_amount": shippingTaxAmount == null ? null : shippingTaxAmount,
        "base_shipping_tax_amount": baseShippingTaxAmount == null ? null : baseShippingTaxAmount,
        "subtotal_incl_tax": subtotalInclTax == null ? null : subtotalInclTax,
        "shipping_incl_tax": shippingInclTax == null ? null : shippingInclTax,
        "base_shipping_incl_tax": baseShippingInclTax == null ? null : baseShippingInclTax,
        "base_currency_code": baseCurrencyCode == null ? null : baseCurrencyCode,
        "quote_currency_code": quoteCurrencyCode == null ? null : quoteCurrencyCode,
        "coupon_code": couponCode == null ? null : couponCode,
        "items_qty": itemsQty == null ? null : itemsQty,
        "total_segments": List<dynamic>.from(totalSegments.map((x) => x.toJson())),
      };
}

class TotalSegment {
  TotalSegment({this.code, this.title, this.value, this.area, this.extensionAttributes});

  String code;
  String title;
  double value;
  String area;
  TotalSegmentExtensionAttributes extensionAttributes;

  factory TotalSegment.fromRawJson(String str) => TotalSegment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalSegment.fromJson(Map<String, dynamic> json) => TotalSegment(
        code: json["code"],
        title: json["title"],
        value: json["value"] == null ? null : json["value"].toDouble(),
        area: json["area"] == null ? null : json["area"],
        extensionAttributes:
            json["extension_attributes"] == null ? null : TotalSegmentExtensionAttributes.fromJson(json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "title": title,
        "value": value == null ? null : value,
        "area": area == null ? null : area,
        "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
      };
}

class TotalSegmentExtensionAttributes {
  TotalSegmentExtensionAttributes({
    this.giftCards,
  });

  String giftCards;

  factory TotalSegmentExtensionAttributes.fromRawJson(String str) => TotalSegmentExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalSegmentExtensionAttributes.fromJson(Map<String, dynamic> json) => TotalSegmentExtensionAttributes(
        giftCards: json["gift_cards"] == null ? null : json["gift_cards"],
      );

  Map<String, dynamic> toJson() => {
        "gift_cards": giftCards == null ? null : giftCards,
      };
}
