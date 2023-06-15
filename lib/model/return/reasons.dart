// To parse this JSON data, do
//
//     final reasons = reasonsFromJson(jsonString);

import 'dart:convert';

class Reasons {
  Reasons({
    this.frontendInput,
    this.inputFilter,
    this.storeLabel,
    this.validationRules,
    this.multilineCount,
    this.visible,
    this.required,
    this.dataModel,
    this.options,
    this.frontendClass,
    this.userDefined,
    this.sortOrder,
    this.frontendLabel,
    this.note,
    this.system,
    this.backendType,
    this.attributeCode,
  });

  String frontendInput;
  String inputFilter;
  String storeLabel;
  List<dynamic> validationRules;
  int multilineCount;
  bool visible;
  bool required;
  String dataModel;
  List<Option> options;
  String frontendClass;
  bool userDefined;
  int sortOrder;
  String frontendLabel;
  String note;
  bool system;
  String backendType;
  String attributeCode;

  factory Reasons.fromRawJson(String str) => Reasons.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reasons.fromJson(Map<String, dynamic> json) => Reasons(
    frontendInput: json["frontend_input"],
    inputFilter: json["input_filter"],
    storeLabel: json["store_label"],
    validationRules: List<dynamic>.from(json["validation_rules"].map((x) => x)),
    multilineCount: json["multiline_count"],
    visible: json["visible"],
    required: json["required"],
    dataModel: json["data_model"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    frontendClass: json["frontend_class"],
    userDefined: json["user_defined"],
    sortOrder: json["sort_order"],
    frontendLabel: json["frontend_label"],
    note: json["note"],
    system: json["system"],
    backendType: json["backend_type"],
    attributeCode: json["attribute_code"],
  );

  Map<String, dynamic> toJson() => {
    "frontend_input": frontendInput,
    "input_filter": inputFilter,
    "store_label": storeLabel,
    "validation_rules": List<dynamic>.from(validationRules.map((x) => x)),
    "multiline_count": multilineCount,
    "visible": visible,
    "required": required,
    "data_model": dataModel,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "frontend_class": frontendClass,
    "user_defined": userDefined,
    "sort_order": sortOrder,
    "frontend_label": frontendLabel,
    "note": note,
    "system": system,
    "backend_type": backendType,
    "attribute_code": attributeCode,
  };
}

class Option {
  Option({
    this.label,
    this.value,
  });

  String label;
  String value;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
