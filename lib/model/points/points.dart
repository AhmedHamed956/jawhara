// To parse this JSON data, do
//
//     final points = pointsFromJson(jsonString);

import 'dart:convert';

class Points {
  Points({
    this.data,
  });

  Data data;

  factory Points.fromRawJson(String str) => Points.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.reward,
    this.rewardExchange,
    this.rewardExchangePoint,
    this.rewardExchangeCurrency,
    this.rewardMaximumLimit,
    this.rewardMimimumBalance,
    this.rewardReached,
  });

  Reward reward;
  String rewardExchange;
  String rewardExchangePoint;
  String rewardExchangeCurrency;
  String rewardMaximumLimit;
  String rewardMimimumBalance;
  String rewardReached;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reward: Reward.fromJson(json["reward"]),
    rewardExchange: json["reward_exchange"],
    rewardExchangePoint: json["reward_exchange_point"],
    rewardExchangeCurrency: json["reward_exchange_currency"],
    rewardMaximumLimit: json["reward_maximum_limit"],
    rewardMimimumBalance: json["reward_mimimum_balance"],
    rewardReached: json["reward_reached"],
  );

  Map<String, dynamic> toJson() => {
    "reward": reward.toJson(),
    "reward_exchange": rewardExchange,
    "reward_exchange_point": rewardExchangePoint,
    "reward_exchange_currency": rewardExchangeCurrency,
    "reward_maximum_limit": rewardMaximumLimit,
    "reward_mimimum_balance": rewardMimimumBalance,
    "reward_reached": rewardReached,
  };
}

class Reward {
  Reward({
    this.pointsBalance,
    this.currencyBalance,
    this.ptsToAmountRatePts,
    this.ptsToAmountRateAmount,
    this.amountToPtsRateAmount,
    this.amountToPtsRatePts,
    this.maxBalance,
    this.isMaxBalanceReached,
    this.minBalance,
  });

  dynamic pointsBalance;
  int currencyBalance;
  int ptsToAmountRatePts;
  String ptsToAmountRateAmount;
  String amountToPtsRateAmount;
  int amountToPtsRatePts;
  int maxBalance;
  bool isMaxBalanceReached;
  int minBalance;

  factory Reward.fromRawJson(String str) => Reward.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    pointsBalance: json["points_balance"],
    currencyBalance: json["currency_balance"],
    ptsToAmountRatePts: json["pts_to_amount_rate_pts"],
    ptsToAmountRateAmount: json["pts_to_amount_rate_amount"],
    amountToPtsRateAmount: json["amount_to_pts_rate_amount"],
    amountToPtsRatePts: json["amount_to_pts_rate_pts"],
    maxBalance: json["max_balance"],
    isMaxBalanceReached: json["is_max_balance_reached"],
    minBalance: json["min_balance"],
  );

  Map<String, dynamic> toJson() => {
    "points_balance": pointsBalance,
    "currency_balance": currencyBalance,
    "pts_to_amount_rate_pts": ptsToAmountRatePts,
    "pts_to_amount_rate_amount": ptsToAmountRateAmount,
    "amount_to_pts_rate_amount": amountToPtsRateAmount,
    "amount_to_pts_rate_pts": amountToPtsRatePts,
    "max_balance": maxBalance,
    "is_max_balance_reached": isMaxBalanceReached,
    "min_balance": minBalance,
  };
}
