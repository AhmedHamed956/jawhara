// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

class CityModel {
  CityModel({
    this.availableCities,
  });

  List<AvailableCity> availableCities;

  factory CityModel.fromRawJson(String str) => CityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    availableCities: json["available_cities"] == null ? null : List<AvailableCity>.from(json["available_cities"].map((x) => AvailableCity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "available_cities": availableCities == null ? null : List<dynamic>.from(availableCities.map((x) => x.toJson())),
  };
}

class AvailableCity {
  AvailableCity({
    this.entityId,
    this.statesName,
    this.citiesName,
  });

  String entityId;
  StatesName statesName;
  String citiesName;

  factory AvailableCity.fromRawJson(String str) => AvailableCity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableCity.fromJson(Map<String, dynamic> json) => AvailableCity(
    entityId: json["entity_id"] == null ? null : json["entity_id"],
    statesName: json["states_name"] == null ? null : statesNameValues.map[json["states_name"]],
    citiesName: json["cities_name"] == null ? null : json["cities_name"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId == null ? null : entityId,
    "states_name": statesName == null ? null : statesNameValues.reverse[statesName],
    "cities_name": citiesName == null ? null : citiesName,
  };
}

enum StatesName { SAUDI_ARABIA }

final statesNameValues = EnumValues({
  "Saudi Arabia": StatesName.SAUDI_ARABIA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
