// To parse this JSON data, do
//
//     final productDetails = productDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:jawhara/model/products/product.dart';

class ProductDetails {
  ProductDetails(
      {this.entityId,
      this.sku,
      this.description,
      this.name,
      this.thumbnail,
      this.image,
      this.galleryImages,
      this.price,
      this.specialPrice,
      this.specialFromDate,
      this.options,
      this.configurableProductOptions,
      this.configurableProductLinks,
      this.productLinks,
      this.alwaysSoldWithProducts,
      this.customAttributes,
      this.stockItem,
      this.quantityAndStockStatus,
      this.urlKey,
      this.watchVideoSection,
      this.sizeGuideSection});

  String entityId;
  String sku;
  String description;
  String name;
  String thumbnail;
  String image;
  List<String> galleryImages;
  dynamic price;
  String specialPrice;
  DateTime specialFromDate;
  List<dynamic> options;
  List<ConfigurableProductOption> configurableProductOptions;
  List<ConfigurableProductLink> configurableProductLinks;
  List<ProductLink> productLinks;
  List<Product> alwaysSoldWithProducts;
  CustomAttributes customAttributes;
  StockItem stockItem;
  QuantityAndStockStatus quantityAndStockStatus;
  String urlKey;
  String watchVideoSection;
  String sizeGuideSection;

  factory ProductDetails.fromRawJson(String str) => ProductDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    // print('json["media_gallery"] > ${json["media_gallery"]}');
    return ProductDetails(
      entityId: json["entity_id"] == null ? null : json["entity_id"],
      sku: json["sku"] == null ? null : json["sku"],
      name: json["name"] == null ? null : json["name"],
      price: json["price"] == null ? null : json["price"],
      thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      image: json["image"] == null ? null : json["image"],
      galleryImages: json["media_gallery"] == null ||
              (json["media_gallery"]["images"].isEmpty && json["media_gallery"]["values"].isEmpty) ||
              (json["media_gallery"]["images"] == null && json["media_gallery"]["values"] == null)
          ? null
          : List<String>.from(json["media_gallery"]["images"].entries.map((x) {
              if (x.value["media_type"] == 'image') {
                return x.value["file"];
              } else if (x.value["media_type"] == 'external-video') {
                return x.value["video_url"];
              }
            })),
      specialPrice: json["special_price"],
      specialFromDate: DateTime.tryParse(json["special_from_date"] ?? ""),
      urlKey: json["url_key"] == null ? null : json["url_key"],
      description: json["description"] == null ? null : json["description"],
      watchVideoSection: json["watch_video"] == null ? null : json["watch_video"],
      sizeGuideSection: json["size_guide"] == null ? null : json["size_guide"],
      options: json["options"] == null ? null : List<dynamic>.from(json["options"].map((x) => x)),
      configurableProductOptions: json["configurable_product_options"] == null
          ? null
          : List<ConfigurableProductOption>.from(json["configurable_product_options"].map((x) => ConfigurableProductOption.fromJson(x))),
      configurableProductLinks: json["configurable_product_links"] == null
          ? null
          : List<ConfigurableProductLink>.from(json["configurable_product_links"].map((x) => ConfigurableProductLink.fromJson(x))),
      productLinks:
          json["product_links"] == null ? null : List<ProductLink>.from(json["product_links"].map((x) => ProductLink.fromJson(x))),
      alwaysSoldWithProducts: json["always_sold_with"] == null && json["always_sold_with"].isNotEmpty
          ? null
          : List<Product>.from(json["always_sold_with"].map((x) => Product.fromJson(x["data"]))),
      customAttributes: json["custom_attributes"] == null ? null : CustomAttributes.fromJson(json["custom_attributes"]),
      stockItem: json["stock_item"] == null ? null : StockItem.fromJson(json["stock_item"]),
      quantityAndStockStatus: QuantityAndStockStatus.fromJson(json["quantity_and_stock_status"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "sku": sku == null ? null : sku,
        "description": description == null ? null : description,
        "name": name == null ? null : name,
        "urlKey": urlKey == null ? null : urlKey,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "price": price == null ? '0' : price,
        "options": options == null ? null : List<dynamic>.from(options.map((x) => x)),
        "configurable_product_options":
            configurableProductOptions == null ? null : List<dynamic>.from(configurableProductOptions.map((x) => x.toJson())),
        "configurable_product_links":
            configurableProductLinks == null ? null : List<dynamic>.from(configurableProductLinks.map((x) => x.toJson())),
        "product_links": productLinks == null ? null : List<dynamic>.from(productLinks.map((x) => x.toJson())),
        "custom_attributes": customAttributes == null ? null : customAttributes.toJson(),
        "stock_item": stockItem == null ? null : stockItem.toJson(),
        "quantity_and_stock_status": quantityAndStockStatus.toJson(),
      };
}

class QuantityAndStockStatus {
  QuantityAndStockStatus({
    this.isInStock,
    this.qty,
  });

  bool isInStock;
  int qty;

  factory QuantityAndStockStatus.fromRawJson(String str) => QuantityAndStockStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuantityAndStockStatus.fromJson(Map<String, dynamic> json) => QuantityAndStockStatus(
        isInStock: json["is_in_stock"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "is_in_stock": isInStock,
        "qty": qty,
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
  TypeId typeId;
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
        typeId: json["type_id"] == null ? null : typeIdValues.map[json["type_id"]],
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
        "type_id": typeId == null ? null : typeIdValues.reverse[typeId],
        "sku": sku == null ? null : sku,
        "status": status == null ? null : status,
        "price": price == null ? null : price,
        "size": size == null ? null : size,
        "color": color == null ? null : color,
        "name": name == null ? null : name,
        "swatch_image": swatchImage == null ? null : swatchImage,
      };
}

enum TypeId { SIMPLE }

final typeIdValues = EnumValues({"simple": TypeId.SIMPLE});

class ConfigurableProductOption {
  ConfigurableProductOption({
    this.productSuperAttributeId,
    this.attributeId,
    this.label,
    this.options,
  });

  String productSuperAttributeId;
  String attributeId;
  String label;
  List<Option> options;

  factory ConfigurableProductOption.fromRawJson(String str) => ConfigurableProductOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableProductOption.fromJson(Map<String, dynamic> json) => ConfigurableProductOption(
        productSuperAttributeId: json["product_super_attribute_id"] == null ? null : json["product_super_attribute_id"],
        attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
        label: json["label"] == null ? null : json["label"],
        options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_super_attribute_id": productSuperAttributeId == null ? null : productSuperAttributeId,
        "attribute_id": attributeId == null ? null : attributeId,
        "label": label == null ? null : label,
        "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

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
  int isCheck = 0;

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

class CustomAttributes {
  CustomAttributes({
    this.specificiation,
    this.description,
  });

  List<Specificiation> specificiation;
  List<Description> description;

  factory CustomAttributes.fromRawJson(String str) => CustomAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomAttributes.fromJson(Map<String, dynamic> json) => CustomAttributes(
        specificiation: json["specificiation"] == null
            ? null
            : List<Specificiation>.from(json["specificiation"].map((x) => Specificiation.fromJson(x))),
        description: json["description"] == null ? null : List<Description>.from(json["description"].map((x) => Description.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "specificiation": specificiation == null ? null : List<dynamic>.from(specificiation.map((x) => x.toJson())),
        "description": description == null ? null : List<dynamic>.from(description.map((x) => x.toJson())),
      };
}

class Description {
  Description({
    this.attributeCode,
    this.value,
  });

  String attributeCode;
  String value;

  factory Description.fromRawJson(String str) => Description.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        attributeCode: json["attribute_code"] == null ? null : json["attribute_code"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "attribute_code": attributeCode == null ? null : attributeCode,
        "value": value == null ? null : value,
      };
}

class Specificiation {
  Specificiation({
    this.attributeCode,
    this.value,
  });

  String attributeCode;
  Value value;

  factory Specificiation.fromRawJson(String str) => Specificiation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Specificiation.fromJson(Map<String, dynamic> json) => Specificiation(
        attributeCode: json["attribute_code"] == null ? null : json["attribute_code"],
        value: json["value"] == null ? null : Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "attribute_code": attributeCode == null ? null : attributeCode,
        "value": value == null ? null : value.toJson(),
      };
}

class Value {
  Value({
    this.title,
    this.label,
    this.code,
    this.visibleOnStorefront,
  });

  String title;
  String label;
  String code;
  String visibleOnStorefront;

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        title: json["title"] == null ? null : json["title"],
        label: json["label"] == null ? null : json["label"],
        code: json["code"] == null ? null : json["code"],
        visibleOnStorefront: json["visible_on_storefront"] == null ? null : json["visible_on_storefront"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "label": label == null ? null : label,
        "code": code == null ? null : code,
        "visible_on_storefront": visibleOnStorefront == null ? null : visibleOnStorefront,
      };
}

class ExtensionAttributes {
  ExtensionAttributes();

  factory ExtensionAttributes.fromRawJson(String str) => ExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes();

  Map<String, dynamic> toJson() => {};
}

// class Image {
//   Image({
//     this.valueId,
//     this.file,
//     this.mediaType,
//     this.rowId,
//     this.label,
//     this.position,
//     this.disabled,
//     this.labelDefault,
//     this.positionDefault,
//     this.disabledDefault,
//     this.videoProvider,
//     this.videoUrl,
//     this.videoTitle,
//     this.videoDescription,
//     this.videoMetadata,
//     this.videoProviderDefault,
//     this.videoUrlDefault,
//     this.videoTitleDefault,
//     this.videoDescriptionDefault,
//     this.videoMetadataDefault,
//   });
//
//   String valueId;
//   String file;
//   String mediaType;
//   String rowId;
//   dynamic label;
//   String position;
//   String disabled;
//   dynamic labelDefault;
//   String positionDefault;
//   String disabledDefault;
//   dynamic videoProvider;
//   dynamic videoUrl;
//   dynamic videoTitle;
//   dynamic videoDescription;
//   dynamic videoMetadata;
//   dynamic videoProviderDefault;
//   dynamic videoUrlDefault;
//   dynamic videoTitleDefault;
//   dynamic videoDescriptionDefault;
//   dynamic videoMetadataDefault;
//
//   factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         valueId: json["value_id"] == null ? null : json["value_id"],
//         file: json["file"] == null ? null : json["file"],
//         mediaType: json["media_type"] == null ? null : json["media_type"],
//         rowId: json["row_id"] == null ? null : json["row_id"],
//         label: json["label"],
//         position: json["position"] == null ? null : json["position"],
//         disabled: json["disabled"] == null ? null : json["disabled"],
//         labelDefault: json["label_default"],
//         positionDefault:
//             json["position_default"] == null ? null : json["position_default"],
//         disabledDefault:
//             json["disabled_default"] == null ? null : json["disabled_default"],
//         videoProvider: json["video_provider"],
//         videoUrl: json["video_url"],
//         videoTitle: json["video_title"],
//         videoDescription: json["video_description"],
//         videoMetadata: json["video_metadata"],
//         videoProviderDefault: json["video_provider_default"],
//         videoUrlDefault: json["video_url_default"],
//         videoTitleDefault: json["video_title_default"],
//         videoDescriptionDefault: json["video_description_default"],
//         videoMetadataDefault: json["video_metadata_default"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "value_id": valueId == null ? null : valueId,
//         "file": file == null ? null : file,
//         "media_type": mediaType == null ? null : mediaType,
//         "row_id": rowId == null ? null : rowId,
//         "label": label,
//         "position": position == null ? null : position,
//         "disabled": disabled == null ? null : disabled,
//         "label_default": labelDefault,
//         "position_default": positionDefault == null ? null : positionDefault,
//         "disabled_default": disabledDefault == null ? null : disabledDefault,
//         "video_provider": videoProvider,
//         "video_url": videoUrl,
//         "video_title": videoTitle,
//         "video_description": videoDescription,
//         "video_metadata": videoMetadata,
//         "video_provider_default": videoProviderDefault,
//         "video_url_default": videoUrlDefault,
//         "video_title_default": videoTitleDefault,
//         "video_description_default": videoDescriptionDefault,
//         "video_metadata_default": videoMetadataDefault,
//       };
// }

class MediaGalleryEntry {
  MediaGalleryEntry({
    this.file,
    this.mediaType,
    this.label,
    this.position,
    this.disabled,
    this.types,
    this.id,
  });

  String file;
  String mediaType;
  dynamic label;
  String position;
  String disabled;
  List<String> types;
  String id;

  factory MediaGalleryEntry.fromRawJson(String str) => MediaGalleryEntry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) => MediaGalleryEntry(
        file: json["file"] == null ? null : json["file"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        label: json["label"],
        position: json["position"] == null ? null : json["position"],
        disabled: json["disabled"] == null ? null : json["disabled"],
        types: json["types"] == null ? null : List<String>.from(json["types"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "file": file == null ? null : file,
        "media_type": mediaType == null ? null : mediaType,
        "label": label,
        "position": position == null ? null : position,
        "disabled": disabled == null ? null : disabled,
        "types": types == null ? null : List<dynamic>.from(types.map((x) => x)),
        "id": id == null ? null : id,
      };
}

class ProductLink {
  ProductLink({
    this.sku,
    this.linkType,
    this.linkedProductSku,
    this.linkedProductType,
    this.position,
    this.data,
  });

  String sku;
  String linkType;
  String linkedProductSku;
  String linkedProductType;
  String position;
  Product data;

  factory ProductLink.fromRawJson(String str) => ProductLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductLink.fromJson(Map<String, dynamic> json) => ProductLink(
        sku: json["sku"] == null ? null : json["sku"],
        linkType: json["link_type"] == null ? null : json["link_type"],
        linkedProductSku: json["linked_product_sku"] == null ? null : json["linked_product_sku"],
        linkedProductType: json["linked_product_type"] == null ? null : json["linked_product_type"],
        position: json["position"] == null ? null : json["position"],
        data: json["data"] == null ? null : Product.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "sku": sku == null ? null : sku,
        "link_type": linkType == null ? null : linkType,
        "linked_product_sku": linkedProductSku == null ? null : linkedProductSku,
        "linked_product_type": linkedProductType == null ? null : linkedProductType,
        "position": position == null ? null : position,
        "data": data == null ? null : data.toJson(),
      };
}

class StockItem {
  StockItem({
    this.itemId,
    this.productId,
    this.stockId,
    this.qty,
    this.minQty,
    this.useConfigMinQty,
    this.isQtyDecimal,
    this.backorders,
    this.useConfigBackorders,
    this.minSaleQty,
    this.useConfigMinSaleQty,
    this.maxSaleQty,
    this.useConfigMaxSaleQty,
    this.isInStock,
    this.lowStockDate,
    this.notifyStockQty,
    this.useConfigNotifyStockQty,
    this.manageStock,
    this.useConfigManageStock,
    this.stockStatusChangedAuto,
    this.useConfigQtyIncrements,
    this.qtyIncrements,
    this.useConfigEnableQtyInc,
    this.enableQtyIncrements,
    this.isDecimalDivided,
    this.websiteId,
    this.deferredStockUpdate,
    this.useConfigDeferredStockUpdate,
    this.typeId,
  });

  String itemId;
  String productId;
  String stockId;
  String qty;
  String minQty;
  String useConfigMinQty;
  String isQtyDecimal;
  String backorders;
  String useConfigBackorders;
  String minSaleQty;
  String useConfigMinSaleQty;
  String maxSaleQty;
  String useConfigMaxSaleQty;
  String isInStock;
  dynamic lowStockDate;
  String notifyStockQty;
  String useConfigNotifyStockQty;
  String manageStock;
  String useConfigManageStock;
  String stockStatusChangedAuto;
  String useConfigQtyIncrements;
  String qtyIncrements;
  String useConfigEnableQtyInc;
  String enableQtyIncrements;
  String isDecimalDivided;
  String websiteId;
  String deferredStockUpdate;
  String useConfigDeferredStockUpdate;
  String typeId;

  factory StockItem.fromRawJson(String str) => StockItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        itemId: json["item_id"] == null ? null : json["item_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        stockId: json["stock_id"] == null ? null : json["stock_id"],
        qty: json["qty"] == null ? null : json["qty"],
        minQty: json["min_qty"] == null ? null : json["min_qty"],
        useConfigMinQty: json["use_config_min_qty"] == null ? null : json["use_config_min_qty"],
        isQtyDecimal: json["is_qty_decimal"] == null ? null : json["is_qty_decimal"],
        backorders: json["backorders"] == null ? null : json["backorders"],
        useConfigBackorders: json["use_config_backorders"] == null ? null : json["use_config_backorders"],
        minSaleQty: json["min_sale_qty"] == null ? null : json["min_sale_qty"],
        useConfigMinSaleQty: json["use_config_min_sale_qty"] == null ? null : json["use_config_min_sale_qty"],
        maxSaleQty: json["max_sale_qty"] == null ? null : json["max_sale_qty"],
        useConfigMaxSaleQty: json["use_config_max_sale_qty"] == null ? null : json["use_config_max_sale_qty"],
        isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
        lowStockDate: json["low_stock_date"],
        notifyStockQty: json["notify_stock_qty"] == null ? null : json["notify_stock_qty"],
        useConfigNotifyStockQty: json["use_config_notify_stock_qty"] == null ? null : json["use_config_notify_stock_qty"],
        manageStock: json["manage_stock"] == null ? null : json["manage_stock"],
        useConfigManageStock: json["use_config_manage_stock"] == null ? null : json["use_config_manage_stock"],
        stockStatusChangedAuto: json["stock_status_changed_auto"] == null ? null : json["stock_status_changed_auto"],
        useConfigQtyIncrements: json["use_config_qty_increments"] == null ? null : json["use_config_qty_increments"],
        qtyIncrements: json["qty_increments"] == null ? null : json["qty_increments"],
        useConfigEnableQtyInc: json["use_config_enable_qty_inc"] == null ? null : json["use_config_enable_qty_inc"],
        enableQtyIncrements: json["enable_qty_increments"] == null ? null : json["enable_qty_increments"],
        isDecimalDivided: json["is_decimal_divided"] == null ? null : json["is_decimal_divided"],
        websiteId: json["website_id"] == null ? null : json["website_id"],
        deferredStockUpdate: json["deferred_stock_update"] == null ? null : json["deferred_stock_update"],
        useConfigDeferredStockUpdate: json["use_config_deferred_stock_update"] == null ? null : json["use_config_deferred_stock_update"],
        typeId: json["type_id"] == null ? null : json["type_id"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "product_id": productId == null ? null : productId,
        "stock_id": stockId == null ? null : stockId,
        "qty": qty == null ? null : qty,
        "min_qty": minQty == null ? null : minQty,
        "use_config_min_qty": useConfigMinQty == null ? null : useConfigMinQty,
        "is_qty_decimal": isQtyDecimal == null ? null : isQtyDecimal,
        "backorders": backorders == null ? null : backorders,
        "use_config_backorders": useConfigBackorders == null ? null : useConfigBackorders,
        "min_sale_qty": minSaleQty == null ? null : minSaleQty,
        "use_config_min_sale_qty": useConfigMinSaleQty == null ? null : useConfigMinSaleQty,
        "max_sale_qty": maxSaleQty == null ? null : maxSaleQty,
        "use_config_max_sale_qty": useConfigMaxSaleQty == null ? null : useConfigMaxSaleQty,
        "is_in_stock": isInStock == null ? null : isInStock,
        "low_stock_date": lowStockDate,
        "notify_stock_qty": notifyStockQty == null ? null : notifyStockQty,
        "use_config_notify_stock_qty": useConfigNotifyStockQty == null ? null : useConfigNotifyStockQty,
        "manage_stock": manageStock == null ? null : manageStock,
        "use_config_manage_stock": useConfigManageStock == null ? null : useConfigManageStock,
        "stock_status_changed_auto": stockStatusChangedAuto == null ? null : stockStatusChangedAuto,
        "use_config_qty_increments": useConfigQtyIncrements == null ? null : useConfigQtyIncrements,
        "qty_increments": qtyIncrements == null ? null : qtyIncrements,
        "use_config_enable_qty_inc": useConfigEnableQtyInc == null ? null : useConfigEnableQtyInc,
        "enable_qty_increments": enableQtyIncrements == null ? null : enableQtyIncrements,
        "is_decimal_divided": isDecimalDivided == null ? null : isDecimalDivided,
        "website_id": websiteId == null ? null : websiteId,
        "deferred_stock_update": deferredStockUpdate == null ? null : deferredStockUpdate,
        "use_config_deferred_stock_update": useConfigDeferredStockUpdate == null ? null : useConfigDeferredStockUpdate,
        "type_id": typeId == null ? null : typeId,
      };
}

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
