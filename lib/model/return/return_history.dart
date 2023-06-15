// To parse this JSON data, do
//
//     final returnHistory = returnHistoryFromJson(jsonString);

import 'dart:convert';

class ReturnHistory {
  ReturnHistory({
    this.items,
  });

  List<ReturnItem> items;

  factory ReturnHistory.fromRawJson(String str) => ReturnHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReturnHistory.fromJson(Map<String, dynamic> json) => ReturnHistory(
    items: List<ReturnItem>.from(json["items"].map((x) => ReturnItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ReturnItem {
  ReturnItem({
    this.entityId,
    this.status,
    this.incrementId,
    this.dateRequested,
    this.orderId,
    this.orderIncrementId,
    this.orderDate,
    this.storeId,
    this.customerId,
    this.customerName,
  });

  String entityId;
  String status;
  String incrementId;
  DateTime dateRequested;
  String orderId;
  String orderIncrementId;
  DateTime orderDate;
  String storeId;
  String customerId;
  String customerName;

  factory ReturnItem.fromRawJson(String str) => ReturnItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReturnItem.fromJson(Map<String, dynamic> json) => ReturnItem(
    entityId: json["entity_id"],
    status: json["status"],
    incrementId: json["increment_id"],
    dateRequested: DateTime.parse(json["date_requested"]),
    orderId: json["order_id"],
    orderIncrementId: json["order_increment_id"],
    orderDate: DateTime.parse(json["order_date"]),
    storeId: json["store_id"],
    customerId: json["customer_id"],
    customerName: json["customer_name"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId,
    "status": status,
    "increment_id": incrementId,
    "date_requested": dateRequested.toIso8601String(),
    "order_id": orderId,
    "order_increment_id": orderIncrementId,
    "order_date": orderDate.toIso8601String(),
    "store_id": storeId,
    "customer_id": customerId,
    "customer_name": customerName,
  };
}
