// To parse this JSON data, do
//
//     final cardPayments = cardPaymentsFromJson(jsonString);

import 'dart:convert';

class CardPayments {
  CardPayments({
    this.active,
    this.data,
  });

  String active;
  List<Datum> data;

  factory CardPayments.fromRawJson(String str) => CardPayments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardPayments.fromJson(Map<String, dynamic> json) => CardPayments(
        active: json["active"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.publicHash,
    this.type,
    this.typename,
    this.maskedCc,
    this.expirationDate,
  });

  String publicHash;
  String type;
  String typename;
  String maskedCc;
  String expirationDate;
  bool check = false;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        publicHash: json["public_hash"],
        type: json["type"],
        typename: json["typename"],
        maskedCc: json["maskedCC"],
        expirationDate: json["expirationDate"],
      );

  Map<String, dynamic> toJson() => {
        "public_hash": publicHash,
        "type": type,
        "typename": typename,
        "maskedCC": maskedCc,
        "expirationDate": expirationDate,
      };
}
