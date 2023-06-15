// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'dart:convert';

class StateModel {
  StateModel({
    this.availableStates,
  });

  List<AvailableState> availableStates;

  factory StateModel.fromRawJson(String str) => StateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    availableStates: json["available_states"] == null ? null : List<AvailableState>.from(json["available_states"].map((x) => AvailableState.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "available_states": availableStates == null ? null : List<dynamic>.from(availableStates.map((x) => x.toJson())),
  };
}

class AvailableState {
  AvailableState({
    this.entityId,
    this.statesName,
  });

  String entityId;
  String statesName;

  factory AvailableState.fromRawJson(String str) => AvailableState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableState.fromJson(Map<String, dynamic> json) => AvailableState(
    entityId: json["entity_id"] == null ? null : json["entity_id"],
    statesName: json["states_name"] == null ? null : json["states_name"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId == null ? null : entityId,
    "states_name": statesName == null ? null : statesName,
  };
}
