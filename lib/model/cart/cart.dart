// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

class Cart {
  Cart({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isVirtual,
    this.items,
    this.itemsCount,
    this.itemsQty,
    this.customer,
    this.billingAddress,
    this.origOrderId,
    this.currency,
    this.customerIsGuest,
    this.customerNoteNotify,
    this.customerTaxClassId,
    this.storeId,
    this.extensionAttributes,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  bool isActive;
  bool isVirtual;
  List<Item> items;
  int itemsCount;
  int itemsQty;
  Customer customer;
  Address billingAddress;
  int origOrderId;
  Currency currency;
  bool customerIsGuest;
  bool customerNoteNotify;
  int customerTaxClassId;
  int storeId;
  CartExtensionAttributes extensionAttributes;

  factory Cart.fromRawJson(String str) => Cart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"] == null ? null : json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isActive: json["is_active"] == null ? null : json["is_active"],
        isVirtual: json["is_virtual"] == null ? null : json["is_virtual"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        itemsCount: json["items_count"] == null ? null : json["items_count"],
        itemsQty: json["items_qty"] == null ? null : json["items_qty"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        billingAddress: json["billing_address"] == null
            ? null
            : Address.fromJson(json["billing_address"]),
        origOrderId:
            json["orig_order_id"] == null ? null : json["orig_order_id"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        customerIsGuest: json["customer_is_guest"] == null
            ? null
            : json["customer_is_guest"],
        customerNoteNotify: json["customer_note_notify"] == null
            ? null
            : json["customer_note_notify"],
        customerTaxClassId: json["customer_tax_class_id"] == null
            ? null
            : json["customer_tax_class_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : CartExtensionAttributes.fromJson(json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "is_active": isActive == null ? null : isActive,
        "is_virtual": isVirtual == null ? null : isVirtual,
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
        "items_count": itemsCount == null ? null : itemsCount,
        "items_qty": itemsQty == null ? null : itemsQty,
        "customer": customer == null ? null : customer.toJson(),
        "billing_address":
            billingAddress == null ? null : billingAddress.toJson(),
        "orig_order_id": origOrderId == null ? null : origOrderId,
        "currency": currency == null ? null : currency.toJson(),
        "customer_is_guest": customerIsGuest == null ? null : customerIsGuest,
        "customer_note_notify":
            customerNoteNotify == null ? null : customerNoteNotify,
        "customer_tax_class_id":
            customerTaxClassId == null ? null : customerTaxClassId,
        "store_id": storeId == null ? null : storeId,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes.toJson(),
      };
}

class Address {
  Address({
    this.id,
    this.region,
    this.regionId,
    this.regionCode,
    this.countryId,
    this.street,
    this.telephone,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.customerId,
    this.email,
    this.sameAsBilling,
    this.saveInAddressBook,
  });

  int id;
  dynamic region;
  dynamic regionId;
  dynamic regionCode;
  dynamic countryId;
  List<String> street;
  dynamic telephone;
  dynamic postcode;
  dynamic city;
  dynamic firstname;
  dynamic lastname;
  int customerId;
  String email;
  int sameAsBilling;
  int saveInAddressBook;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        region: json["region"],
        regionId: json["region_id"],
        regionCode: json["region_code"],
        countryId: json["country_id"],
        street: json["street"] == null
            ? null
            : List<String>.from(json["street"].map((x) => x)),
        telephone: json["telephone"],
        postcode: json["postcode"],
        city: json["city"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        email: json["email"] == null ? null : json["email"],
        sameAsBilling:
            json["same_as_billing"] == null ? null : json["same_as_billing"],
        saveInAddressBook: json["save_in_address_book"] == null
            ? null
            : json["save_in_address_book"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "region": region,
        "region_id": regionId,
        "region_code": regionCode,
        "country_id": countryId,
        "street":
            street == null ? null : List<dynamic>.from(street.map((x) => x)),
        "telephone": telephone,
        "postcode": postcode,
        "city": city,
        "firstname": firstname,
        "lastname": lastname,
        "customer_id": customerId == null ? null : customerId,
        "email": email == null ? null : email,
        "same_as_billing": sameAsBilling == null ? null : sameAsBilling,
        "save_in_address_book":
            saveInAddressBook == null ? null : saveInAddressBook,
      };
}

class Currency {
  Currency({
    this.globalCurrencyCode,
    this.baseCurrencyCode,
    this.storeCurrencyCode,
    this.quoteCurrencyCode,
    this.storeToBaseRate,
    this.storeToQuoteRate,
    this.baseToGlobalRate,
    this.baseToQuoteRate,
  });

  String globalCurrencyCode;
  String baseCurrencyCode;
  String storeCurrencyCode;
  String quoteCurrencyCode;
  int storeToBaseRate;
  int storeToQuoteRate;
  int baseToGlobalRate;
  int baseToQuoteRate;

  factory Currency.fromRawJson(String str) =>
      Currency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        globalCurrencyCode: json["global_currency_code"] == null
            ? null
            : json["global_currency_code"],
        baseCurrencyCode: json["base_currency_code"] == null
            ? null
            : json["base_currency_code"],
        storeCurrencyCode: json["store_currency_code"] == null
            ? null
            : json["store_currency_code"],
        quoteCurrencyCode: json["quote_currency_code"] == null
            ? null
            : json["quote_currency_code"],
        storeToBaseRate: json["store_to_base_rate"] == null
            ? null
            : json["store_to_base_rate"],
        storeToQuoteRate: json["store_to_quote_rate"] == null
            ? null
            : json["store_to_quote_rate"],
        baseToGlobalRate: json["base_to_global_rate"] == null
            ? null
            : json["base_to_global_rate"],
        baseToQuoteRate: json["base_to_quote_rate"] == null
            ? null
            : json["base_to_quote_rate"],
      );

  Map<String, dynamic> toJson() => {
        "global_currency_code":
            globalCurrencyCode == null ? null : globalCurrencyCode,
        "base_currency_code":
            baseCurrencyCode == null ? null : baseCurrencyCode,
        "store_currency_code":
            storeCurrencyCode == null ? null : storeCurrencyCode,
        "quote_currency_code":
            quoteCurrencyCode == null ? null : quoteCurrencyCode,
        "store_to_base_rate": storeToBaseRate == null ? null : storeToBaseRate,
        "store_to_quote_rate":
            storeToQuoteRate == null ? null : storeToQuoteRate,
        "base_to_global_rate":
            baseToGlobalRate == null ? null : baseToGlobalRate,
        "base_to_quote_rate": baseToQuoteRate == null ? null : baseToQuoteRate,
      };
}

class Customer {
  Customer({
    this.id,
    this.groupId,
    this.createdAt,
    this.updatedAt,
    this.createdIn,
    this.email,
    this.firstname,
    this.lastname,
    this.storeId,
    this.websiteId,
    this.addresses,
    this.disableAutoGroupChange,
    this.extensionAttributes,
  });

  int id;
  int groupId;
  DateTime createdAt;
  DateTime updatedAt;
  String createdIn;
  String email;
  String firstname;
  String lastname;
  int storeId;
  int websiteId;
  List<dynamic> addresses;
  int disableAutoGroupChange;
  CustomerExtensionAttributes extensionAttributes;

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"] == null ? null : json["id"],
        groupId: json["group_id"] == null ? null : json["group_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdIn: json["created_in"] == null ? null : json["created_in"],
        email: json["email"] == null ? null : json["email"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        websiteId: json["website_id"] == null ? null : json["website_id"],
        addresses: json["addresses"] == null
            ? null
            : List<dynamic>.from(json["addresses"].map((x) => x)),
        disableAutoGroupChange: json["disable_auto_group_change"] == null
            ? null
            : json["disable_auto_group_change"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : CustomerExtensionAttributes.fromJson(
                json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "group_id": groupId == null ? null : groupId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_in": createdIn == null ? null : createdIn,
        "email": email == null ? null : email,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "store_id": storeId == null ? null : storeId,
        "website_id": websiteId == null ? null : websiteId,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses.map((x) => x)),
        "disable_auto_group_change":
            disableAutoGroupChange == null ? null : disableAutoGroupChange,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes.toJson(),
      };
}

class CustomerExtensionAttributes {
  CustomerExtensionAttributes({
    this.isSubscribed,
  });

  bool isSubscribed;

  factory CustomerExtensionAttributes.fromRawJson(String str) =>
      CustomerExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      CustomerExtensionAttributes(
        isSubscribed:
            json["is_subscribed"] == null ? null : json["is_subscribed"],
      );

  Map<String, dynamic> toJson() => {
        "is_subscribed": isSubscribed == null ? null : isSubscribed,
      };
}

class CartExtensionAttributes {
  CartExtensionAttributes({
    this.shippingAssignments,
  });

  List<ShippingAssignment> shippingAssignments;

  factory CartExtensionAttributes.fromRawJson(String str) =>
      CartExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      CartExtensionAttributes(
        shippingAssignments: json["shipping_assignments"] == null
            ? null
            : List<ShippingAssignment>.from(json["shipping_assignments"]
                .map((x) => ShippingAssignment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping_assignments": shippingAssignments == null
            ? null
            : List<dynamic>.from(shippingAssignments.map((x) => x.toJson())),
      };
}

class ShippingAssignment {
  ShippingAssignment({
    this.shipping,
    this.items,
  });

  Shipping shipping;
  List<Item> items;

  factory ShippingAssignment.fromRawJson(String str) =>
      ShippingAssignment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingAssignment.fromJson(Map<String, dynamic> json) =>
      ShippingAssignment(
        shipping: json["shipping"] == null
            ? null
            : Shipping.fromJson(json["shipping"]),
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping": shipping == null ? null : shipping.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.itemId,
    this.sku,
    this.qty,
    this.name,
    this.price,
    this.productType,
    this.quoteId,
    this.extensionAttributes,
  });

  int itemId;
  String sku;
  int qty;
  String name;
  dynamic price;
  String productType;
  String quoteId;
  ItemExtensionAttributes extensionAttributes;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"] == null ? null : json["item_id"],
        sku: json["sku"] == null ? null : json["sku"],
        qty: json["qty"] == null ? null : json["qty"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        productType: json["product_type"] == null ? null : json["product_type"],
        quoteId: json["quote_id"] == null ? null : json["quote_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ItemExtensionAttributes.fromJson(json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "sku": sku == null ? null : sku,
        "qty": qty == null ? null : qty,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "product_type": productType == null ? null : productType,
        "quote_id": quoteId == null ? null : quoteId,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes.toJson(),
      };
}

class ItemExtensionAttributes {
  ItemExtensionAttributes({
    this.imageUrl,
    this.priceIncludingTax,
    this.itemName,
    this.configurableOptions,
    this.isInStock,
  });

  String imageUrl;
  String itemName;
  dynamic priceIncludingTax;
  List<ConfigurableOption> configurableOptions;
  bool isInStock;

  factory ItemExtensionAttributes.fromRawJson(String str) =>
      ItemExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ItemExtensionAttributes(
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        priceIncludingTax: json["price_including_tax"] == null
            ? null
            : json["price_including_tax"],
        itemName: json["item_name"],
        configurableOptions: json["configurable_options"] == null
            ? null
            : List<ConfigurableOption>.from(json["configurable_options"]
                .map((x) => ConfigurableOption.fromJson(x))),
        isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl == null ? null : imageUrl,
        "configurable_options": configurableOptions == null
            ? null
            : List<dynamic>.from(configurableOptions.map((x) => x.toJson())),
      };
}

class ConfigurableOption {
  ConfigurableOption({
    this.optionName,
    this.optionLabel,
  });

  String optionName;
  String optionLabel;

  factory ConfigurableOption.fromRawJson(String str) =>
      ConfigurableOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableOption.fromJson(Map<String, dynamic> json) =>
      ConfigurableOption(
        optionName: json["option_name"] == null ? null : json["option_name"],
        optionLabel: json["option_label"] == null ? null : json["option_label"],
      );

  Map<String, dynamic> toJson() => {
        "option_name": optionName == null ? null : optionName,
        "option_label": optionLabel == null ? null : optionLabel,
      };
}

class Shipping {
  Shipping({
    this.address,
    this.method,
  });

  Address address;
  dynamic method;

  factory Shipping.fromRawJson(String str) =>
      Shipping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address.toJson(),
        "method": method,
      };
}
