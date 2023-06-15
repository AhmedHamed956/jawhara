// To parse this JSON data, do
//
//     final addComment = addCommentFromJson(jsonString);

import 'dart:convert';

class AddComment {
  AddComment({
    this.review,
  });

  ReviewComment review;

  factory AddComment.fromRawJson(String str) => AddComment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddComment.fromJson(Map<String, dynamic> json) => AddComment(
    review: ReviewComment.fromJson(json["review"]),
  );

  Map<String, dynamic> toJson() => {
    "review": review.toJson(),
  };
}

class ReviewComment {
  ReviewComment({
    this.title,
    this.detail,
    this.nickname,
    this.ratings,
    this.reviewEntity,
    this.entityPkValue,
  });

  String title;
  String detail;
  String nickname;
  List<Rating> ratings;
  String reviewEntity;
  int entityPkValue;

  factory ReviewComment.fromRawJson(String str) => ReviewComment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewComment.fromJson(Map<String, dynamic> json) => ReviewComment(
    title: json["title"],
    detail: json["detail"],
    nickname: json["nickname"],
    ratings: List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
    reviewEntity: json["review_entity"],
    entityPkValue: json["entity_pk_value"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "detail": detail,
    "nickname": nickname,
    "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
    "review_entity": reviewEntity,
    "entity_pk_value": entityPkValue,
  };
}

class Rating {
  Rating({
    this.ratingName,
    this.value,
  });

  String ratingName;
  int value;

  factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    ratingName: json["rating_name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "rating_name": ratingName,
    "value": value,
  };
}
