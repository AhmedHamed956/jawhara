// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

class Reviews {
  Reviews({
    this.data,
    this.ratings,
  });

  List<Datum> data;
  double ratings;

  factory Reviews.fromRawJson(String str) => Reviews.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    data: json["data"] == null || json["data"].isEmpty ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    ratings: json["averageratings"] == null ? null : json["averageratings"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "ratings": ratings == null ? null : ratings,
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.detail,
    this.nickname,
    this.reviewEntity,
    this.reviewType,
    this.reviewStatus,
    this.productId,
    this.createdAt,
    this.storeId,
    this.rate,
  });

  String id;
  String title;
  String detail;
  String nickname;
  String reviewEntity;
  int reviewType;
  String reviewStatus;
  String productId;
  DateTime createdAt;
  int storeId;
  String rate;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    detail: json["detail"] == null ? null : json["detail"],
    nickname: json["nickname"] == null ? null : json["nickname"],
    reviewEntity: json["review_entity"] == null ? null : json["review_entity"],
    reviewType: json["review_type"] == null ? null : json["review_type"],
    reviewStatus: json["review_status"] == null ? null : json["review_status"],
    productId: json["product_id"] == null ? null : json["product_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    storeId: json["store_id"] == null ? null : json["store_id"],
    rate: (json["ratings"] == null || json["ratings"].isEmpty || json["ratings"]["value"] == null) ? null : json["ratings"]["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "detail": detail == null ? null : detail,
    "nickname": nickname == null ? null : nickname,
    "review_entity": reviewEntity == null ? null : reviewEntity,
    "review_type": reviewType == null ? null : reviewType,
    "review_status": reviewStatus == null ? null : reviewStatus,
    "product_id": productId == null ? null : productId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "store_id": storeId == null ? null : storeId,
  };
}
