// To parse this JSON data, do
//
//     final returnDetails = returnDetailsFromJson(jsonString);

import 'dart:convert';

class ReturnDetails {
  ReturnDetails({
    this.data,
  });

  Data data;

  factory ReturnDetails.fromRawJson(String str) => ReturnDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReturnDetails.fromJson(Map<String, dynamic> json) => ReturnDetails(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.entityId,
    this.returnId,
    this.orderId,
    this.dateRequested,
    this.email,
    this.customerCustomEmail,
    this.shippingAddress,
    this.items,
    this.status,
    this.comments,
  });

  String entityId;
  String returnId;
  String orderId;
  DateTime dateRequested;
  dynamic email;
  dynamic customerCustomEmail;
  String shippingAddress;
  List<Item> items;
  String status;
  List<Comment> comments;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    entityId: json["entity_id"],
    returnId: json["return_id"],
    orderId: json["order_id"],
    dateRequested: DateTime.parse(json["date_requested"]),
    email: json["email"],
    customerCustomEmail: json["customer_custom_email"],
    shippingAddress: json["shipping_address"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    status: json["status"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId,
    "return_id": returnId,
    "order_id": orderId,
    "date_requested": dateRequested.toIso8601String(),
    "email": email,
    "customer_custom_email": customerCustomEmail,
    "shipping_address": shippingAddress,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "status": status,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.entityId,
    this.rmaEntityId,
    this.isCustomerNotified,
    this.isVisibleOnFront,
    this.comment,
    this.status,
    this.createdAt,
    this.isAdmin,
  });

  String entityId;
  String rmaEntityId;
  String isCustomerNotified;
  String isVisibleOnFront;
  String comment;
  String status;
  DateTime createdAt;
  String isAdmin;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    entityId: json["entity_id"],
    rmaEntityId: json["rma_entity_id"],
    isCustomerNotified: json["is_customer_notified"] == null ? null : json["is_customer_notified"],
    isVisibleOnFront: json["is_visible_on_front"],
    comment: json["comment"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    isAdmin: json["is_admin"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId,
    "rma_entity_id": rmaEntityId,
    "is_customer_notified": isCustomerNotified == null ? null : isCustomerNotified,
    "is_visible_on_front": isVisibleOnFront,
    "comment": comment,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "is_admin": isAdmin,
  };
}

class Item {
  Item({
    this.name,
    this.sku,
    this.qtyRequested,
    this.qtyAuthorized,
    this.qtyReturned,
    this.qtyApproved,
    this.reason,
    this.condition,
    this.resolution,
    this.status,
  });

  String name;
  String sku;
  String qtyRequested;
  dynamic qtyAuthorized;
  dynamic qtyReturned;
  dynamic qtyApproved;
  String reason;
  String condition;
  String resolution;
  String status;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"],
    sku: json["sku"],
    qtyRequested: json["qty_requested"],
    qtyAuthorized: json["qty_authorized"],
    qtyReturned: json["qty_returned"],
    qtyApproved: json["qty_approved"],
    reason: json["reason"],
    condition: json["condition"],
    resolution: json["resolution"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sku": sku,
    "qty_requested": qtyRequested,
    "qty_authorized": qtyAuthorized,
    "qty_returned": qtyReturned,
    "qty_approved": qtyApproved,
    "reason": reason,
    "condition": condition,
    "resolution": resolution,
    "status": status,
  };
}
