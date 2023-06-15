// To parse this JSON data, do
//
//     final commentResponse = commentResponseFromJson(jsonString);

import 'dart:convert';

class CommentResponse {
  CommentResponse({
    this.items,
  });

  Items items;

  factory CommentResponse.fromRawJson(String str) => CommentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentResponse.fromJson(Map<String, dynamic> json) => CommentResponse(
    items: Items.fromJson(json["items"]),
  );

  Map<String, dynamic> toJson() => {
    "items": items.toJson(),
  };
}

class Items {
  Items({
    this.response,
    this.message,
  });

  bool response;
  String message;

  factory Items.fromRawJson(String str) => Items.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    response: json["response"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "message": message,
  };
}
