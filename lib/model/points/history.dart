// To parse this JSON data, do
//
//     final historyPoint = historyPointFromJson(jsonString);

import 'dart:convert';

class HistoryPoint {
  HistoryPoint({
    this.items,
  });

  List<Item> items;

  factory HistoryPoint.fromRawJson(String str) =>
      HistoryPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryPoint.fromJson(Map<String, dynamic> json) => HistoryPoint(
        items: json["items"] != null
            ? List<Item>.from(json["items"].map((x) => Item.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.balance,
    this.amount,
    this.action,
    this.reason,
    this.date,
  });

  String balance;
  String amount;
  String action;
  String reason;
  DateTime date;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        balance: json["balance"],
        amount: json["amount"],
        action: json["action"],
        reason: json["reason"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "amount": amount,
        "action": action,
        "reason": reason,
        "date": date.toIso8601String(),
      };
}
