// To parse this JSON data, do
//
//     final searchProductItem = searchProductItemFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/model/products/product.dart';

class SearchProductItem {
  SearchProductItem({
    this.items,
    this.totalCount,
  });

  List<SearchProdItem> items;
  int totalCount;

  factory SearchProductItem.fromRawJson(String str) =>
      SearchProductItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchProductItem.fromJson(Map<String, dynamic> json) =>
      SearchProductItem(
        items: List<SearchProdItem>.from(
            json["items"].map((x) => SearchProdItem.fromJson(x))),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total_count": totalCount,
      };
}

class SearchProdItem {
  SearchProdItem({
    this.id,
    this.sku,
    this.name,
    this.attributeSetId,
    this.price,
    this.specialPrice,
    this.specialFromDate,
    this.status,
    this.visibility,
    this.typeId,
    this.createdAt,
    this.updatedAt,
    this.productLinks,
    this.options,
    this.mediaGalleryEntries,
    this.tierPrices,
  });

  int id;
  String sku;
  String name;
  int attributeSetId;
  double price;
  double specialPrice;
  String specialFromDate;
  int status;
  int visibility;
  String typeId;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> productLinks;
  List<dynamic> options;
  List<MediaGalleryEntry> mediaGalleryEntries;
  List<dynamic> tierPrices;

  factory SearchProdItem.fromRawJson(String str) =>
      SearchProdItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchProdItem.fromJson(Map<String, dynamic> json) => SearchProdItem(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        attributeSetId: json["attribute_set_id"],
        price: double.tryParse(json["price"].toString()),
        specialPrice: json["custom_attributes"] != null
            ? double.tryParse(json["custom_attributes"].firstWhere(
                (item) => item["attribute_code"] == 'special_price',
                orElse: () => {"value": null})["value"] ?? "")
            : null,
        specialFromDate: json["custom_attributes"] != null
            ? json["custom_attributes"].firstWhere(
                (item) => item["attribute_code"] == 'special_from_date',
                orElse: () => {"value": null})["value"]
            : null,
        status: json["status"],
        visibility: json["visibility"],
        typeId: json["type_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productLinks: List<dynamic>.from(json["product_links"].map((x) => x)),
        options: List<dynamic>.from(json["options"].map((x) => x)),
        mediaGalleryEntries: List<MediaGalleryEntry>.from(
            json["media_gallery_entries"]
                .map((x) => MediaGalleryEntry.fromJson(x))),
        tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "name": name,
        "attribute_set_id": attributeSetId,
        "price": price,
        "status": status,
        "visibility": visibility,
        "type_id": typeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_links": List<dynamic>.from(productLinks.map((x) => x)),
        "options": List<dynamic>.from(options.map((x) => x)),
        "media_gallery_entries":
            List<dynamic>.from(mediaGalleryEntries.map((x) => x.toJson())),
        "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
      };

  Product toProduct() {
    return Product(
      entityId: id.toString(),
      sku: sku,
      name: name,
      attributeSetId: attributeSetId.toString(),
      price: price.toString(),
      specialPrice: specialPrice.toString(),
      specialFromDate: DateTime.tryParse(specialFromDate ?? ""),
      typeId: typeId,
      smallImage: (mediaGalleryEntries != null && mediaGalleryEntries.isNotEmpty) ? mediaGalleryEntries[0].file : "",
    );
  }
}

class MediaGalleryEntry {
  MediaGalleryEntry({
    this.file,
  });

  String file;

  factory MediaGalleryEntry.fromRawJson(String str) =>
      MediaGalleryEntry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) =>
      MediaGalleryEntry(
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
      };
}
