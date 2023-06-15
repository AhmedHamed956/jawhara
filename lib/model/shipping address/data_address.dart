// // To parse this JSON data, do
// //
// //     final dataAddress = dataAddressFromJson(jsonString);
//
// import 'dart:convert';
//
// class DataAddress {
//   DataAddress({
//     this.address,
//   });
//
//   Address address;
//
//   Map<String, dynamic> toJson() => {
//     "address": address == null ? null : address.toJson(),
//   };
// }
//
// class Address {
//   Address({
//     this.customerId,
//     this.region,
//     this.countryId,
//     this.street,
//     this.firstname,
//     this.lastname,
//     this.defaultShipping,
//     this.defaultBilling,
//     this.telephone,
//     this.postcode,
//     this.city,
//   });
//
//   int customerId;
//   Region region;
//   String countryId;
//   List<String> street;
//   String firstname;
//   String lastname;
//   bool defaultShipping;
//   bool defaultBilling;
//   String telephone;
//   String postcode;
//   String city;
//
//
//   Map<String, dynamic> toJson() => {
//     "customer_id": customerId == null ? null : customerId,
//     "region": region == null ? null : region.toJson(),
//     "country_id": countryId == null ? null : countryId,
//     "street": street == null ? null : List<dynamic>.from(street.map((x) => x)),
//     "firstname": firstname == null ? null : firstname,
//     "lastname": lastname == null ? null : lastname,
//     "default_shipping": defaultShipping == null ? null : defaultShipping,
//     "default_billing": defaultBilling == null ? null : defaultBilling,
//     "telephone": telephone == null ? null : telephone,
//     "postcode": postcode == null ? null : postcode,
//     "city": city == null ? null : city,
//   };
// }
//
// class Region {
//   Region({
//     this.regionCode,
//     this.region,
//     this.regionId,
//   });
//
//   String regionCode;
//   String region;
//   int regionId;
//
//   factory Region.fromRawJson(String str) => Region.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Region.fromJson(Map<String, dynamic> json) => Region(
//     regionCode: json["region_code"] == null ? null : json["region_code"],
//     region: json["region"] == null ? null : json["region"],
//     regionId: json["region_id"] == null ? null : json["region_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "region_code": regionCode == null ? null : regionCode,
//     "region": region == null ? null : region,
//     "region_id": regionId == null ? null : regionId,
//   };
// }
