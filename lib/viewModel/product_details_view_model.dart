import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/product%20details/CitiesDeliveryInfoModel.dart';
import 'package:jawhara/model/product%20details/add_comment.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/model/product%20details/reviews.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import '../view/index.dart';
import 'dart:convert';

class ProductDetailsViewModel extends BaseViewModel {
  ProductDetailsViewModel();

  final HandlingError handle = HandlingError.handle;

  CommonApi _api = CommonApi();
  ProductDetails productDetails;
  Reviews reviews;
  List<Option> color = [];
  List<Option> size = [];
  ConfigurableProductLink selectOption;
  int qty = 1;

  // ConfigurableItemOptions itemOptions;
  List<ConfigurableItemOption> itemOptions = [];

  Option cacheColor = Option();
  Option cacheSize = Option();

  bool reviewLoad = false;
  bool citiesLoad = false;
  bool cartLoad = false;
  bool buyTogether = false;
  bool alreadyTried = false;

  List<CityDeliveryInfoItem> citiesDeliveryInfoItems = [];
  CityDeliveryInfoItem selectedCity;

  // Add Comment
  final GlobalKey<FormState> commentForm = GlobalKey<FormState>();
  ReviewComment review = ReviewComment();

  final Loading _loading = Loading();
  bool autoValidate = false;

  bool get _canSubmitComment => commentForm.currentState.validate();

  void get _saveSubmitComment => commentForm.currentState.save();

  // ====

  // init product details data
  initScreen(context, Product product) async {
    initCitiesDeliveryInfo(context);
    initRating(context, product);
    setBusy(true);
    final r = await _api.getProductDetails(context, product);
    if (r != null) {
      productDetails = r;
      // print(productDetails.toJson());
      setBusy(false);
      if (productDetails.configurableProductOptions != null) {
        productDetails.configurableProductOptions.forEach((element) {
          if (element.label == 'Color') {
            color = element.options;
          } else if (element.label == 'Size') {
            size = element.options;
          }
        });
      }
    }
  }

  // Check if product expire or not
  bool checkExpire(ProductDetails p) {
    bool specialExpire = p.specialFromDate != null ? !p.specialFromDate.isAfter(DateTime.now()) : false;
    return specialExpire;
    // return false;
  }

  // Check if product have sale
  String initSale(ProductDetails p) {
    if (checkExpire(p) && p.specialPrice != null) {
      var sale = ((double.parse(p.price) - double.parse(p.specialPrice)) / double.parse(p.price)) * 100;
      print(sale);
      return sale.toInt().toString();
    } else {
      return '';
    }
  }

  initRating(context, Product product) async {
    reviewLoad = true;
    notifyListeners();
    final r = await _api.getReviews(context, product);
    print('getReviews => ${r}');
    reviewLoad = false;
    if (r != null) {
      reviews = r;
    } else {
      reviews = Reviews(data: [], ratings: 5);
    }
    notifyListeners();
  }

  initCitiesDeliveryInfo(context) async {
    citiesLoad = true;
    notifyListeners();
    final cdiResponse = await _api.getCitiesDeliveryInfo(context);
    print('cdiResponse => $cdiResponse');
    citiesLoad = false;
    if (cdiResponse != null) {
      citiesDeliveryInfoItems = cdiResponse.citiesDeliveryItems;
    } else {
      citiesDeliveryInfoItems = [];
    }
    notifyListeners();
  }

  setSelectedCity(CityDeliveryInfoItem item) {
    selectedCity = item;
    notifyListeners();
  }

  addToCart(context) async {
    print('addTocAtt');
    cartLoad = true;
    notifyListeners();
    final r = await _api.addToCartData(context, productDetails, qty.toString(), itemOptions);
    print('r => $r');
    if (r == null && !alreadyTried) {
      //user not have active cart
      locator<CartViewModel>().initScreen(context, afterEnd: () {
        alreadyTried = true;
        addToCart(context);
      });
    }

    if (r == true) {
      handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.greenColor, value: translate('added_to_cart'));
      locator<CartViewModel>().initScreen(context);
    }
    cartLoad = false;
    notifyListeners();
  }

  addBuyTogetherBundleToCart(context, products) async {
    print('buyTogether');
    buyTogether = true;
    notifyListeners();
    var r = await _api.addToCartData(context, productDetails, qty.toString(), itemOptions);
    for (ProductDetails p in products) {
      r = await _api.addToCartData(context, p, "1", []);
    }
    print('r => $r');
    if (r == null) {
      buyTogether = false;
      notifyListeners();
    }
    if (r) {
      handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.greenColor, value: translate('added_to_cart'));
      locator<CartViewModel>().initScreen(context);
      buyTogether = false;
      notifyListeners();
    }
    buyTogether = false;
    notifyListeners();
  }

  addQuantity(context) {
    double max = double.parse(productDetails.stockItem.qty);
    if (max > qty) {
      qty++;
      notifyListeners();
    } else {
      handle.showError(context: context, error: translate('max_stock') + max.roundToDouble().toString());
    }
  }

  subQuantity() {
    if (qty > 1) {
      qty--;
      notifyListeners();
    }
  }

  switchImage(context, String e, Option option) {
    final p = productDetails.configurableProductLinks.firstWhere((element) {
      return element.color == option.valueIndex || element.size == option.valueIndex;
    }, orElse: () => null);
    selectOption = p;
    if (e == 'color') {
      cacheColor = option;
      // print('cacheColor => ' + cacheColor.valueIndex);
      size.forEach((elementSize) {
        productDetails.configurableProductLinks.forEach((elementLink) {
          // print('${elementLink.color + ' ' + elementLink.size + ' - ' + elementLink.name}');
          if (cacheColor.valueIndex == elementLink.color && elementSize.valueIndex == elementLink.size) {
            // print('found');
            elementSize.isCheck = 1;
            final checkOption =
                itemOptions.firstWhere((element) => element.optionValue == int.parse(option.valueIndex), orElse: () => null);
            if (checkOption == null) {
              itemOptions.add(ConfigurableItemOption(
                  optionId: productDetails.configurableProductOptions[0].attributeId, optionValue: int.parse(option.valueIndex)));
            }
            notifyListeners();
          } else {
            elementSize.isCheck = 0;
          }
        });
      });
    }
    if (e == 'size') {
      cacheSize = option;
      // print('cacheSize => ' + cacheSize.valueIndex);
      color.forEach((elementColor) {
        productDetails.configurableProductLinks.forEach((elementLink) {
          // print('${elementLink.color + ' ' + elementLink.size + ' - ' + elementLink.name}');
          if (cacheSize.valueIndex == elementLink.size && elementColor.valueIndex == elementLink.color) {
            // print('found');
            elementColor.isCheck = 1;
            final checkOption =
                itemOptions.firstWhere((element) => element.optionValue == int.parse(option.valueIndex), orElse: () => null);
            if (checkOption == null) {
              itemOptions.add(ConfigurableItemOption(
                  optionId: productDetails.configurableProductOptions[1].attributeId, optionValue: int.parse(option.valueIndex)));
            }
            notifyListeners();
          } else {
            elementColor.isCheck = 0;
          }
        });
      });
    }
  }

  updateCommentRating(double value) {
    review.ratings = [Rating(ratingName: 'Rating', value: value.toInt())];
  }

  updateCommentTitle(String value) => review.title = value;

  updateCommentDetail(String value) => review.detail = value;

  updateCommentNickname(String value) => review.nickname = value;

  // Submit
  submit(context) async {
    review.entityPkValue = int.parse(productDetails.entityId);
    review.reviewEntity = "product";
    if(review.ratings == null){
      handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.redColor, value: translate('select_rating'));
      return;
    }
    _loading.init();
    autoValidate = true;
    if (!_canSubmitComment) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitComment;
      AddComment addComment;
      addComment = AddComment(review: review);
      final r = await _api.submitComment(context, addComment);
      if (r != null) {
        // var d = jsonDecode(r);
        handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.greenColor, value: translate('saved_rating'));
        commentForm.currentState.reset();
      }
    }
    BotToast.closeAllLoading();
  }
}

class ConfigurableItemOptions {
  ConfigurableItemOptions({
    this.configurableItemOptions,
  });

  List<ConfigurableItemOption> configurableItemOptions;

  factory ConfigurableItemOptions.fromRawJson(String str) => ConfigurableItemOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableItemOptions.fromJson(Map<String, dynamic> json) => ConfigurableItemOptions(
        configurableItemOptions: json["configurable_item_options"] == null
            ? null
            : List<ConfigurableItemOption>.from(json["configurable_item_options"].map((x) => ConfigurableItemOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "configurable_item_options":
            configurableItemOptions == null ? null : List<dynamic>.from(configurableItemOptions.map((x) => x.toJson())),
      };
}

class ConfigurableItemOption {
  ConfigurableItemOption({
    this.optionId,
    this.optionValue,
  });

  String optionId;
  int optionValue;

  factory ConfigurableItemOption.fromRawJson(String str) => ConfigurableItemOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigurableItemOption.fromJson(Map<String, dynamic> json) => ConfigurableItemOption(
        optionId: json["option_id"] == null ? null : json["option_id"],
        optionValue: json["option_value"] == null ? null : json["option_value"],
      );

  Map<String, dynamic> toJson() => {
        "option_id": optionId == null ? null : optionId,
        "option_value": optionValue == null ? null : optionValue,
      };
}
