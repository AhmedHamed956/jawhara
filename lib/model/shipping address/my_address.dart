// To parse this JSON data, do
//
//     final myAddress = myAddressFromJson(jsonString);

import 'dart:convert';

class MyAddress {
  MyAddress({
    this.id,
    this.groupId,
    this.defaultBilling,
    this.defaultShipping,
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
    this.customAttributes,
  });

  int id;
  int groupId;
  String defaultBilling;
  String defaultShipping;
  DateTime createdAt;
  DateTime updatedAt;
  String createdIn;
  String email;
  String firstname;
  String lastname;
  int storeId;
  int websiteId;
  List<Address> addresses;
  int disableAutoGroupChange;
  ExtensionAttributes extensionAttributes;
  List<CustomAttribute> customAttributes;


  factory MyAddress.fromRawJson(String str) => MyAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyAddress.fromJson(Map<String, dynamic> json) => MyAddress(
    id: json["id"] == null ? null : json["id"],
    groupId: json["group_id"] == null ? null : json["group_id"],
    defaultBilling: json["default_billing"] == null ? null : json["default_billing"],
    defaultShipping: json["default_shipping"] == null ? null : json["default_shipping"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdIn: json["created_in"] == null ? null : json["created_in"],
    email: json["email"] == null ? null : json["email"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    websiteId: json["website_id"] == null ? null : json["website_id"],
    addresses: json["addresses"] == null ? null : List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    disableAutoGroupChange: json["disable_auto_group_change"] == null ? null : json["disable_auto_group_change"],
    extensionAttributes: json["extension_attributes"] == null ? null : ExtensionAttributes.fromJson(json["extension_attributes"]),
    customAttributes:json["custom_attributes"] == null ? null :  List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "group_id": groupId == null ? null : groupId,
    "default_billing": defaultBilling == null ? null : defaultBilling,
    "default_shipping": defaultShipping == null ? null : defaultShipping,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "created_in": createdIn == null ? null : createdIn,
    "email": email == null ? null : email,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "store_id": storeId == null ? null : storeId,
    "website_id": websiteId == null ? null : websiteId,
    "addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
    "disable_auto_group_change": disableAutoGroupChange == null ? null : disableAutoGroupChange,
    "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
    "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x.toJson())),
  };
}

class Address {
  Address({
    this.id,
    this.customerId,
    this.region,
    this.regionId,
    this.countryId,
    this.street,
    this.telephone,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.customAttributes,
    this.defaultShipping,
    this.defaultBilling,
  });

  int id;
  int customerId;
  Region region;
  int regionId;
  String countryId;
  List<String> street;
  String telephone;
  String postcode;
  String city;
  String firstname;
  String lastname;
  List<CustomAttribute> customAttributes;
  bool defaultShipping;
  bool defaultBilling;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] == null ? null : json["id"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    region: json["region"] == null ? null : Region.fromJson(json["region"]),
    regionId: json["region_id"] == null ? null : json["region_id"],
    countryId: json["country_id"] == null ? null : json["country_id"],
    street: json["street"] == null ? null : List<String>.from(json["street"].map((x) => x)),
    telephone: json["telephone"] == null ? null : json["telephone"],
    postcode: json["postcode"] == null ? null : json["postcode"],
    city: json["city"] == null ? null : json["city"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    customAttributes: json["custom_attributes"] == null ? null : List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
    defaultShipping: json["default_shipping"] == null ? null : json["default_shipping"],
    defaultBilling: json["default_billing"] == null ? null : json["default_billing"],
  );

  Address copyWith({
    int id,
    int customerId,
    Region region,
    int regionId,
    String countryId,
    List<String> street,
    String telephone,
    String postcode,
    String city,
    String firstname,
    String lastname,
    List<CustomAttribute> customAttributes,
    bool defaultShipping,
    bool defaultBilling,
  }) =>
      Address(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        region: region ?? this.region,
        regionId: regionId ?? this.regionId,
        countryId: countryId ?? this.countryId,
        street: street ?? this.street,
        telephone: telephone ?? this.telephone,
        postcode: postcode ?? this.postcode,
        city: city ?? this.city,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        customAttributes: customAttributes ?? this.customAttributes,
        defaultShipping: defaultShipping ?? this.defaultShipping,
        defaultBilling: defaultBilling ?? this.defaultBilling,
      );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customer_id": customerId == null ? null : customerId,
    "region": region == null ? null : region.toJson(),
    "region_id": regionId == null ? null : regionId,
    "country_id": countryId == null ? null : countryId,
    "street": street == null ? null : List<dynamic>.from(street.map((x) => x)),
    "telephone": telephone == null ? null : telephone,
    "postcode": postcode == null ? null : postcode,
    "city": city == null ? null : city,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "custom_attributes": customAttributes == null ? null : List<dynamic>.from(customAttributes.map((x) => x.toJson())),
    "default_shipping": defaultShipping == null ? null : defaultShipping,
    "default_billing": defaultBilling == null ? null : defaultBilling,
  };
}
class CustomAttribute {
  CustomAttribute({
    this.attributeCode,
    this.value,
  });

  String attributeCode;
  String value;

  factory CustomAttribute.fromRawJson(String str) => CustomAttribute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomAttribute.fromJson(Map<String, dynamic> json) => CustomAttribute(
    attributeCode: json["attribute_code"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "attribute_code": attributeCode,
    "value": value,
  };
}

class Region {
  Region({
    this.regionCode,
    this.region,
    this.regionId,
  });

  String regionCode;
  String region;
  int regionId;

  factory Region.fromRawJson(String str) => Region.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    regionCode: json["region_code"] == null ? null : json["region_code"],
    region: json["region"] == null ? null : json["region"],
    regionId: json["region_id"] == null ? null : json["region_id"],
  );

  Map<String, dynamic> toJson() => {
    "region_code": regionCode == null ? null : regionCode,
    "region": region == null ? null : region,
    "region_id": regionId == null ? null : regionId,
  };
}

class ExtensionAttributes {
  ExtensionAttributes({
    this.isSubscribed,
  });

  bool isSubscribed;

  factory ExtensionAttributes.fromRawJson(String str) => ExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes(
    isSubscribed: json["is_subscribed"] == null ? null : json["is_subscribed"],
  );

  Map<String, dynamic> toJson() => {
    "is_subscribed": isSubscribed == null ? null : isSubscribed,
  };
}
