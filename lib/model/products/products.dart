// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/model/products/product.dart';

class Products {
  Products({
    this.dataProducts,
    this.availablefilter,
    this.selectedFilters,
  });

  List<Product> dataProducts;
  List<AvailableFilter> availablefilter;
  List<SelectedFilter> selectedFilters;

  factory Products.fromRawJson(String str) => Products.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    dataProducts: json["data_products"] == null ? null : List<Product>.from(json["data_products"].map((x) => Product.fromJson(x))),
    availablefilter: json["availablefilter"] == null ? null : List<AvailableFilter>.from(json["availablefilter"].map((x) => AvailableFilter.fromJson(x))),
    selectedFilters: json["availablefilter"] == null ? null : List<SelectedFilter>.from(json["selectedFilters"].map((x) => SelectedFilter.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "data_products": dataProducts == null ? null : List<dynamic>.from(dataProducts.map((x) => x.toJson())),
    "availablefilter": availablefilter == null ? null : List<dynamic>.from(availablefilter.map((x) => x.toJson())),
    "selectedFilters": List<dynamic>.from(selectedFilters.map((x) => x.toJson())),
  };
}

class AvailableFilter {
  AvailableFilter({
    this.filterName,
    this.filterCode,
    this.filterOptions,
    this.filterRangeMin,
    this.filterRangeMax,
  });

  String filterName;
  String filterCode;
  List<FilterOption> filterOptions;
  dynamic filterRangeMin;
  dynamic filterRangeMax;

  factory AvailableFilter.fromRawJson(String str) => AvailableFilter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableFilter.fromJson(Map<String, dynamic> json) => AvailableFilter(
    filterName: json["filter_name"] == null ? null : json["filter_name"],
    filterCode: json["filter_code"] == null ? null : json["filter_code"],
    filterOptions: json["filter_options"] == null ? null : List<FilterOption>.from(json["filter_options"].map((x) => FilterOption.fromJson(x))),
    filterRangeMin: json["filter_range_min"] == null ? null : json["filter_range_min"],
    filterRangeMax: json["filter_range_max"] == null ? null : json["filter_range_max"],
  );

  Map<String, dynamic> toJson() => {
    "filter_name": filterName == null ? null : filterName,
    "filter_code": filterCode == null ? null : filterCode,
    "filter_options": filterOptions == null ? null : List<dynamic>.from(filterOptions.map((x) => x.toJson())),
    "filter_range_min": filterRangeMin == null ? null : filterRangeMin,
    "filter_range_max": filterRangeMax == null ? null : filterRangeMax,
  };
}

class FilterOption {
  FilterOption({
    this.display,
    this.value,
    this.count,
    this.swatchValue,
  });

  String display;
  dynamic value;
  String count;
  String swatchValue;

  factory FilterOption.fromRawJson(String str) => FilterOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FilterOption.fromJson(Map<String, dynamic> json) => FilterOption(
    display: json["display"] == null ? null : json["display"],
    value: json["value"],
    count: json["count"] == null ? null : json["count"],
    swatchValue: json["swatch_value"] == null ? null : json["swatch_value"],
  );

  Map<String, dynamic> toJson() => {
    "display": display == null ? null : display,
    "value": value,
    "count": count == null ? null : count,
    "swatch_value": swatchValue == null ? null : swatchValue,
  };
}

class DataProduct {
  DataProduct({
    this.entityId,
    this.attributeSetId,
    this.typeId,
    this.sku,
    this.status,
    this.name,
    this.smallImage,
    this.thumbnail,
    this.price,
    this.specialPrice,
    this.dataProductNew,
    this.sale,
    this.extensionData,
  });

  String entityId;
  String attributeSetId;
  DataProductTypeId typeId;
  String sku;
  String status;
  String name;
  String smallImage;
  String thumbnail;
  int price;
  dynamic specialPrice;
  String dataProductNew;
  String sale;
  ExtensionData extensionData;

  factory DataProduct.fromRawJson(String str) => DataProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataProduct.fromJson(Map<String, dynamic> json) => DataProduct(
    entityId: json["entity_id"] == null ? null : json["entity_id"],
    attributeSetId: json["attribute_set_id"] == null ? null : json["attribute_set_id"],
    typeId: json["type_id"] == null ? null : dataProductTypeIdValues.map[json["type_id"]],
    sku: json["sku"] == null ? null : json["sku"],
    status: json["status"] == null ? null : json["status"],
    name: json["name"] == null ? null : json["name"],
    smallImage: json["small_image"] == null ? null : json["small_image"],
    thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
    price: json["price"] == null ? null : json["price"],
    specialPrice: json["special_price"],
    dataProductNew: json["new"] == null ? null : json["new"],
    sale: json["sale"] == null ? null : json["sale"],
    extensionData: json["extension_data"] == null ? null : ExtensionData.fromJson(json["extension_data"]),
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId == null ? null : entityId,
    "attribute_set_id": attributeSetId == null ? null : attributeSetId,
    "type_id": typeId == null ? null : dataProductTypeIdValues.reverse[typeId],
    "sku": sku == null ? null : sku,
    "status": status == null ? null : status,
    "name": name == null ? null : name,
    "small_image": smallImage == null ? null : smallImage,
    "thumbnail": thumbnail == null ? null : thumbnail,
    "price": price == null ? null : price,
    "special_price": specialPrice,
    "new": dataProductNew == null ? null : dataProductNew,
    "sale": sale == null ? null : sale,
    "extension_data": extensionData == null ? null : extensionData.toJson(),
  };
}

class ExtensionData {
  ExtensionData({
    this.configurableProductOptions,
    this.configurableProductLinks,
  });

  List<ConfigurableProductOption> configurableProductOptions;
  List<ConfigurableProductLink> configurableProductLinks;

  factory ExtensionData.fromRawJson(String str) => ExtensionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtensionData.fromJson(Map<String, dynamic> json) => ExtensionData(
    configurableProductOptions: json["configurable_product_options"] == null ? null : List<ConfigurableProductOption>.from(json["configurable_product_options"].map((x) => ConfigurableProductOption.fromJson(x))),
    configurableProductLinks: json["configurable_product_links"] == null ? null : List<ConfigurableProductLink>.from(json["configurable_product_links"].map((x) => ConfigurableProductLink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "configurable_product_options": configurableProductOptions == null ? null : List<dynamic>.from(configurableProductOptions.map((x) => x.toJson())),
    "configurable_product_links": configurableProductLinks == null ? null : List<dynamic>.from(configurableProductLinks.map((x) => x.toJson())),
  };
}

class ConfigurableProductLink {
  ConfigurableProductLink({
    this.entityId,
    this.typeId,
    this.sku,
    this.status,
    this.price,
    this.size,
    this.color,
    this.name,
    this.swatchImage,
  });

  String entityId;
  ConfigurableProductLinkTypeId typeId;
  String sku;
  String status;
  String price;
  String size;
  String color;
  String name;
  String swatchImage;

  factory ConfigurableProductLink.fromRawJson(String str) => ConfigurableProductLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableProductLink.fromJson(Map<String, dynamic> json) => ConfigurableProductLink(
    entityId: json["entity_id"] == null ? null : json["entity_id"],
    typeId: json["type_id"] == null ? null : configurableProductLinkTypeIdValues.map[json["type_id"]],
    sku: json["sku"] == null ? null : json["sku"],
    status: json["status"] == null ? null : json["status"],
    price: json["price"] == null ? null : json["price"],
    size: json["size"] == null ? null : json["size"],
    color: json["color"] == null ? null : json["color"],
    name: json["name"] == null ? null : json["name"],
    swatchImage: json["swatch_image"] == null ? null : json["swatch_image"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": entityId == null ? null : entityId,
    "type_id": typeId == null ? null : configurableProductLinkTypeIdValues.reverse[typeId],
    "sku": sku == null ? null : sku,
    "status": status == null ? null : status,
    "price": price == null ? null : price,
    "size": size == null ? null : size,
    "color": color == null ? null : color,
    "name": name == null ? null : name,
    "swatch_image": swatchImage == null ? null : swatchImage,
  };
}

enum ConfigurableProductLinkTypeId { SIMPLE }

final configurableProductLinkTypeIdValues = EnumValues({
  "simple": ConfigurableProductLinkTypeId.SIMPLE
});

class ConfigurableProductOption {
  ConfigurableProductOption({
    this.productSuperAttributeId,
    this.attributeId,
    this.label,
    this.options,
  });

  String productSuperAttributeId;
  String attributeId;
  Label label;
  List<Option> options;

  factory ConfigurableProductOption.fromRawJson(String str) => ConfigurableProductOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableProductOption.fromJson(Map<String, dynamic> json) => ConfigurableProductOption(
    productSuperAttributeId: json["product_super_attribute_id"] == null ? null : json["product_super_attribute_id"],
    attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
    label: json["label"] == null ? null : labelValues.map[json["label"]],
    options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_super_attribute_id": productSuperAttributeId == null ? null : productSuperAttributeId,
    "attribute_id": attributeId == null ? null : attributeId,
    "label": label == null ? null : labelValues.reverse[label],
    "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

enum Label { COLOR, SIZE }

final labelValues = EnumValues({
  "Color": Label.COLOR,
  "Size": Label.SIZE
});

class Option {
  Option({
    this.valueIndex,
    this.label,
    this.productSuperAttributeId,
    this.defaultLabel,
    this.storeLabel,
    this.swatchValue,
    this.useDefaultValue,
  });

  String valueIndex;
  String label;
  String productSuperAttributeId;
  String defaultLabel;
  String storeLabel;
  String swatchValue;
  bool useDefaultValue;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    valueIndex: json["value_index"] == null ? null : json["value_index"],
    label: json["label"] == null ? null : json["label"],
    productSuperAttributeId: json["product_super_attribute_id"] == null ? null : json["product_super_attribute_id"],
    defaultLabel: json["default_label"] == null ? null : json["default_label"],
    storeLabel: json["store_label"] == null ? null : json["store_label"],
    swatchValue: json["swatch_value"] == null ? null : json["swatch_value"],
    useDefaultValue: json["use_default_value"] == null ? null : json["use_default_value"],
  );

  Map<String, dynamic> toJson() => {
    "value_index": valueIndex == null ? null : valueIndex,
    "label": label == null ? null : label,
    "product_super_attribute_id": productSuperAttributeId == null ? null : productSuperAttributeId,
    "default_label": defaultLabel == null ? null : defaultLabel,
    "store_label": storeLabel == null ? null : storeLabel,
    "swatch_value": swatchValue == null ? null : swatchValue,
    "use_default_value": useDefaultValue == null ? null : useDefaultValue,
  };
}

enum DataProductTypeId { CONFIGURABLE }

final dataProductTypeIdValues = EnumValues({
  "configurable": DataProductTypeId.CONFIGURABLE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class SelectedFilter {
  SelectedFilter({
    this.filters,
  });

  List<Filter> filters;

  factory SelectedFilter.fromRawJson(String str) => SelectedFilter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SelectedFilter.fromJson(Map<String, dynamic> json) => SelectedFilter(
    filters: List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}
class Filter {
  Filter({
    this.field,
    this.value,
    this.conditionType,
  });

  String field;
  String value;
  String conditionType;

  factory Filter.fromRawJson(String str) => Filter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
    field: json["field"],
    value: json["value"],
    conditionType: json["condition_type"] == null ? null : json["condition_type"],
  );

  Map<String, dynamic> toJson() => {
    "field": field,
    "value": value,
    "condition_type": conditionType == null ? null : conditionType,
  };
}
