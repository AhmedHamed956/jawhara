import 'dart:convert';

import 'package:jawhara/model/products/product.dart';

class Home {
  Home({
    this.data,
  });

  List<HomeDatum> data;

  factory Home.fromRawJson(String str) => Home.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Home.fromJson(Map<String, dynamic> json) => Home(
    data: List<HomeDatum>.from(json["data"].map((x) => HomeDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HomeDatum {
  HomeDatum({
    this.blockType,
    this.data,
    this.dataProducts,
  });

  String blockType;
  List<DatumDatum> data;
  List<Product> dataProducts;

  factory HomeDatum.fromRawJson(String str) => HomeDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeDatum.fromJson(Map<String, dynamic> json) => HomeDatum(
    blockType: json["block_type"],
    data: json["data"] == null ? null : List<DatumDatum>.from(json["data"].map((x) => DatumDatum.fromJson(x))),
    dataProducts: json["data_products"] == null ? null : List<Product>.from(json["data_products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "block_type": blockType,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "data_products": dataProducts == null ? null : List<dynamic>.from(dataProducts.map((x) => x.toJson())),
  };
}

class DatumDatum {
  DatumDatum({
    this.bannerImage,
    this.linkId,
    this.linkName,
    this.urlPath,
    this.linkType,
    this.id,
    this.name,
    this.image,
    this.level,
    this.parentId,
  });

  String bannerImage;
  String linkId;
  String linkName;
  String urlPath;
  String linkType;
  String id;
  String name;
  String image;
  String level;
  String parentId;

  factory DatumDatum.fromRawJson(String str) => DatumDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumDatum.fromJson(Map<String, dynamic> json) => DatumDatum(
    bannerImage: json["banner_image"] == null ? null : json["banner_image"],
    linkId: json["link_id"] == null ? null : json["link_id"],
    linkName: json["link_name"] == null ? null : json["link_name"],
    urlPath: json["url_path"] == null ? null : json["url_path"],
    linkType: json["link_type"] == null ? null : json["link_type"],
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    level: json["level"] == null ? null : json["level"].toString(),
    parentId: json["parent_id"] == null ? null : json["parent_id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "banner_image": bannerImage == null ? null : bannerImage,
    "link_id": linkId == null ? null : linkId,
    "link_name": linkName == null ? null : linkName,
    "url_path": urlPath == null ? null : urlPath,
    "link_type": linkType == null ? null : linkType,
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "level": level == null ? null : level,
    "parent_id": parentId == null ? null : parentId,
  };
}