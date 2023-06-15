import 'dart:convert';
import 'package:jawhara/model/products/product.dart';

class Categories {
  Categories({
    this.id,
    this.parentId,
    this.name,
    this.image,
    this.isActive,
    this.position,
    this.level,
    this.productCount,
    this.linkedProducts,
    this.childrenData,
  });

  int id;
  int parentId;
  String name;
  dynamic image;
  bool isActive;
  int position;
  int level;
  int productCount;
  List<Product> linkedProducts;
  List<CategoriesChildrenDatum> childrenData;

  factory Categories.fromRawJson(String str) => Categories.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        parentId: json["parent_id"],
        name: json["name"],
        image: json["image"],
        isActive: json["is_active"],
        position: json["position"],
        level: json["level"],
        productCount: json["product_count"],
        linkedProducts: List<Product>.from((json["linked_products"] ?? []).map((x) => Product.fromJson(x))),
        childrenData: List<CategoriesChildrenDatum>.from(json["children_data"].map((x) => CategoriesChildrenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "image": image,
        "is_active": isActive,
        "position": position,
        "level": level,
        "product_count": productCount,
        "linked_products": List<dynamic>.from(linkedProducts.map((x) => x.toJson())),
        "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
      };
}

class CategoriesChildrenDatum {
  CategoriesChildrenDatum({
    this.id,
    this.parentId,
    this.name,
    this.image,
    this.thumbnail,
    this.isActive,
    this.position,
    this.level,
    this.productCount,
    this.linkedProducts,
    this.childrenData,
  });

  CategoriesChildrenDatum copyWith({
    int id,
    int parentId,
    String name,
    String image,
    String thumbnail,
    bool isActive,
    int position,
    int level,
    int productCount,
    List<Product> linkedProducts,
    List<CategoriesChildrenDatum> childrenData,
  }) =>
      CategoriesChildrenDatum(
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        name: name ?? this.name,
        image: image ?? this.image,
        thumbnail: thumbnail ?? this.thumbnail,
        isActive: isActive ?? this.isActive,
        position: position ?? this.position,
        level: level ?? this.level,
        productCount: productCount ?? this.productCount,
        linkedProducts: linkedProducts ?? this.linkedProducts,
        childrenData: childrenData ?? this.childrenData,
      );
  int id;
  int parentId;
  String name;
  String image;
  String thumbnail;
  bool isActive;
  int position;
  int level;
  int productCount;
  List<Product> linkedProducts;
  List<CategoriesChildrenDatum> childrenData;

  factory CategoriesChildrenDatum.fromRawJson(String str) => CategoriesChildrenDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesChildrenDatum.fromJson(Map<String, dynamic> json) => CategoriesChildrenDatum(
        id: json["id"],
        parentId: json["parent_id"],
        name: json["name"],
        image: json["image"] == null ? null : json["image"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        isActive: json["is_active"],
        position: json["position"],
        level: json["level"],
        productCount: json["product_count"],
        linkedProducts: List<Product>.from((json["linked_products"] ?? []).map((x) => Product.fromJson(x))),
        childrenData: List<CategoriesChildrenDatum>.from(json["children_data"].map((x) => CategoriesChildrenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "image": image == null ? null : image,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "is_active": isActive,
        "position": position,
        "level": level,
        "product_count": productCount,
        "linked_products": List<dynamic>.from(linkedProducts.map((x) => x.toJson())),
        "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
      };
}
class CategoriesChildrenDatum2 {
  CategoriesChildrenDatum2({
    this.id,
    this.parentId,
    this.name,
    this.image,
    this.thumbnail,
    this.isActive,
    this.position,
    this.level,
    this.productCount,
    this.linkedProducts,
    this.childrenData,
  });

  int id;
  int parentId;
  String name;
  String image;
  String thumbnail;
  bool isActive;
  int position;
  int level;
  int productCount;
  List<Product> linkedProducts;
  List<CategoriesChildrenDatum> childrenData;

  factory CategoriesChildrenDatum2.fromRawJson(String str) => CategoriesChildrenDatum2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesChildrenDatum2.fromJson(Map<String, dynamic> json) => CategoriesChildrenDatum2(
    id: json["id"],
    parentId: json["parent_id"],
    name: json["name"],
    image: json["image"] == null ? null : json["image"],
    thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
    isActive: json["is_active"],
    position: json["position"],
    level: json["level"],
    productCount: json["product_count"],
    linkedProducts: List<Product>.from((json["linked_products"] ?? []).map((x) => Product.fromJson(x))),
    childrenData: List<CategoriesChildrenDatum>.from(json["children_data"].map((x) => CategoriesChildrenDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "name": name,
    "image": image == null ? null : image,
    "thumbnail": thumbnail == null ? null : thumbnail,
    "is_active": isActive,
    "position": position,
    "level": level,
    "product_count": productCount,
    "linked_products": List<dynamic>.from(linkedProducts.map((x) => x.toJson())),
    "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
  };
}
