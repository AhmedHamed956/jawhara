import 'dart:convert' as convert;

import 'package:dio/dio.dart';

// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:jawhara/core/config/locator.dart';
import 'package:jawhara/core/config/shared_data.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/model/cards/card_payments.dart';
import 'package:jawhara/model/cart/cart.dart';
import 'package:jawhara/model/cart/checkout.dart';
import 'package:jawhara/model/cart/order_payment.dart';
import 'package:jawhara/model/cart/payment_methods.dart';
import 'package:jawhara/model/cart/shipping_method.dart';
import 'package:jawhara/model/categories/categories_model.dart';
import 'package:jawhara/model/home/home.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/model/orders/track_information.dart';
import 'package:jawhara/model/points/alert.dart';
import 'package:jawhara/model/points/check.dart';
import 'package:jawhara/model/points/history.dart' as history;
import 'package:jawhara/model/points/points.dart';
import 'package:jawhara/model/product%20details/CitiesDeliveryInfoModel.dart';
import 'package:jawhara/model/product%20details/add_comment.dart';
import 'package:jawhara/model/product%20details/gift_card_details.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/model/product%20details/reviews.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/model/products/products.dart';
import 'package:jawhara/model/products/selected_filter.dart';
import 'package:jawhara/model/return/comment.dart';
import 'package:jawhara/model/return/reasons.dart';
import 'package:jawhara/model/return/return_details.dart' as rd;
import 'package:jawhara/model/return/return_history.dart';
import 'package:jawhara/model/search/search_item.dart';
import 'package:jawhara/model/search/search_product_item.dart';
import 'package:jawhara/model/shipping%20address/city_model.dart';
import 'package:jawhara/model/shipping%20address/countries.dart';
import 'package:jawhara/model/shipping%20address/my_address.dart' as myAd;
import 'package:jawhara/model/shipping%20address/state_model.dart';
import 'package:jawhara/model/wishlist/wishlist.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/product_details_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'package:http/http.dart' as http;

class CommonApi extends Api {
  Future<Categories> getCategoriesData(context) async {
    try {
      // Dio Request
      print(
        getCurrentMainApi() + Strings.MOBILE + Strings.CATEGORIES,
      );
      var response = await dio.get(getCurrentMainApi() + Strings.MOBILE + Strings.CATEGORIES,
          options: Options(
            headers: await getHeaders(),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return Categories.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Products> getProductsData(context, id, {List<SelectedFilterItem> filterItems, int page = 1, pageSize = 10}) async {
    // print('field : ${field.filterCode.toString()} , value : ${value.value.toString()}');

    // Todo dynamic filters
    var categoryId = 'searchCriteria[filter_groups][0][filters][0][field]=category_id' +
        '&' +
        'searchCriteria[filter_groups][0][filters][0][value]=$id' +
        '&' +
        'searchCriteria[sortOrders][0][field]=position'
            '&' +
        'searchCriteria[sortOrders][0][direction]=ASC'
            '&' +
        'searchCriteria[current_page]=${page.toString()}&searchCriteria[page_size]=$pageSize';
    var queryParameter = "";

    int filterGroupIndex = 0;
    int filterIndex;
    for (SelectedFilterItem sfi in filterItems ?? []) {
      filterGroupIndex++;
      if (sfi.price) {
        queryParameter += '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][field]=${sfi.field.filterCode}' +
            '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][value]=${sfi.rangeValue.start}'
                '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][condition_type]=from';
        filterGroupIndex++;

        queryParameter += '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][field]=${sfi.field.filterCode}' +
            '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][value]=${sfi.rangeValue.end}'
                '&' +
            'searchCriteria[filter_groups][$filterGroupIndex][filters][0][condition_type]=to';
      } else if (sfi.field != null || sfi.values != null) {
        filterIndex = 0;
        for (FilterOption fo in sfi.values) {
          queryParameter += '&' +
              'searchCriteria[filter_groups][$filterGroupIndex][filters][$filterIndex][field]=${sfi.field.filterCode}' +
              '&' +
              'searchCriteria[filter_groups][$filterGroupIndex][filters][$filterIndex][value]=${fo.value}';
          filterIndex++;
        }
      }

      // if (sfi.field != null) {
      //   if (sfi.field.filterCode == 'climate') {
      //     queryParameter = queryParameter +
      //         '&searchCriteria[filter_groups][1][filters][0][condition_type]=finset';
      //   }
      //   // if (field.filterCode == 'price') {
      //   //   queryParameter = queryParameter + '11111111';
      //   // }
      // }
    }

    print(getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '?' + categoryId + queryParameter);
    try {
      var url = getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '?' + categoryId + queryParameter;
      // Dio Request
      // dio.interceptors
      //     .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);

      var response = await dio.get(url,
          // options: buildCacheOptions(Duration(days: 7),
          //     maxStale: Duration(days: 10),
          options: Options(
            headers: await getHeaders(),
          )
          // )
          );
      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: 'decoded',
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Products.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['mess age']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<List<Product>> getYouMightLikeProducts(context) async {
    print(getCurrentMainApi() + Strings.YOU_MIGHT_LIKE);
    try {
      var url = getCurrentMainApi() + Strings.YOU_MIGHT_LIKE;
      // Dio Request
      // dio.interceptors
      //     .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));
      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: 'decoded',
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        List<Product> products = [];
        for (var item in decoded["items"]) {
          products.add(Product.fromJson(item));
        }
        return products;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['mess age']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Home> getHomeData(context) async {
    print(getCurrentMainApi() + Strings.MOBILE + Strings.BLOCKS + Strings.HOME);
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.MOBILE + Strings.BLOCKS + Strings.HOME,
          options: Options(
            headers: await getHeaders(),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Home.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<ProductDetails> getProductDetails(context, Product product) async {
    print(getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '/${(product.sku ?? 'id/${product.entityId}')}');
    try {
      // Dio Request
      var response =
          await dio.get(getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '/${(product.sku ?? 'id/${product.entityId}')}',
              options: Options(
                headers: await getHeaders(),
              ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // print('response.data <${response.data}');
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return ProductDetails.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<GiftCardDetails> getGiftDetails(context, Product product) async {
    print(getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '/${product.sku}');
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.MOBILE + Strings.PRODUCTS + '/${product.sku}',
          options: Options(
            headers: await getHeaders(),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return GiftCardDetails.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Reviews> getReviews(context, Product product) async {
    print(getCurrentMainApi() + Strings.PRODUCTS + '/${(product.sku ?? 'id/${product.entityId}')}/' + Strings.REVIEWS);
    try {
      // Dio Request
      var response =
          await dio.get(getCurrentMainApi() + Strings.PRODUCTS + '/${(product.sku ?? 'id/${product.entityId}')}/' + Strings.REVIEWS,
              options: Options(
                headers: await getHeaders(),
              ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Reviews.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<dynamic> submitComment(context, AddComment addComment) async {
    var url = getCurrentMainApi() + Strings.REVIEWS;
    print(url);
    print(addComment.toJson());

    try {
      // Dio Request

      var response = await dio.post(url,
          data: addComment.toJson(),
          options: Options(
            headers: await getHeaderUser(Strings.ADMIN_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // print(response.data);
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> initCart(context) async {
    var url;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    if (_auth.currentUser == null)
      url = getCurrentMainApi() + Strings.GUEST_CART;
    else
      url = getCurrentMainApi() + Strings.CART_MINE;
    try {
      // Dio Request
      var response = await dio.post(url,
          options: Options(
            headers: _auth.currentUser == null ? await getHeaders() : await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return response.data.toString();
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      // if(dioError.error.toString().contains("404")){ //no cart so create one
      //
      // }else {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
      // }
    }
  }

  Future<Cart> getCartData(context, {createNewIfNone = true}) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print('getCartData');
    var url = getCurrentMainApi() + Strings.CART_MINE;
    print(url);
    try {
      // Dio Request
      var response = await dio.get(url,
          options: Options(
            headers: _auth.currentUser == null ? await getHeaders() : await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Cart.fromJson(response.data);
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      // if (dioError.error.toString().contains("404") && createNewIfNone) {
      //   //no cart so create one
      //   // todo this enter in loop of call !!!
      //   await initCart(context);
      //   return getCartData(context, createNewIfNone: false);
      // } else {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      // handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
      // }
    }
  }

  Future<Checkout> getCheckOutData(context) async {
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.TOTAL);
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.CART_MINE + Strings.TOTAL,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Checkout.fromJson(response.data);
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Checkout> getCustomCheckOutData(context) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print(getCurrentMainApi() + Strings.MOBILE + Strings.CART_MINE_FIXED + Strings.TOTAL);
    print({"cartId": _auth.currentUser == null ? SharedData.cartId : SharedData.quoteId, "isGuest": _auth.currentUser == null});
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.MOBILE + Strings.CART_MINE_FIXED + Strings.TOTAL,
          data: {"cartId": _auth.currentUser == null ? SharedData.cartId : SharedData.quoteId, "isGuest": _auth.currentUser == null});

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Checkout.fromJson(response.data);
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      // handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<PaymentMethods> getPaymentMethodsData(context, {ShippingMethod shippingMethod}) async {
    var cartModel = locator<CartViewModel>();
    bool onlyGiftCards = true;
    for (Item item in cartModel.cart.items) {
      if (item.productType != "giftcard") {
        onlyGiftCards = false;
        break;
      }
    }

    try {
      var response;
      // Dio Request
      if (onlyGiftCards) {
        var url = getCurrentMainApi() + Strings.CART_MINE + Strings.PAYMENT_INFORMATION;
        response = await dio.get(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));
      } else {
        final address = locator<ShippingAddressViewModel>().defaultMyAddress;
        final billing = locator<ShippingAddressViewModel>().billingAddress;

        var cityToSendIndex = locator<ShippingAddressViewModel>().arCities.indexOf(address.city);
        var billingCityToSendIndex = locator<ShippingAddressViewModel>().arCities.indexOf(billing.city);

        var url = getCurrentMainApi() + Strings.CART_MINE + Strings.SHIPPING_INFORMATION;
        print(url);
        var data = {
          "addressInformation": {
            "shipping_address": {
              "customer_id": address.customerId,
              "region": address.region.region,
              "region_id": 0,
              "country_id": address.countryId,
              "street": address.street,
              "company": "",
              "telephone": address.telephone,
              "postcode": address.postcode,
              "city": cityToSendIndex == -1 ? address.city : locator<ShippingAddressViewModel>().enCities[cityToSendIndex],
              "firstname": address.firstname,
              "lastname": address.lastname
            },
            "billing_address": {
              "customer_id": billing.customerId,
              "region": billing.region.region,
              "region_id": 0,
              "country_id": billing.countryId,
              "street": billing.street,
              "company": "",
              "telephone": billing.telephone,
              "postcode": billing.postcode,
              "city": billingCityToSendIndex == -1 ? billing.city : locator<ShippingAddressViewModel>().enCities[billingCityToSendIndex],
              "firstname": billing.firstname,
              "lastname": billing.lastname
            },
            "shipping_method_code": shippingMethod.methodCode,
            "shipping_carrier_code": shippingMethod.carrierCode,
          }
        };
        print(data);
        response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));
      }

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        print(response.data);
        return PaymentMethods.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Map<String, dynamic>> orderPayment(OrderPaymentData orderPaymentData, bool rememberMe) async {
    //Tokenization
    var tokenizationData = {
      "data": {
        "card_number": orderPaymentData.cardNumber.replaceAll(" ", ""),
        "expiry_date": orderPaymentData.expiryDate.replaceAll("/", ""),
        "card_holder_name": orderPaymentData.cardHolderName,
        "card_security_code": orderPaymentData.ccv
      }
    };
    print("tokenizationData > $tokenizationData");
    print("url > ${Uri.parse("${getCurrentMainApi()}payfort/tokenize")}");
    final tokenizeRes = await http.post(Uri.parse("${getCurrentMainApi()}payfort/tokenize"),
        body: convert.jsonEncode(tokenizationData), headers: {"Content-Type": "application/json"});
    print('### tokenizeRes> ${tokenizeRes.body} ###');
    print('### tokenizeRes> ${tokenizeRes.statusCode} ###');

    if (tokenizeRes.statusCode == 200) {
      print('### HERE 111 ###');
      print('### ${tokenizeRes.body} ###');

      Map tokenizedResponseData = convert.jsonDecode(tokenizeRes.body);
      print('### ${tokenizedResponseData} ###');
      if (tokenizedResponseData["token_name"] != null &&
          tokenizedResponseData["token_name"].isNotEmpty &&
          tokenizedResponseData["merchant_reference"] != null &&
          tokenizedResponseData["merchant_reference"].isNotEmpty) {
        //Authorization
        var authData = {
          "data": {
            "token_name": tokenizedResponseData["token_name"],
            "language": SharedData.lang,
            "amount": orderPaymentData.amount,
            "merchant_reference": orderPaymentData.orderId,
            "customer_email": orderPaymentData.customerEmail,
            // "payment_option": orderPaymentData.paymentOption,
            "customer_name": orderPaymentData.cardHolderName,
            "order_description": orderPaymentData.orderDescription,
            "phone_number": orderPaymentData.phoneNumber,
            "merchant_extra": orderPaymentData.merchantExtra,
            // Todo Staging
            "remember_me": rememberMe ? "YES" : "NO"
          }
        };
        print('### HERE 333 ###');
        print('### $authData ###');
        final authRes = await http.post(Uri.parse("${getCurrentMainApi()}payfort/authorize"),
            body: convert.jsonEncode(authData), headers: {"Content-Type": "application/json"});

        if (authRes.statusCode == 200) {
          Map authResponseData = convert.jsonDecode(authRes.body);
          if (authResponseData["3ds_url"] != null && authResponseData["3ds_url"].isNotEmpty) {
            return Future.value({
              "success": true,
              "3ds_url": authResponseData["3ds_url"],
              "merchant_reference": tokenizedResponseData["merchant_reference"]
            });
          } else {
            if (authResponseData["response_message"] != null) {
              return Future.value({"success": false, "message": authResponseData["response_message"]});
            } else {
              return Future.value({"success": false});
            }
          }
        }
      } else {
        if (tokenizedResponseData["response_message"] != null) {
          return Future.value({"success": false, "message": tokenizedResponseData["response_message"]});
        } else {
          return Future.value({"success": false});
        }
      }
    }
    print('### HERE 222 ###');
    return Future.value({"success": false});
  }

  Future<String> getOrderIncrementId({orderEntityId}) async {
    try {
      print('URL > ${getCurrentMainApi()}orders/${orderEntityId.toString()}');
      var response = await http
          .get(Uri.parse("${getCurrentMainApi()}orders/$orderEntityId"), headers: {'Authorization': 'Bearer ' + Strings.ADMIN_TOKEN});
      print('respone getOrderIncrementId > ${response.statusCode}');
      print('respone getOrderIncrementId > ${response.body}');
      if (response.statusCode == 200) {
        print('respone getOrderIncrementId number> ${convert.jsonDecode(response.body)['number']}');
        return convert.jsonDecode(response.body)['number'];
      }
      return null;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> updateOrderPaymentCancel(orderId, createdDate) async {
    try {
      print('URL FOR CANCEL > "${getCurrentMainApi()}orders"');
      var response = await http.post(
        Uri.parse("${getCurrentMainApi()}orders"),
        body: convert.jsonEncode({
          "entity": {
            "entity_id": "$orderId",
            "status": "canceled",
            "status_histories": [
              {
                "comment": "Payfort_Fort :: Payment Cancelled",
                "created_at": "$createdDate",
                "is_customer_notified": 0,
                "is_visible_on_front": 1,
                "status": "canceled"
              }
            ]
          }
        }),
        headers: {'Authorization': 'Bearer ' + Strings.ADMIN_TOKEN, "content-type": "application/json"},
      );
      final body = convert.jsonDecode(response.body);
      print('order canccel > $body');
      if (body is Map && body["message"] != null) {
        throw Exception(body["message"]);
      } else {
        return true;
      }
    } catch (err) {
      return false;
    }
  }

  Future<String> getOrderPaymentStatus(String orderId) async {
    try {
      String url = "${getCurrentMainApi()}orders/$orderId/statuses";
      print('getOrderPaymentStatus url >$url');
      final res = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ' + Strings.ADMIN_TOKEN, "content-type": "application/json"},
      );

      if (res.statusCode == 200) {
        print('### statusCode ${res.statusCode} ###');
        print('### body ${res.body} ###');
        String body = convert.jsonDecode(res.body);
        return body;
      } else if (convert.jsonDecode(res.body)["message"] != null) {
        throw Exception(convert.jsonDecode(res.body)["message"]);
      } else {
        throw Exception("Can not get order payment status");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<String> placeOrderData(context, {deviceType = "mobile"}) async {
    final address = locator<ShippingAddressViewModel>().defaultMyAddress;
    final billing = locator<ShippingAddressViewModel>().billingAddress;
    final cart = locator<CartViewModel>();

    var url = getCurrentMainApi() + Strings.CART_MINE + Strings.PAYMENT_INFORMATION;
    print(url);

    var cartModel = locator<CartViewModel>();
    bool onlyGiftCards = true;
    for (Item item in cartModel.cart.items) {
      if (item.productType != "giftcard") {
        onlyGiftCards = false;
        break;
      }
    }

    var data;

    if (onlyGiftCards) {
      data = {
        "paymentMethod": {
          "method": ((cart.payWithWallet && cart.paymentMethod.totals.grandTotal > cart.currentWalletBalance) || !cart.payWithWallet)
              ? cart.selectedMethod.code
              : "walletsystem",
          // Todo production
          "extension_attributes": {"mobile_type": deviceType}
        },
      };
    } else {
      data = {
        "paymentMethod": {
          "method": ((cart.payWithWallet && cart.paymentMethod.totals.grandTotal > cart.currentWalletBalance) || !cart.payWithWallet)
              ? cart.selectedMethod.code
              : "walletsystem",
          // Todo production
          "extension_attributes": {"mobile_type": deviceType}
        },
        "billingAddress": {
          "customer_id": billing.customerId,
          "region": billing.region.region,
          "region_id": 0,
          "country_id": billing.countryId,
          "street": billing.street,
          "company": "",
          "telephone": billing.telephone,
          "postcode": billing.postcode,
          "city": billing.city,
          "firstname": billing.firstname,
          "lastname": billing.lastname,
          "custom_attributes": List<dynamic>.from(billing.customAttributes.map((x) => x.toJson()))
        },
        "shippingAddress": {
          "customer_id": address.customerId,
          "region": address.region.region,
          "region_id": 0,
          "country_id": address.countryId,
          "street": address.street,
          "company": "",
          "telephone": address.telephone,
          "postcode": address.postcode,
          "city": address.city,
          "firstname": address.firstname,
          "lastname": address.lastname,
          "custom_attributes": List<dynamic>.from(address.customAttributes.map((x) => x.toJson()))
        },
      };
    }
    print('[DATA PlaceOrder] >  $data');
    try {
      if (cart.usePoints) {
        await useRewardData(context);
      } else {
        print("cart.usePoints > ${cart.usePoints}");
        // Todo back again to fix issue here
        // await removeRewardData(context);
      }

      // Dio Request
      // if (cart.payWithWallet &&
      //     cart.currentWalletBalance >= cart.paymentMethod.totals.grandTotal) {
      //   var res = await dio.post(
      //       getCurrentMainApi() +
      //           Strings.CART_MINE +
      //           Strings.SET_PAYMENT_INFORMATION,
      //       data: {
      //         "paymentMethod": {"method": "walletsystem"}
      //       },
      //       options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));
      //   if (!handle.isValidResponse(res.statusCode)) {
      //     handle.showError(context: context, error: res.data['message']);
      //     return null;
      //   }
      // }
      if (cart.payWithWallet) {
        var res = await dio.post(getCurrentMainApi() + Strings.CART_MINE + Strings.SET_PAYMENT_INFORMATION_AND_GET_TOTALS,
            data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

        if (!handle.isValidResponse(res.statusCode)) {
          handle.showError(context: context, error: res.data['message']);
          return null;
        }
        // else {
        //   getCustomCheckOutData(context);
        //   // payWithWallet(context, res.data["base_grand_total"]);
        // }
      }
      print('url > $url');
      print('data > $data');
      print('USER_TOKEN > ${Strings.USER_TOKEN}');
      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;
      print('## response payment information ##  > ${response.data}');

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        print(response.data);
        var response2 = await dio.get("${getCurrentMainApi() + "mobile/me/orders/${response.data}"}",
            options: Options(
              headers: await getHeaderUser(Strings.USER_TOKEN),
            ));

        // Decoding Response.
        var decoded2 = response2.data;

        return "${decoded2["increment_id"]}:${response.data}";
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> updateOrderPaymentSuccess(orderId, amount, currency, merchantReference, createdDate, token) async {
    try {
      var response = await dio.post(
        "${getCurrentMainApi()}/orders",
        data: convert.jsonEncode({
          "entity": {
            "entity_id": "$orderId",
            "status": "processing",
            "base_total_paid": double.parse(amount.toString()),
            "total_paid": double.parse(amount.toString()),
            "status_histories": [
              {
                "comment": "Captured amount of $currency$amount online. Transaction ID: $merchantReference",
                "created_at": "$createdDate",
                "is_customer_notified": 0,
                "is_visible_on_front": 1,
                "status": "PAYMENT_STATUS_SUCCESS"
              },
              {
                "comment": "Payfort_Fort :: Order has been paid.",
                "created_at": "$createdDate",
                "is_customer_notified": 1,
                "is_visible_on_front": 1,
                "status": "processing"
              },
            ]
          }
        }),
        options: Options(headers: {'Authorization': 'Bearer ' + token, "content-type": "application/json"}),
      );
      final body = convert.jsonDecode(response.data);
      if (body is Map && body["message"] != null) {
        throw Exception(body["message"]);
      } else {
        return true;
      }
    } catch (err) {
      return false;
    }
  }

  Future<bool> updateOrderPaymentFail(orderId, createdDate, token) async {
    try {
      var response = await dio.post(
        "${getCurrentMainApi()}/orders",
        data: convert.jsonEncode({
          "entity": {
            "entity_id": "$orderId",
            "status": "payfort_fort_failed",
            "status_histories": [
              {
                "comment": "Failed to Capture the Authorised Amount",
                "created_at": "$createdDate",
                "is_customer_notified": 0,
                "is_visible_on_front": 1,
                "status": "payfort_fort_failed"
              }
            ]
          }
        }),
        options: Options(headers: {'Authorization': 'Bearer ' + token, "content-type": "application/json"}),
      );
      final body = convert.jsonDecode(response.data);
      if (body is Map && body["message"] != null) {
        throw Exception(body["message"]);
      } else {
        return true;
      }
    } catch (err) {
      return false;
    }
  }

  // Future<bool> updateOrderPaymentCancel(orderId, createdDate, token) async {
  //   try {
  //     var response = await dio.post(
  //       "${getCurrentMainApi()}/orders",
  //       data: convert.jsonEncode({
  //         "entity": {
  //           "entity_id": "$orderId",
  //           "status": "canceled",
  //           "status_histories": [
  //             {
  //               "comment": "Payfort_Fort :: Payment Cancelled",
  //               "created_at": "$createdDate",
  //               "is_customer_notified": 0,
  //               "is_visible_on_front": 1,
  //               "status": "canceled"
  //             }
  //           ]
  //         }
  //       }),
  //       options: Options(headers: {'Authorization': 'Bearer ' + token, "content-type": "application/json"}),
  //     );
  //     final body = convert.jsonDecode(response.data);
  //     if (body is Map && body["message"] != null) {
  //       throw Exception(body["message"]);
  //     } else {
  //       return true;
  //     }
  //   } catch (err) {
  //     return false;
  //   }
  // }

  Future<bool> addToCartData(context, ProductDetails product, String qty, List<ConfigurableItemOption> itemOptions) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print(getCurrentMainApi() + Strings.CART_MINE);
    var data = {
      "cartItem": {
        "sku": product.sku,
        "qty": qty,
        "quote_id": SharedData.quoteId,
        "product_option": {
          "extension_attributes": {"configurable_item_options": itemOptions}
        }
      }
    };
    print(data);
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS,
          data: data,
          options: Options(
            headers: _auth.currentUser == null ? await getHeaders() : await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      print('response code > ${response.statusCode}');
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "Error code: ${dioError.response.statusCode}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: checkResponseData(dioError.response.data['message']));
      // handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> addToCartGiftData(
      context, GiftCardDetails gift, String qty, amount, senderName, senderEmail, recipientName, recipientEmail, message) async {
    print(getCurrentMainApi() + Strings.CART_MINE);
    var data = {
      "cartItem": {
        "sku": gift.sku,
        "qty": qty,
        "quote_id": SharedData.quoteId,
        "product_option": {
          "extension_attributes": {
            "giftcard_item_option": {
              "giftcard_amount": "custom",
              "custom_giftcard_amount": amount,
              "giftcard_sender_name": senderName,
              "giftcard_sender_email": senderEmail,
              "giftcard_recipient_name": recipientName,
              "giftcard_recipient_email": recipientEmail,
              "giftcard_message": message
            }
          }
        }
      }
    };
    print(data);
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> addQtyItem(context, Item item) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString());
    var data = {
      "cartItem": {
        "sku": item.sku,
        "qty": item.qty + 1,
        "quoteId": SharedData.quoteId,
      }
    };
    print(data);
    try {
      // Dio Request
      var response = await dio.put(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString(),
          data: data,
          options: Options(
            headers: _auth.currentUser == null ? await getHeaders() : await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> subtractQtyItem(context, Item item) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString());
    var data = {
      "cartItem": {
        "sku": item.sku,
        "qty": item.qty - 1,
        "quoteId": SharedData.quoteId,
      }
    };
    print(data);
    try {
      // Dio Request
      var response = await dio.put(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString(),
          data: data,
          options: Options(
            headers: _auth.currentUser == null ? await getHeaders() : await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> removeItem(context, Item item) async {
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString());
    var data = {
      "cartItem": {
        "sku": item.sku,
        "qty": item.qty,
        "quoteId": SharedData.quoteId,
      }
    };
    print(data);
    try {
      // Dio Request
      var response = await dio.delete(getCurrentMainApi() + Strings.CART_MINE + Strings.ITEMS + '/' + item.itemId.toString(),
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> addCouponData(context, String text) async {
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.COUPONS + '/' + text);
    try {
      // Dio Request
      var response = await dio.put(getCurrentMainApi() + Strings.CART_MINE + Strings.COUPONS + '/' + text,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> deleteCouponData(context) async {
    print(getCurrentMainApi() + Strings.CART_MINE + Strings.COUPONS);
    try {
      // Dio Request
      var response = await dio.delete(getCurrentMainApi() + Strings.CART_MINE + Strings.COUPONS,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<myAd.MyAddress> getMyAddressData(context, id) async {
    print('### GET ADDRESS');
    var url = getCurrentMainApi() + Strings.CUSTOMERS + '/' + id;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return myAd.MyAddress.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> deleteAddressData(context, id) async {
    var url = getCurrentMainApi() + Strings.ADDRESSES + '/' + id;
    print(url);
    try {
      // Dio Request

      var response = await dio.delete(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return false;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return false;
    }
  }

  Future<bool> addNewAddressData(context, myAd.Address address, email, landMark, altPhone, @deprecated district) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.ADDRESSES;
    print(url);
    Map data = {
      "address": {
        "customer_id": address.customerId,
        "region": {"region_code": 0, "region": 'region', "region_id": 0},
        "country_id": address.countryId,
        "street": [
          address.street[0],
        ],
        "firstname": address.firstname,
        "lastname": address.lastname,
        "default_shipping": address.defaultShipping,
        "default_billing": true,
        "telephone": address.telephone,
        "postcode": address.postcode,
        "city": address.city,
        "custom_attributes": [
          {"attribute_code": "alt_phone_number", "value": altPhone},
          {"attribute_code": "add_email", "value": email},
          // {"attribute_code": "district", "value": district},
          {"attribute_code": "nearest_landmark", "value": landMark}
        ]
      }
    };
    print(data);
    try {
      // Dio Request

      var response = await dio.post(url, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        print(response.data.toString());
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return false;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return false;
    }
  }

  Future<bool> editAddressData(context, addressId, myAd.Address defaultMyAddress) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.ADDRESSES;
    print(url);
    Map data = {
      "address": {
        "id": addressId,
        "customer_id": defaultMyAddress.customerId,
        "region": {"region_code": defaultMyAddress.region.regionCode, "region": defaultMyAddress.region.region, "region_id": 0},
        "country_id": defaultMyAddress.countryId,
        "street": [defaultMyAddress.street[0]],
        "firstname": defaultMyAddress.firstname,
        "lastname": defaultMyAddress.lastname,
        "default_shipping": defaultMyAddress.defaultShipping,
        "default_billing": true,
        "telephone": defaultMyAddress.telephone,
        "postcode": defaultMyAddress.postcode,
        "city": defaultMyAddress.city
      }
    };
    print(data);
    try {
      // Dio Request

      var response = await dio.post(url, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        print(response.data.toString());
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return false;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return false;
    }
  }

  Future<bool> changeDefaultAddress(context, addressId, customerId) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.ADDRESSES;
    print(url);
    Map data = {
      "address": {
        "id": addressId,
        "customer_id": customerId,
        "default_shipping": true,
      }
    };
    print(data);
    try {
      // Dio Request

      var response = await dio.post(url, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        print(response.data.toString());
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return false;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return false;
    }
  }

  Future<CountriesModel> getCountriesData(context) async {
    var url = getCurrentMainApi() + Strings.COUNTRIES;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return CountriesModel.fromJson(response.data[0]);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<StateModel> getStateData(context) async {
    var url = getCurrentMainApi() + Strings.STATES_AVAILABLE;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return StateModel.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CityModel> getCityData(context, {lang}) async {
    var url = getCurrentMainApi(lang: lang) + Strings.CITES_AVAILABLE + Strings.STATE_SAUDI;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return CityModel.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CitiesDeliveryInfoModel> getCitiesDeliveryInfo(context) async {
    var url = getCurrentMainApi() + Strings.CITIES_DELIVERY_INFO.replaceAll("LANG", SharedData.lang);
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return CitiesDeliveryInfoModel.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<ShippingMethodsModel> getShippingMethodData(context, myAd.Address defaultMyAddress, {city}) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.CART_MINE + Strings.ESTIMATE_SHIP_METHOD;
    print(url);
    var data = {
      "address": {
        "customer_id": defaultMyAddress.customerId,
        "country_id": defaultMyAddress.countryId,
        "street": [
          defaultMyAddress.street[0],
        ],
        "telephone": defaultMyAddress.telephone,
        "postcode": defaultMyAddress.postcode,
        "city": city != null ? city : defaultMyAddress.city,
        "firstname": defaultMyAddress.firstname,
        "lastname": defaultMyAddress.lastname
      }
    };
    print(data);
    try {
      // Dio Request

      var response = await dio.post(url,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: data,
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return ShippingMethodsModel.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<ShippingMethod> getDefaultShippingMethodData(context) async {
    var url = getCurrentMainApi() + Strings.DEFAULT_SHIPPING_CART;
    print(url);
    var data = {
      "address": {"city": "", "region": "Saudi Arabia", "country_id": "SA", "postcode": ""}
    };
    try {
      // Dio Request

      var response = await dio.post(url,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.ADMIN_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return ShippingMethod.fromJson(response.data[0]);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<MyOrders> getMyOrdersData(context, {String status = 'pending', page}) async {
    print('status > $status');
    var url = getCurrentMainApi() +
        Strings.MOBILE +
        Strings.MY_ORDERS +
        (status == 'all_orders'
            ? '?searchCriteria[sortOrders][0][field]=entity_id&searchCriteria[sortOrders][0][direction]=DESC' +
                '&searchCriteria[current_page]=$page&searchCriteria[page_size]=5'
            : '?searchCriteria[filterGroups][0][filters][0][field]=status&searchCriteria[filterGroups][0][filters][0][value]=$status&searchCriteria[filterGroups][0][filters][0][conditionType]=eq' +
                '&searchCriteria[current_page]=$page&searchCriteria[page_size]=5');
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return MyOrders.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<TrackInformation> getTrack(context, String orderId) async {
    var url = getCurrentMainApi() + Strings.ORDER_TRACK_INFO + orderId;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.ADMIN_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      print('response.data > ${response.data.runtimeType}');
      if (handle.isValidResponse(response.statusCode)) {
        print('Success');
        print(response.data == []);
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return response.data.isEmpty ? null : TrackInformation.fromJson(response.data[0]);
      } else {
        print('Failed');

        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> reOrder(context, int orderId) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);

    var url = getCurrentMainApi() + Strings.MOBILE + Strings.MY_ORDERS + '/reorder/$orderId';
    print(url);
    var data = {"id": orderId, "Customer_id": _auth.currentUser.id};
    print(data);
    try {
      // Dio Request

      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> addWishItem(context, String id) async {
    var url = getCurrentMainApi() + Strings.WISH_LIST + Strings.WISH_LIST_ADD + id;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> removeWishItem(context, String wishItemId) async {
    var url = getCurrentMainApi() + Strings.WISH_LIST + Strings.WISH_LIST_DEL + wishItemId;
    print(url);
    try {
      // Dio Request
      var response = await dio.delete(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<WishListModel> getWishList(context) async {
    var url = getCurrentMainApi() + Strings.WISH_LIST + Strings.ITEMS;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return WishListModel.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<SearchItem> getSearchItem(context, text, {lang}) async {
    var url = getCurrentMainApi(lang: lang) +
        Strings.MOBILE_SEARCH +
        '?searchCriteria[requestName]=quick_search_container&searchCriteria[filter_groups][0][filters][0][field]=search_term&searchCriteria[filter_groups][0][filters][0][value]=$text&searchCriteria[filter_groups][0][filters][0][conditionType]=like&searchCriteria[filter_groups][1][filters][0][field]=visibility&searchCriteria[filter_groups][1][filters][0][value]=4';
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        try {
          return SearchItem.fromJson(response.data);
        } catch (e) {
          return null;
        }
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      // handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<SearchProductItem> getSearchProductItem(context, List<ItemSearch> items) async {
    var endPoint = '';
    for (int i = 0; i < items.length; i++) {
      endPoint = endPoint +
          ('${i != 0 ? "&" : ""}searchCriteria[filterGroups][0][filters][$i][field]=entity_id&searchCriteria[filterGroups][0][filters][$i][value]=${items[i].id}');
    }
    // print('endPo > $endPoint');
    var url = getCurrentMainApi() + Strings.PRODUCTS + '?' + endPoint;
    print('URL > $url');
    try {
      // Dio Request
      var response = await dio.get(url, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print(response.data);
        return SearchProductItem.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<dynamic> submitContact(context, name, phone, email, comment) async {
    var url = getCurrentMainApi() + Strings.CONTACT;
    print(url);
    var data = {
      "data": {"name": name, "telephone": phone, "email": email, "comment": comment}
    };
    try {
      // Dio Request

      var response = await dio.post(url,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // print(response.data);
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<dynamic> getBalanceGiftCard(context, giftId) async {
    var url = getCurrentMainApi() + Strings.CART_MINE + Strings.CHECK_GIFT_CARD + giftId;
    print(url);
    try {
      // Dio Request

      var response = await dio.get(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // print(response.data);
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> redeemGiftCard(context, customerId, giftId) async {
    var url = getCurrentMainApi() + Strings.CUSTOMER_ME + '/' + Strings.GIFT_CARD + Strings.REDEEM;
    print(url);
    var data = {"code": giftId, "for_customer_id": customerId};
    try {
      // Dio Request

      var response = await dio.post(url,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // print(response.data);
        return decoded['message'];
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> addGiftCardData(context, String giftId) async {
    var url = getCurrentMainApi() + Strings.CART_MINE + Strings.GIFT_CARDS;
    print(url);
    var data = {
      "giftCardAccountData": {
        "gift_cards": [giftId]
      }
    };
    try {
      // Dio Request
      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> deleteGiftCardData(context, giftId) async {
    var url = getCurrentMainApi() + Strings.CART_MINE + Strings.GIFT_CARDS + giftId;

    print(url);
    try {
      // Dio Request
      var response = await dio.delete(url,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Points> getPointsData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.REWARD + Strings.BALANCE + Strings.INFO;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Points.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<history.HistoryPoint> getHistoryData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.REWARD + Strings.BALANCE + Strings.HISTORY;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return history.HistoryPoint.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<AlertPoint> getAlertData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.REWARD + Strings.CART + Strings.ALERT;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return AlertPoint.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CheckPoint> getCheckAvailablePointData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.REWARD + Strings.CHECKOUT + Strings.PAYMENT;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return CheckPoint.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> useRewardData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.USE_REWARD;
    print(url);
    try {
      // Dio Request
      var response = await dio.post(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CheckData> removeRewardData(context) async {
    var url = getCurrentMainApi() + Strings.REWARD_MINE + Strings.REMOVE_REWARD;
    print(url);
    try {
      // Dio Request
      var response = await dio.delete(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return CheckData.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<ReturnHistory> getReturnOrderHistory(context) async {
    var url = getCurrentMainApi() + Strings.RETURN_MINE + Strings.RMA + Strings.HISTORY;
    print(url);
    try {
      // Dio Request
      var response = await dio.get(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return ReturnHistory.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<rd.ReturnDetails> getReturnDetails(context, String returnId) async {
    var url = getCurrentMainApi() + Strings.RETURN_MINE + Strings.RMA + returnId;
    print(url);
    try {
      // Dio Request
      var response = await dio.get(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return rd.ReturnDetails.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CommentResponse> addCommentData(context, String returnId, String message) async {
    var url = getCurrentMainApi() + Strings.RETURN_MINE + Strings.COMMENTS;
    print(url);
    var data = {
      "requests": {"return_increment_id": returnId, "comment": message}
    };
    try {
      // Dio Request
      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return CommentResponse.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<Reasons> getReasonsData(context, String endPoint) async {
    var url = getCurrentMainApi() + Strings.RETURN_ATTR_META + endPoint;
    print(url);
    try {
      // Dio Request
      var response = await dio.get(url, options: Options(headers: await getHeaderUser(Strings.ADMIN_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return Reasons.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<List<String>> getCancelOrderReasonsData(context) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.CANCEL_ORDER_REASONS;
    print(url);
    try {
      // Dio Request
      var response = await dio.get(url, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        List<String> data = [];
        for (var item in response.data) {
          data.add(item);
        }
        return data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CheckPoint> submitReturnOrder(context,
      {@required String orderId,
      @required String email,
      @required String orderItemID,
      @required String qty,
      @required String resolution,
      @required String condition,
      @required String reason,
      @required String message}) async {
    var url = getCurrentMainApi() + Strings.RETURN_MINE + Strings.RMA + Strings.SUBMIT;
    print(url);
    var data = {
      "order_id": orderId,
      "requests": {
        "customer_custom_email": email,
        "items": [
          {"order_item_id": orderItemID, "qty_requested": qty, "resolution": resolution, "condition": condition, "reason": reason}
        ],
        "rma_comment": message
      }
    };
    try {
      // Dio Request
      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: data,
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print('##' + response.data);
        return CheckPoint.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> submitCancelOrder(context, {@required String orderId, @required String reason, @required String comment}) async {
    var url = getCurrentMainApi() + Strings.MOBILE + Strings.CANCEL_ORDER + orderId;
    print(url);
    var data = {"reason": reason, "comment": comment};
    try {
      // Dio Request
      var response = await dio.post(url, data: data, options: Options(headers: await getHeaderUser(Strings.USER_TOKEN)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: data,
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        // print('##' + response.data);
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return false;
    }
  }

  Future<double> getWalletBalance(context) async {
    print(getCurrentMainApi() + Strings.WALLET_BALANCE);
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.WALLET_BALANCE,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        try {
          return double.tryParse(decoded["raw_balance"].toString());
        } catch (e) {
          return 0.0;
        }
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> payWithWallet(context, double grandTotal) async {
    print(getCurrentMainApi() + Strings.PAY_WITH_WALLET);
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.PAY_WITH_WALLET,
          data: {"wallet": "set", "grandtotal": "$grandTotal"},
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        //getCustomCheckOutData(context); //TODO: remove this
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return decoded["leftinWallet"];
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<CardPayments> getCardPayments(context) async {
    print(getCurrentMainApi() + Strings.SAVED_CARD);
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.SAVED_CARD,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return CardPayments.fromJson(response.data[0]);
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<dynamic> placeOrderWithSavedCard(context, String orderNumber, String publicHash, String cvv) async {
    print(getCurrentMainApi() + Strings.PLACE_ORDER_WITH_SAVED_CARD);
    var data = {"order_id": orderNumber, "public_hash": publicHash, "cvv": cvv};
    print('### placeOrderWithSavedCard data ## > $data');
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.PLACE_ORDER_WITH_SAVED_CARD,
          data: data,
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: "decoded",
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return decoded;
      } else {
        // Failed
        // handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.data ?? ""}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }
}
