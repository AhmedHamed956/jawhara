// To parse this JSON data, do
//
//     final alertPoint = alertPointFromJson(jsonString);

import 'dart:convert';

class AlertPoint {
  AlertPoint({
    this.data,
  });

  Data data;

  factory AlertPoint.fromRawJson(String str) => AlertPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlertPoint.fromJson(Map<String, dynamic> json) => AlertPoint(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.response,
    this.itemRewardPoints,
    this.ruleRewardPoints,
    this.itemRewardAmount,
    this.ruleRewardAmount,
    this.totalPointsBalance,
    this.totalCurrencyBalance,
  });

  bool response;
  int itemRewardPoints;
  int ruleRewardPoints;
  String itemRewardAmount;
  String ruleRewardAmount;
  String totalPointsBalance;
  int totalCurrencyBalance;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    response: json["response"],
    itemRewardPoints: json["item_reward_points"],
    ruleRewardPoints: json["rule_reward_points"],
    itemRewardAmount: json["item_reward_amount"],
    ruleRewardAmount: json["rule_reward_amount"],
    totalPointsBalance: json["total_points_balance"],
    totalCurrencyBalance: json["total_currency_balance"],
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "item_reward_points": itemRewardPoints,
    "rule_reward_points": ruleRewardPoints,
    "item_reward_amount": itemRewardAmount,
    "rule_reward_amount": ruleRewardAmount,
    "total_points_balance": totalPointsBalance,
    "total_currency_balance": totalCurrencyBalance,
  };
}
