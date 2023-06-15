// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

class AddressModel {
  AddressModel({
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

  factory AddressModel.fromRawJson(String str) => AddressModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
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
