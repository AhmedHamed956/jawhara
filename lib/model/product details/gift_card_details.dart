// To parse this JSON data, do
//
//     final giftCardDetails = giftCardDetailsFromJson(jsonString);

import 'dart:convert';

class GiftCardDetails {
  GiftCardDetails({
    this.entityId,
    this.attributeSetId,
    this.typeId,
    this.sku,
    this.hasOptions,
    this.requiredOptions,
    this.createdAt,
    this.updatedAt,
    this.rowId,
    this.createdIn,
    this.updatedIn,
    this.name,
    this.pageLayout,
    this.optionsContainer,
    this.urlKey,
    this.emailTemplate,
    this.giftMessageAvailable,
    this.giftWrappingAvailable,
    this.isReturnable,
    this.status,
    this.visibility,
    this.quantityAndStockStatus,
    this.allowOpenAmount,
    this.giftcardType,
    this.isRedeemable,
    this.useConfigIsRedeemable,
    this.lifetime,
    this.useConfigLifetime,
    this.useConfigEmailTemplate,
    this.allowMessage,
    this.useConfigAllowMessage,
    this.plSizeChart,
    this.weight,
    this.openAmountMin,
    this.openAmountMax,
    this.options,
    this.mediaGallery,
    this.extensionAttributes,
    this.giftcardAmounts,
    this.categoryIds,
    this.isSalable,
    this.thumbnail,
    this.price,
    this.websiteIds,
    this.categoryLinks,
    this.stockItem,
    this.customAttributes,
  });

  String entityId;
  String attributeSetId;
  String typeId;
  String sku;
  String hasOptions;
  String requiredOptions;
  DateTime createdAt;
  DateTime updatedAt;
  String rowId;
  String createdIn;
  String updatedIn;
  String name;
  String pageLayout;
  String optionsContainer;
  String urlKey;
  String emailTemplate;
  String giftMessageAvailable;
  String giftWrappingAvailable;
  String isReturnable;
  String status;
  String visibility;
  QuantityAndStockStatus quantityAndStockStatus;
  String allowOpenAmount;
  String giftcardType;
  String isRedeemable;
  String useConfigIsRedeemable;
  String lifetime;
  String useConfigLifetime;
  String useConfigEmailTemplate;
  String allowMessage;
  String useConfigAllowMessage;
  String plSizeChart;
  String weight;
  String openAmountMin;
  String openAmountMax;
  List<dynamic> options;
  MediaGallery mediaGallery;
  ExtensionAttributes extensionAttributes;
  List<dynamic> giftcardAmounts;
  List<String> categoryIds;
  int isSalable;
  String thumbnail;
  String price;
  List<String> websiteIds;
  List<String> categoryLinks;
  StockItem stockItem;
  List<dynamic> customAttributes;

  factory GiftCardDetails.fromRawJson(String str) =>
      GiftCardDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GiftCardDetails.fromJson(Map<String, dynamic> json) =>
      GiftCardDetails(
        entityId: json["entity_id"],
        attributeSetId: json["attribute_set_id"],
        typeId: json["type_id"],
        sku: json["sku"],
        hasOptions: json["has_options"],
        requiredOptions: json["required_options"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        rowId: json["row_id"],
        createdIn: json["created_in"],
        updatedIn: json["updated_in"],
        name: json["name"],
        pageLayout: json["page_layout"],
        optionsContainer: json["options_container"],
        urlKey: json["url_key"],
        emailTemplate: json["email_template"],
        giftMessageAvailable: json["gift_message_available"],
        giftWrappingAvailable: json["gift_wrapping_available"],
        isReturnable: json["is_returnable"],
        status: json["status"],
        visibility: json["visibility"],
        quantityAndStockStatus:
            QuantityAndStockStatus.fromJson(json["quantity_and_stock_status"]),
        allowOpenAmount: json["allow_open_amount"],
        giftcardType: json["giftcard_type"],
        isRedeemable: json["is_redeemable"],
        useConfigIsRedeemable: json["use_config_is_redeemable"],
        lifetime: json["lifetime"],
        useConfigLifetime: json["use_config_lifetime"],
        useConfigEmailTemplate: json["use_config_email_template"],
        allowMessage: json["allow_message"],
        useConfigAllowMessage: json["use_config_allow_message"],
        plSizeChart: json["pl_size_chart"],
        weight: json["weight"],
        openAmountMin: json["open_amount_min"],
        openAmountMax: json["open_amount_max"],
        options: List<dynamic>.from(json["options"].map((x) => x)),
        mediaGallery: MediaGallery.fromJson(json["media_gallery"]),
        extensionAttributes:
            ExtensionAttributes.fromJson(json["extension_attributes"]),
        giftcardAmounts:
            List<dynamic>.from(json["giftcard_amounts"].map((x) => x)),
        categoryIds: List<String>.from(json["category_ids"].map((x) => x)),
        isSalable: json["is_salable"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        websiteIds: List<String>.from(json["website_ids"].map((x) => x)),
        categoryLinks: List<String>.from(json["category_links"].map((x) => x)),
        stockItem: StockItem.fromJson(json["stock_item"]),
        customAttributes: (json["custom_attributes"] is Map)
            ? List<dynamic>.from(
            json["custom_attributes"]["specificiation"].map((x) => x))
            : List<dynamic>.from(json["custom_attributes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId,
        "attribute_set_id": attributeSetId,
        "type_id": typeId,
        "sku": sku,
        "has_options": hasOptions,
        "required_options": requiredOptions,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "row_id": rowId,
        "created_in": createdIn,
        "updated_in": updatedIn,
        "name": name,
        "page_layout": pageLayout,
        "options_container": optionsContainer,
        "url_key": urlKey,
        "email_template": emailTemplate,
        "gift_message_available": giftMessageAvailable,
        "gift_wrapping_available": giftWrappingAvailable,
        "is_returnable": isReturnable,
        "status": status,
        "visibility": visibility,
        "quantity_and_stock_status": quantityAndStockStatus.toJson(),
        "allow_open_amount": allowOpenAmount,
        "giftcard_type": giftcardType,
        "is_redeemable": isRedeemable,
        "use_config_is_redeemable": useConfigIsRedeemable,
        "lifetime": lifetime,
        "use_config_lifetime": useConfigLifetime,
        "use_config_email_template": useConfigEmailTemplate,
        "allow_message": allowMessage,
        "use_config_allow_message": useConfigAllowMessage,
        "pl_size_chart": plSizeChart,
        "weight": weight,
        "open_amount_min": openAmountMin,
        "open_amount_max": openAmountMax,
        "options": List<dynamic>.from(options.map((x) => x)),
        "media_gallery": mediaGallery.toJson(),
        "extension_attributes": extensionAttributes.toJson(),
        "giftcard_amounts": List<dynamic>.from(giftcardAmounts.map((x) => x)),
        "category_ids": List<dynamic>.from(categoryIds.map((x) => x)),
        "is_salable": isSalable,
        "thumbnail": thumbnail,
        "price": price,
        "website_ids": List<dynamic>.from(websiteIds.map((x) => x)),
        "category_links": List<dynamic>.from(categoryLinks.map((x) => x)),
        "stock_item": stockItem.toJson(),
        "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x)),
      };
}

class ExtensionAttributes {
  ExtensionAttributes();

  factory ExtensionAttributes.fromRawJson(String str) =>
      ExtensionAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes();

  Map<String, dynamic> toJson() => {};
}

class MediaGallery {
  MediaGallery({
    this.images,
    this.values,
  });

  List<dynamic> images;
  List<dynamic> values;

  factory MediaGallery.fromRawJson(String str) =>
      MediaGallery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
        images: List<dynamic>.from(json["images"].map((x) => x)),
        values: List<dynamic>.from(json["values"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x)),
        "values": List<dynamic>.from(values.map((x) => x)),
      };
}

class QuantityAndStockStatus {
  QuantityAndStockStatus({
    this.isInStock,
    this.qty,
  });

  bool isInStock;
  int qty;

  factory QuantityAndStockStatus.fromRawJson(String str) =>
      QuantityAndStockStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuantityAndStockStatus.fromJson(Map<String, dynamic> json) =>
      QuantityAndStockStatus(
        isInStock: json["is_in_stock"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "is_in_stock": isInStock,
        "qty": qty,
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

  factory StockItem.fromRawJson(String str) =>
      StockItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        itemId: json["item_id"],
        productId: json["product_id"],
        stockId: json["stock_id"],
        qty: json["qty"],
        minQty: json["min_qty"],
        useConfigMinQty: json["use_config_min_qty"],
        isQtyDecimal: json["is_qty_decimal"],
        backorders: json["backorders"],
        useConfigBackorders: json["use_config_backorders"],
        minSaleQty: json["min_sale_qty"],
        useConfigMinSaleQty: json["use_config_min_sale_qty"],
        maxSaleQty: json["max_sale_qty"],
        useConfigMaxSaleQty: json["use_config_max_sale_qty"],
        isInStock: json["is_in_stock"],
        lowStockDate: json["low_stock_date"],
        notifyStockQty: json["notify_stock_qty"],
        useConfigNotifyStockQty: json["use_config_notify_stock_qty"],
        manageStock: json["manage_stock"],
        useConfigManageStock: json["use_config_manage_stock"],
        stockStatusChangedAuto: json["stock_status_changed_auto"],
        useConfigQtyIncrements: json["use_config_qty_increments"],
        qtyIncrements: json["qty_increments"],
        useConfigEnableQtyInc: json["use_config_enable_qty_inc"],
        enableQtyIncrements: json["enable_qty_increments"],
        isDecimalDivided: json["is_decimal_divided"],
        websiteId: json["website_id"],
        deferredStockUpdate: json["deferred_stock_update"],
        useConfigDeferredStockUpdate: json["use_config_deferred_stock_update"],
        typeId: json["type_id"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "product_id": productId,
        "stock_id": stockId,
        "qty": qty,
        "min_qty": minQty,
        "use_config_min_qty": useConfigMinQty,
        "is_qty_decimal": isQtyDecimal,
        "backorders": backorders,
        "use_config_backorders": useConfigBackorders,
        "min_sale_qty": minSaleQty,
        "use_config_min_sale_qty": useConfigMinSaleQty,
        "max_sale_qty": maxSaleQty,
        "use_config_max_sale_qty": useConfigMaxSaleQty,
        "is_in_stock": isInStock,
        "low_stock_date": lowStockDate,
        "notify_stock_qty": notifyStockQty,
        "use_config_notify_stock_qty": useConfigNotifyStockQty,
        "manage_stock": manageStock,
        "use_config_manage_stock": useConfigManageStock,
        "stock_status_changed_auto": stockStatusChangedAuto,
        "use_config_qty_increments": useConfigQtyIncrements,
        "qty_increments": qtyIncrements,
        "use_config_enable_qty_inc": useConfigEnableQtyInc,
        "enable_qty_increments": enableQtyIncrements,
        "is_decimal_divided": isDecimalDivided,
        "website_id": websiteId,
        "deferred_stock_update": deferredStockUpdate,
        "use_config_deferred_stock_update": useConfigDeferredStockUpdate,
        "type_id": typeId,
      };
}
