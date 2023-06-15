import 'dart:convert';

class CitiesDeliveryInfoModel {
  CitiesDeliveryInfoModel({
    this.citiesDeliveryItems,
  });

  List<CityDeliveryInfoItem> citiesDeliveryItems;

  factory CitiesDeliveryInfoModel.fromRawJson(String str) =>
      CitiesDeliveryInfoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CitiesDeliveryInfoModel.fromJson(Map<String, dynamic> json) =>
      CitiesDeliveryInfoModel(
        citiesDeliveryItems: json["cities"] == null
            ? null
            : List<CityDeliveryInfoItem>.from(
                json["cities"].map((x) => CityDeliveryInfoItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cities": citiesDeliveryItems == null
            ? null
            : List<dynamic>.from(citiesDeliveryItems.map((x) => x.toJson())),
      };
}

class CityDeliveryInfoItem {
  CityDeliveryInfoItem({
    this.id,
    this.name,
    this.message,
  });

  String id;
  String name;
  String message;

  factory CityDeliveryInfoItem.fromRawJson(String str) =>
      CityDeliveryInfoItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CityDeliveryInfoItem.fromJson(Map<String, dynamic> json) =>
      CityDeliveryInfoItem(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "message": message == null ? null : message,
      };
}
