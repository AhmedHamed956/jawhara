// To parse this JSON data, do
//
//     final trackInformation = trackInformationFromJson(jsonString);

import 'dart:convert';

class TrackInformation {
  TrackInformation({
    this.entityId,
    this.orderId,
    this.trackNumber,
    this.title,
    this.carrierCode,
    this.trackUrl,
  });

  String entityId;
  String orderId;
  String trackNumber;
  String title;
  String carrierCode;
  String trackUrl;

  factory TrackInformation.fromRawJson(String str) => TrackInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrackInformation.fromJson(Map<String, dynamic> json) => TrackInformation(
    entityId: json["entity_id"],
    orderId: json["order_id"],
    trackNumber: json["track_number"],
    title: json["title"],
    carrierCode: json["carrier_code"],
    trackUrl: json["track_url"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId,
    "order_id": orderId,
    "track_number": trackNumber,
    "title": title,
    "carrier_code": carrierCode,
    "track_url": trackUrl,
  };
}
