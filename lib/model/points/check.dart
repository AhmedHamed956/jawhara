// To parse this JSON data, do
//
//     final checkPoint = checkPointFromJson(jsonString);

import 'dart:convert';

class CheckPoint {
  CheckPoint({
    this.data,
  });

  CheckData data;

  factory CheckPoint.fromRawJson(String str) => CheckPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckPoint.fromJson(Map<String, dynamic> json) => CheckPoint(
        data: CheckData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class CheckData {
  CheckData({
    this.response,
    this.message,
  });

  bool response;
  String message;

  factory CheckData.fromRawJson(String str) => CheckData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckData.fromJson(Map<String, dynamic> json) => CheckData(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
