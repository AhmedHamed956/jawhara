// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/model/products/product.dart';

class WishListModel {
  WishListModel({
    this.items,
  });

  List<ItemWish> items;

  factory WishListModel.fromRawJson(String str) => WishListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    items: List<ItemWish>.from(json["items"].map((x) => ItemWish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ItemWish {
  ItemWish({
    this.wishlistItemId,
    this.wishlistId,
    this.productId,
    this.storeId,
    this.addedAt,
    this.description,
    this.qty,
    this.product,
  });

  String wishlistItemId;
  String wishlistId;
  String productId;
  String storeId;
  DateTime addedAt;
  dynamic description;
  int qty;
  Product product;

  factory ItemWish.fromRawJson(String str) => ItemWish.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemWish.fromJson(Map<String, dynamic> json) => ItemWish(
    wishlistItemId: json["wishlist_item_id"],
    wishlistId: json["wishlist_id"],
    productId: json["product_id"],
    storeId: json["store_id"],
    addedAt: DateTime.parse(json["added_at"]),
    description: json["description"],
    qty: json["qty"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "wishlist_item_id": wishlistItemId,
    "wishlist_id": wishlistId,
    "product_id": productId,
    "store_id": storeId,
    "added_at": addedAt.toIso8601String(),
    "description": description,
    "qty": qty,
    "product": product.toJson(),
  };
}

