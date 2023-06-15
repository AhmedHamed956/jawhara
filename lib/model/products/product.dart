// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

class Product {
  Product({
    this.entityId,
    this.attributeSetId,
    this.typeId,
    this.sku,
    this.status,
    this.name,
    this.smallImage,
    this.thumbnail,
    this.baseImageURL,
    this.categoryListImageURL,
    this.smallImageURL,
    this.thumbnailImageURL,
    this.price,
    this.specialPrice,
    this.productNew,
    this.sale,
    this.specialFromDate,
    this.selected = true,
    this.ratings,
  });

  String entityId;
  String attributeSetId;
  String typeId;
  String sku;
  String status;
  String name;
  String smallImage;
  String thumbnail;
  String baseImageURL;
  String categoryListImageURL;
  String smallImageURL;
  String thumbnailImageURL;
  String price;
  dynamic specialPrice;
  String productNew;
  String sale;
  DateTime specialFromDate;
  bool selected;
  Ratings ratings;

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      entityId: json["entity_id"] == null ? null : json["entity_id"],
      attributeSetId: json["attribute_set_id"] == null ? null : json["attribute_set_id"].toString(),
      typeId: json["type_id"] == null ? null : json["type_id"],
      sku: json["sku"] == null ? null : json["sku"],
      status: json["status"] == null ? null : json["status"].toString(),
      name: json["name"] == null ? null : json["name"],
      smallImage: json["small_image"] == null ? null : json["small_image"],
      thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      baseImageURL: json["base_image_url"] == null ? null : json["base_image_url"],
      categoryListImageURL: json["category_list_image_url"] == null ? null : json["category_list_image_url"],
      smallImageURL: json["small_image_url"] == null ? null : json["small_image_url"],
      thumbnailImageURL: json["thumbnail_url"] == null ? null : json["thumbnail_url"],
      price: json["price"] == null ? null : json["price"].toString(),
      specialPrice: json["special_price"],
      productNew: json["new"] == null ? null : json["new"],
      sale: json["sale"] == null ? null : json["sale"],
      specialFromDate: json["special_from_date"] == null ? null : DateTime.parse(json["special_from_date"]),
      ratings: json["ratings"] == null
          ? null
          : json["ratings"].isEmpty
              ? null
              : Ratings.fromJson(json["ratings"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "attribute_set_id": attributeSetId == null ? null : attributeSetId,
        "type_id": typeId == null ? null : typeId,
        "sku": sku == null ? null : sku,
        "status": status == null ? null : status,
        "name": name == null ? null : name,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "base_image_url": baseImageURL == null ? null : baseImageURL,
        "small_image": smallImage == null ? null : smallImage,
        "small_image_url": smallImageURL == null ? null : smallImageURL,
        "price": price == null ? null : price,
        "special_price": specialPrice,
        "new": productNew == null ? null : productNew,
        "sale": sale == null ? null : sale,
        "special_from_date": specialFromDate == null ? null : specialFromDate,
        "ratings": ratings.toJson(),
      };
}

class Ratings {
  Ratings({
    this.averageratings,
    this.averagepercentage,
  });

  int averageratings;
  int averagepercentage;

  factory Ratings.fromRawJson(String str) => Ratings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
        averageratings: json["averageratings"],
        averagepercentage: json["averagepercentage"],
      );

  Map<String, dynamic> toJson() => {
        "averageratings": averageratings,
        "averagepercentage": averagepercentage,
      };
}
