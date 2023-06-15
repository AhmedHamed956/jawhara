// To parse this JSON data, do
//
//     final myOrders = myOrdersFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/model/cart/cart.dart';

class MyOrders {
  MyOrders({this.items, this.totalCount, this.searchCriteria});

  List<MyOrdersItem> items;
  int totalCount;
  SearchCriteria searchCriteria;

  factory MyOrders.fromRawJson(String str) => MyOrders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
        items: json["items"] == null ? null : List<MyOrdersItem>.from(json["items"].map((x) => MyOrdersItem.fromJson(x))),
        totalCount: json["total_count"] == null ? null : json["total_count"],
        searchCriteria: SearchCriteria.fromJson(json["search_criteria"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
        "total_count": totalCount == null ? null : totalCount,
        "search_criteria": searchCriteria.toJson(),
      };
}

class SearchCriteria {
  SearchCriteria({
    this.pageSize,
    this.currentPage,
  });

  int pageSize;
  int currentPage;

  factory SearchCriteria.fromRawJson(String str) => SearchCriteria.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
        pageSize: json["page_size"],
        currentPage: json["current_page"],
      );

  Map<String, dynamic> toJson() => {
        "page_size": pageSize,
        "current_page": currentPage,
      };
}

class MyOrdersItem {
  MyOrdersItem({
    this.status,
    this.subtotal,
    this.total,
    this.items,
    this.billingAddress,
    this.incrementId,
    this.entityId,
    this.grandTotal,
    this.updatedAt,
    this.baseSubtotalInclTax,
    this.extensionAttributes,
    this.shippingInclTax,
    this.shippingDescription,
    this.taxAmount,
    this.baseTotalDue,
    this.payment,
  });

  String status;
  double subtotal;
  double total;
  List<ItemItem> items;
  Address billingAddress;
  String incrementId;
  String entityId;
  double grandTotal;
  DateTime updatedAt;
  String baseSubtotalInclTax;
  ExtensionAttributes extensionAttributes;
  String shippingInclTax;
  String shippingDescription;
  String taxAmount;
  String baseTotalDue;
  Payment payment;

  factory MyOrdersItem.fromRawJson(String str) => MyOrdersItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrdersItem.fromJson(Map<String, dynamic> json) => MyOrdersItem(
        baseSubtotalInclTax: json["base_subtotal_incl_tax"].toString() == null ? null : json["base_subtotal_incl_tax"].toString(),
        status: json["status"] == null ? null : json["status"],
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        total: json["base_total_paid"] == null ? null : json["base_total_paid"].toDouble(),
        items: json["items"] == null ? null : List<ItemItem>.from(json["items"].map((x) => ItemItem.fromJson(x))),
        billingAddress: Address.fromJson(json["billing_address"]),
        incrementId: json["increment_id"] == null ? null : json["increment_id"],
        entityId: json["entity_id"] == null ? null : json["entity_id"].toString(),
        grandTotal: json["grand_total"] == null ? null : double.parse(json["grand_total"].toString()),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        extensionAttributes: json["extension_attributes"] == null ? null : ExtensionAttributes.fromJson(json["extension_attributes"]),
        shippingInclTax: json["shipping_incl_tax"] == null ? null : json["shipping_incl_tax"].toString(),
        shippingDescription: json["shipping_description"] == null ? null : json["shipping_description"].toString(),
        taxAmount: json["tax_amount"] == null ? null : json["tax_amount"].toString(),
        baseTotalDue: json["base_total_due"] == null ? null : json["base_total_due"].toString(),
        payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "base_subtotal_incl_tax": baseSubtotalInclTax == null ? null : baseSubtotalInclTax,
        "status": status == null ? null : status,
        "subtotal": subtotal == null ? null : subtotal,
        "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
        "billing_address": billingAddress.toJson(),
        "increment_id": incrementId == null ? null : incrementId,
        "grand_total": grandTotal == null ? null : grandTotal,
        "updated_at": updatedAt == null ? null : updatedAt,
        "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
        "shipping_incl_tax": shippingInclTax == null ? null : shippingInclTax,
        "shipping_description": shippingDescription == null ? null : shippingDescription,
        "tax_amount": taxAmount == null ? null : taxAmount,
        "base_total_due": baseTotalDue == null ? null : baseTotalDue,
        "payment": payment == null ? null : payment.toJson(),
      };
}

class Address {
  Address({
    this.addressType,
    this.city,
    this.countryId,
    this.customerAddressId,
    this.email,
    this.entityId,
    this.firstname,
    this.lastname,
    this.parentId,
    this.postcode,
    this.street,
    this.telephone,
    this.region,
    this.regionCode,
  });

  String addressType;
  String city;
  String countryId;
  int customerAddressId;
  String email;
  int entityId;
  String firstname;
  String lastname;
  int parentId;
  String postcode;
  List<String> street;
  String telephone;
  String region;
  String regionCode;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressType: json["address_type"],
        city: json["city"],
        countryId: json["country_id"],
        customerAddressId: json["customer_address_id"],
        email: json["email"],
        entityId: json["entity_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        parentId: json["parent_id"],
        postcode: json["postcode"],
        street: List<String>.from(json["street"].map((x) => x)),
        telephone: json["telephone"],
        region: json["region"] == null ? null : json["region"],
        regionCode: json["region_code"] == null ? null : json["region_code"],
      );

  Map<String, dynamic> toJson() => {
        "address_type": addressType,
        "city": city,
        "country_id": countryId,
        "customer_address_id": customerAddressId,
        "email": email,
        "entity_id": entityId,
        "firstname": firstname,
        "lastname": lastname,
        "parent_id": parentId,
        "postcode": postcode,
        "street": List<dynamic>.from(street.map((x) => x)),
        "telephone": telephone,
        "region": region == null ? null : region,
        "region_code": regionCode == null ? null : regionCode,
      };
}

class ItemItem {
  ItemItem({
    this.name,
    this.orderId,
    this.itemId,
    this.sku,
    this.extensionAttributes,
    this.qtyOrdered,
    this.basePriceInclTax,
    this.baseRowTotalInclTax,
  });

  String name;
  int orderId;
  int itemId;
  int qtyOrdered;
  String sku;
  ExtensionAttributes extensionAttributes;
  String basePriceInclTax;
  String baseRowTotalInclTax;

  factory ItemItem.fromRawJson(String str) => ItemItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemItem.fromJson(Map<String, dynamic> json) => ItemItem(
        qtyOrdered: json["qty_ordered"] == null ? null : json["qty_ordered"],
        name: json["name"] == null ? null : json["name"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        sku: json["sku"] == null ? null : json["sku"],
        extensionAttributes: json["extension_attributes"] == null ? null : ExtensionAttributes.fromJson(json["extension_attributes"]),
        basePriceInclTax: json["base_price_incl_tax"] == null ? "" : json["base_price_incl_tax"].toString(),
        baseRowTotalInclTax: json["base_row_total_incl_tax"] == null ? "" : json["base_row_total_incl_tax"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "qty_ordered": qtyOrdered == null ? null : qtyOrdered,
        "name": name == null ? null : name,
        "order_id": orderId == null ? null : orderId,
        "item_id": itemId == null ? null : itemId,
        "sku": sku == null ? null : sku,
        "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
        "base_price_incl_tax": basePriceInclTax == null ? null : basePriceInclTax.toString(),
        "base_row_total_incl_tax": baseRowTotalInclTax == null ? null : baseRowTotalInclTax.toString(),
      };
}

class ExtensionAttributes {
  ExtensionAttributes({
    this.imageUrl,
    this.baseCashOnDeliveryFee,
    this.shippingAssignments,
  });

  String imageUrl;
  String baseCashOnDeliveryFee;
  List<ShippingAssignment> shippingAssignments;

  factory ExtensionAttributes.fromRawJson(String str) => ExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) {
    return ExtensionAttributes(
      imageUrl: json["image_url"] == null ? null : json["image_url"],
      baseCashOnDeliveryFee: json["base_cash_on_delivery_fee"] == null ? "" : json["base_cash_on_delivery_fee"].toString(),
      shippingAssignments: json["shipping_assignments"] == null
          ? null
          : List<ShippingAssignment>.from(json["shipping_assignments"].map((x) => ShippingAssignment.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl == null ? null : imageUrl,
        "base_cash_on_delivery_fee": baseCashOnDeliveryFee == null ? null : baseCashOnDeliveryFee,
        "shipping_assignments": List<dynamic>.from(shippingAssignments.map((x) => x.toJson())),
      };
}

class Shipping {
  Shipping({
    this.address,
  });

  Address address;

  factory Shipping.fromRawJson(String str) => Shipping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
      };
}

class Payment {
  Payment({
    this.method,
    this.additionalInformation,
  });

  String method;
  List<String> additionalInformation;

  factory Payment.fromRawJson(String str) => Payment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        method: json["method"],
        additionalInformation: List<String>.from(json["additional_information"].map((x) => x == null ? null : x)),
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "additional_information": List<dynamic>.from(additionalInformation.map((x) => x == null ? null : x)),
      };
}
