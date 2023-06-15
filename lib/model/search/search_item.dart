// To parse this JSON data, do
//
//     final searchItem = searchItemFromJson(jsonString);

import 'dart:convert';

class SearchItem {
  SearchItem({
    this.items,
    this.suggestItems,
    this.relatedSearchItems,
    this.totalCount,
  });

  List<ItemSearch> items;
  List<SuggestItem> suggestItems;
  List<RelatedSearchItem> relatedSearchItems;
  int totalCount;

  factory SearchItem.fromRawJson(String str) => SearchItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchItem.fromJson(Map<String, dynamic> json) => SearchItem(
    items: json["items"] != null ? List<ItemSearch>.from(json["items"].map((x) => ItemSearch.fromJson(x))) : [],
    suggestItems: json["suggested_items"] != null ? List<SuggestItem>.from(json["suggested_items"].map((x) => SuggestItem.fromJson(x))) : [],
    relatedSearchItems: json["recommended"] != null ? List<RelatedSearchItem>.from(json["recommended"].map((x) => RelatedSearchItem.fromJson(x))) : [],
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total_count": totalCount,
  };
}

class ItemSearch {
  ItemSearch({
    this.id,
    this.customAttributes,
  });

  int id;
  List<CustomAttribute> customAttributes;

  factory ItemSearch.fromRawJson(String str) => ItemSearch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemSearch.fromJson(Map<String, dynamic> json) => ItemSearch(
    id: json["id"],
    customAttributes: json["custom_attributes"] != null ? List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x.toJson())),
  };
}

class CustomAttribute {
  CustomAttribute({
    this.attributeCode,
    this.value,
  });

  String attributeCode;
  double value;

  factory CustomAttribute.fromRawJson(String str) => CustomAttribute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomAttribute.fromJson(Map<String, dynamic> json) => CustomAttribute(
    attributeCode: json["attribute_code"],
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "attribute_code": attributeCode,
    "value": value,
  };
}

class SuggestItem {
  SuggestItem({
    this.queryText,
  });

  String queryText;

  factory SuggestItem.fromRawJson(String str) => SuggestItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuggestItem.fromJson(Map<String, dynamic> json) => SuggestItem(
    queryText: json["query_text"],
  );

  Map<String, dynamic> toJson() => {
    "query_text": queryText,
  };
}

class RelatedSearchItem {
  RelatedSearchItem({
    this.queryText,
  });

  String queryText;

  factory RelatedSearchItem.fromRawJson(String str) => RelatedSearchItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RelatedSearchItem.fromJson(Map<String, dynamic> json) => RelatedSearchItem(
    queryText: json["query_text"],
  );

  Map<String, dynamic> toJson() => {
    "query_text": queryText,
  };
}
