import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/cards/card_payments.dart';
import 'package:jawhara/model/cart/cart.dart';
import 'package:jawhara/model/cart/checkout.dart';
import 'package:jawhara/model/cart/magento_complete_payment.dart';
import 'package:jawhara/model/cart/order_payment.dart';
import 'package:jawhara/model/cart/payment_methods.dart';
import 'package:jawhara/model/cart/shipping_method.dart';
import 'package:jawhara/model/points/points.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/ui/cart/failed.dart';
import 'package:jawhara/view/ui/cart/success.dart';
import 'package:jawhara/view/widgets/credit_card/common_payment_widgets.dart';
import 'package:jawhara/view/widgets/credit_card/credit_card_model.dart';
import 'package:jawhara/view/widgets/credit_card/credit_card_widget.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/points_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:jawhara/viewModel/wallet_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import '../view/index.dart';

class CartViewModel extends BaseViewModel {
  CartViewModel();

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingGiftController = TextEditingController();

  CommonApi _api = CommonApi();
  Cart cart = Cart();
  ShippingMethod defaultShipping = ShippingMethod();
  Checkout checkout = Checkout();
  PaymentMethods paymentMethod = PaymentMethods();
  PaymentMethod selectedMethod;
  final Loading _loading = Loading();
  bool isCouponLoad = false;
  bool isGiftLoad = false;
  bool isCheckoutLoad = false;
  bool isCheckoutLoadFailed = false;
  bool isMethodLoad = false;
  final HandlingError handle = HandlingError.handle;

  static const platform = MethodChannel('jawhara.channels/payment');
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  List<Product> youMightLikeProducts = [];

  List<TotalSegment> totalSegments;
  TotalSegment giftCardSegment = TotalSegment();

  double currentWalletBalance;
  bool payWithWallet = false;
  Data currentPoints;
  bool usePoints = false;
  bool addNewCard = false;
  bool useSavedCard = false;
  bool rememberMe = false;
  CardPayments cardPayments = CardPayments();

  // init Shop cart
  // Todo reclean code
  initScreen(context, {afterEnd}) async {
    rememberMe = false;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final _cartId = await getCartIdFromCache();
    _auth.checkUser();
    Strings.DEFAULT_SHIPPING_CART = "guest-carts/${SharedData.cartId}/estimate-shipping-methods";
    if (_auth.currentUser == null) {
      if (_cartId == null) {
        final result = await _api.initCart(context);
        if (result != null) {
          print("result > $result");
          SharedData.cartId = result;
          // SharedData.guestCartId = result;
          Strings.CART_MINE = "guest-carts/${SharedData.cartId}/";
          final r = await _api.getCartData(context);
          if (r != null) {
            print('r => ${r.toJson()}');
            cart = r;
            SharedData.quoteId = cart.id.toString();
            saveCardIdCache(SharedData.cartId);
          }
        }
      } else {
        print('[next]');
        final r = await _api.getCartData(context);
        if (r != null) {
          print('r => ${r.toJson()}');
          cart = r;
          SharedData.quoteId = cart.id.toString();
          print(SharedData.quoteId);
          print(SharedData.cartId);
        }
      }
    } else {
      print('get cart 🛒');
      setBusy(true);
      final r = await _api.getCartData(context);
      if (r != null) {
        print('r => ${r.toJson()}');
        cart = r;
        SharedData.quoteId = cart.id.toString();
        if (r.id == null) {
          final result = await _api.initCart(context);
          if (result != null) {
            initScreen(context);
          }
        }
      } else {
        print('else > cart');
        final result = await _api.initCart(context);
        if (result != null) {
          initScreen(context);
        }
      }
      setBusy(false);
    }
    if (cart.items != null && cart.items.isNotEmpty) initCheckOut(context);
    if (_auth.currentUser != null && cart.items != null && cart.items.isNotEmpty) {
      initYouMightLikeProducts(context);
    }
    if (afterEnd != null) {
      afterEnd();
    }
  }

  // Save cart id in cache
  Future<void> saveCardIdCache(String cardId) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("cardId", cardId);
    print(_pref.getKeys());
    getCartIdFromCache();
  }

  // delete cart id in cache
  Future<void> deleteCardIdCache(String cardId) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("cardId");
  }

  // Get from cache
  Future<String> getCartIdFromCache() async {
    print('getCartIdFromCache');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    SharedData.cartId = _pref.get("cardId");
    // SharedData.guestCartId = _pref.get("cardId");
    // notifyListeners();
    return SharedData.cartId;
  }

  initCheckOut(context) async {
    print('##### [initCheckOut] #####');
    isCheckoutLoad = true;
    isCheckoutLoadFailed = false;
    notifyListeners();
    final r = await _api.getCustomCheckOutData(navigatorKey.currentContext);
    if (r != null) {
      print('Checkout Result => ${r.toJson()}');
      checkout = r;
      // if(checkout.shippingAmount == null || checkout.shippingAmount == 0){
      //   initDefaultShipping(context);
      // }
      paymentMethod.totals = checkout;
      totalSegments = r.totalSegments;
      final result = totalSegments.firstWhere((element) => element.code == 'giftcardaccount', orElse: () => null);
      if (result != null) {
        giftCardSegment = result;
        var giftCardText = jsonDecode(giftCardSegment.extensionAttributes.giftCards);
        textEditingGiftController.text = giftCardText[0]['c'];
      } else {
        giftCardSegment = TotalSegment();
      }
      isCheckoutLoad = false;
      notifyListeners();
    } else {
      isCheckoutLoad = false;
      isCheckoutLoadFailed = true;
      notifyListeners();
    }
  }

  initDefaultShipping(context) async {
    print('get default shipping');
    final r = await _api.getDefaultShippingMethodData(context);
    if (r != null) {
      print('r => ${r.toJson()}');
      defaultShipping = r;
      notifyListeners();
    }
  }

  initYouMightLikeProducts(context) async {
    print('get you might like products');
    final r = await _api.getYouMightLikeProducts(context);
    if (r != null) {
      print('r => ${r.length}');
      youMightLikeProducts = r;
      notifyListeners();
    }
  }

  initPaymentMethod(context) async {
    print('get payment methods');
    isMethodLoad = true;
    selectedMethod = null;
    notifyListeners();
    // Todo walled
    // currentWalletBalance = locator<WalletViewModel>().currentBalance;
    // if (currentWalletBalance == null) {
    //   locator<WalletViewModel>().initScreen(context, onComplete: () {
    //     currentWalletBalance = locator<WalletViewModel>().currentBalance;
    //     notifyListeners();
    //   });
    // }
    // Todo points
    // currentPoints = locator<PointsViewModel>().data;
    // if (currentPoints == null || currentPoints.reward == null || currentPoints.reward.currencyBalance == null) {
    //   locator<PointsViewModel>().initScreen(context, onComplete: () {
    //     currentPoints = locator<PointsViewModel>().data;
    //     notifyListeners();
    //   });
    // }
    final _data = locator<ShippingAddressViewModel>();
    // print(_data.customerId);
    final r = await _api.getPaymentMethodsData(context, shippingMethod: _data.defaultShippingMethod);
    if (r != null) {
      paymentMethod = r;
      notifyListeners();
    }
    isMethodLoad = false;
    notifyListeners();
  }

  addCoupon(context) async {
    print('add coupon');
    if (textEditingController.text != '') {
      isCouponLoad = true;
      notifyListeners();
      final r = await _api.addCouponData(context, textEditingController.text);
      if (r == true) {
        initCheckOut(context);
        isCouponLoad = false;
        notifyListeners();
      }
      isCouponLoad = false;
      notifyListeners();
    }
  }

  deleteCoupon(context) async {
    print('add coupon');
    isCouponLoad = true;
    notifyListeners();
    final r = await _api.deleteCouponData(context);
    if (r == true) {
      textEditingController.clear();
      initCheckOut(context);
      isCouponLoad = false;
      notifyListeners();
    }
    isCouponLoad = false;
    notifyListeners();
  }

  addGiftCard(context) async {
    print('add gift card');
    if (textEditingGiftController.text != '') {
      isGiftLoad = true;
      notifyListeners();
      final r = await _api.addGiftCardData(context, textEditingGiftController.text);
      if (r == true) {
        initCheckOut(context);
        isGiftLoad = false;
        notifyListeners();
      }
      isGiftLoad = false;
      notifyListeners();
    }
  }

  deleteGiftCard(context) async {
    print('delete gift card');
    isGiftLoad = true;
    notifyListeners();
    final r = await _api.deleteGiftCardData(context, textEditingGiftController.text);
    if (r == true) {
      textEditingGiftController.clear();
      initCheckOut(context);
      isGiftLoad = false;
      notifyListeners();
    }
    isGiftLoad = false;
    notifyListeners();
  }

  addQty(context, Item item) async {
    print('add cart +');
    _loading.init();
    final r = await _api.addQtyItem(context, item);
    if (r == true) {
      BotToast.closeAllLoading();
      final updateItem = cart.items.firstWhere((element) => element.itemId == item.itemId);
      updateItem.qty = item.qty + 1;
      notifyListeners();
      initCheckOut(context);
    }
    BotToast.closeAllLoading();
  }

  subtractQty(context, Item item) async {
    print('subtract cart -');
    if (item.qty > 1) {
      _loading.init();
      final r = await _api.subtractQtyItem(context, item);
      if (r == true) {
        BotToast.closeAllLoading();
        final updateItem = cart.items.firstWhere((element) => element.itemId == item.itemId);
        updateItem.qty = item.qty - 1;
        notifyListeners();
        initCheckOut(context);
      }
      BotToast.closeAllLoading();
    }
  }

  removeItem(context, Item item) async {
    print('remove item');
    _loading.init();
    final r = await _api.removeItem(context, item);
    if (r == true) {
      BotToast.closeAllLoading();
      final updateItem = cart.items.firstWhere((element) => element.itemId == item.itemId);
      cart.items.remove(updateItem);
      notifyListeners();
      initCheckOut(context);
    }
    BotToast.closeAllLoading();
  }

  placeOrder(context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "", deviceType = "";
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      deviceType = "iOS";
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
    } else {
      deviceType = "Android";
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    }
    print('place order');
    print(selectedMethod?.toJson() ?? "");
    print("useSavedCard >$useSavedCard");

    if ((selectedMethod?.code ?? "") == 'cashondelivery') {
      _loading.init();
      final r = await _api.placeOrderData(context, deviceType: '$deviceType :: $deviceName');
      if (r != null) {
        BotToast.closeAllLoading();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(r.split(":")[0])));
      }
    }
    // Todo staging
    else if (useSavedCard) {
      final checkSavedCard = cardPayments.data.firstWhere((element) => element.check == true);
      _loading.init();
      if (cvvCode.isEmpty) {
        BotToast.closeAllLoading();
        handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('cvvCodeValidate'));
        return;
      }
      final r = await _api.placeOrderData(context, deviceType: '$deviceType :: $deviceName');
      print('## [place order] ##=> $r');
      if (r != null && checkSavedCard != null) {
        print('### SAVED CARD ###');
        String orderId = r.split(":")[1].toString();
        String orderNumber = r.split(":")[0].toString();
        final resultPayment = await _api.placeOrderWithSavedCard(context, orderNumber, checkSavedCard.publicHash, cvvCode);
        print('resultPayment > $resultPayment');
        if (resultPayment["success"]) {
          print("PAYMENT SUCCESS!!");
          setBusy(true);
          if (resultPayment['params']["3ds_url"] != null) {
            String createdDate = DateFormat('MMM d, yyyy hh:mm:ss a', "en").format(DateTime.now());
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => MagentoCompletePayment(
                      isSavedCard: true,
                      thirdRedirectURL: resultPayment['params']["3ds_url"],
                      onFinish: (status) async {
                        if (status == "cancel") {
                          setBusy(true);
                          await _api.updateOrderPaymentCancel(orderId, createdDate);
                          print("### Payment has been canceled ###");
                          initScreen(context);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_canceled'))));
                          setBusy(false);
                        } else {
                          setBusy(true);
                          try {
                            Future.delayed(Duration(seconds: 3), () async {
                              String orderPaymentSuccess = await _api.getOrderPaymentStatus(orderId);
                              print('orderPaymentSuccess >$orderPaymentSuccess');
                              if (orderPaymentSuccess == 'processing') {
                                print("### orderPaymentSuccess ###");
                                initScreen(context);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(orderId.toString())));
                                setBusy(false);
                              } else if (orderPaymentSuccess == 'canceled') {
                                print("### orderPaymentCanceled ###");
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
                                locator<CartViewModel>().initScreen(context, afterEnd: () {
                                  (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(4);
                                  handle.alertFlush(
                                      context: StackedService.navigatorKey.currentContext,
                                      icon: Icons.close,
                                      color: AppColors.redColor,
                                      value: translate('payment_error'));
                                });
                                // setBusy(false);
                              } else {
                                print("### Payment Error, try again! ###");
                                initScreen(context);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_error'))));
                                setBusy(false);
                              }
                            });
                          } catch (ex) {
                            print("### Something went wrong, try again! ###");
                            print("### $ex ###");
                            initScreen(context);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('something_wrong'))));
                            setBusy(false);
                          }
                        }
                      })),
            );
          }
        } else {
          print("PAYMENT FAIL!!");
          setBusy(true);
          initScreen(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_failed'))));
          setBusy(false);
        }
      }
    } else if (selectedMethod != null || payWithWallet) {
      if (payWithWallet) {
        final res = await _api.payWithWallet(context, paymentMethod.totals.baseGrandTotal);
        if (res == null) {
          handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('errorWhilePayingFromWallet'));
          initScreen(context, afterEnd: () {
            Navigator.of(context).pop();
          });
          return;
        }
      }
      _loading.init();
      if ((cardNumber != '' && expiryDate != '' && cardHolderName != '' && cvvCode != '') ||
          (payWithWallet && currentWalletBalance >= paymentMethod.totals.grandTotal)) {
        CreditCardValidator _ccValidator = CreditCardValidator();
        var ccNumResults = _ccValidator.validateCCNum(cardNumber);
        var expDateResults = _ccValidator.validateExpDate(expiryDate);
        var cvvResults = _ccValidator.validateCVV(cvvCode, ccNumResults.ccType);
        if (ccNumResults.isValid == false) {
          BotToast.closeAllLoading();
          handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('ccNumValidate'));
          return;
        }
        if (expDateResults.isValid == false) {
          BotToast.closeAllLoading();
          handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('expDateValidate'));
          return;
        }
        if (cvvResults.isValid == false) {
          BotToast.closeAllLoading();
          handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: cvvResults.message);
          return;
        }

        final r = await _api.placeOrderData(context, deviceType: '$deviceType :: $deviceName');
        print('[place order] => $r');
        if (r != null && (!payWithWallet || paymentMethod.totals.grandTotal > currentWalletBalance)) {
          print('###HERE1####');
          final _auth = Provider.of<AuthViewModel>(context, listen: false);
          final address = locator<ShippingAddressViewModel>().defaultMyAddress;
          String orderDescription = cart.items.first.sku;
          OrderPaymentData orderPaymentData;
          List expire = expiryDate.split('/');
          String orderId = r.split(":")[1].toString();
          String orderNumber = r.split(":")[0].toString();
          // final orderNumber = await _api.getOrderIncrementId(orderEntityId: orderId);
          print('## [orderId] ### > $orderId');
          print('## [orderNumber] ### > $orderNumber');
          orderPaymentData = OrderPaymentData(
            cardNumber: cardNumber,
            cardHolderName: cardHolderName,
            expiryDate: "${expire[1]}${expire[0]}",
            ccv: cvvCode,
            amount: payWithWallet
                ? (paymentMethod.totals.grandTotal - currentWalletBalance).toString()
                : paymentMethod.totals.baseGrandTotal.toString(),
            orderId: orderNumber.toString(),
            customerEmail: _auth.currentUser.email,
            customerName: _auth.currentUser.firstname + ' ' + _auth.currentUser.lastname,
            phoneNumber: address.telephone,
            orderDescription: orderDescription,
            merchantExtra: "Mobile_${deviceType}_${deviceName.replaceAll(" ", "_")}",
          );
          print('##[orderPaymentData]## > ${orderPaymentData.toJson()}');
          final resultPayment = await _api.orderPayment(orderPaymentData, rememberMe);
          print('resultPayment > $resultPayment');
          if (resultPayment["success"]) {
            print("PAYMENT SUCCESS!!");
            setBusy(true);
            if (resultPayment["3ds_url"] != null) {
              String createdDate = DateFormat('MMM d, yyyy hh:mm:ss a', "en").format(DateTime.now());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => MagentoCompletePayment(
                        isSavedCard: false,
                        thirdRedirectURL: resultPayment["3ds_url"],
                        onFinish: (status) async {
                          if (status == "cancel") {
                            setBusy(true);
                            await _api.updateOrderPaymentCancel(orderId, createdDate);
                            print("### Payment has been canceled ###");
                            initScreen(context);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_canceled'))));
                            setBusy(false);
                          } else {
                            setBusy(true);
                            try {
                              Future.delayed(Duration(seconds: 3), () async {
                                String orderPaymentSuccess = await _api.getOrderPaymentStatus(orderId);
                                print('orderPaymentSuccess >$orderPaymentSuccess');
                                if (orderPaymentSuccess == 'processing') {
                                  print("### orderPaymentSuccess ###");
                                  initScreen(context);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(orderId.toString())));
                                  setBusy(false);
                                } else if (orderPaymentSuccess == 'canceled') {
                                  print("### orderPaymentCanceled ###");
                                  Navigator.of(context)
                                      .pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
                                  locator<CartViewModel>().initScreen(context, afterEnd: () {
                                    (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(4);
                                    handle.alertFlush(
                                        context: StackedService.navigatorKey.currentContext,
                                        icon: Icons.close,
                                        color: AppColors.redColor,
                                        value: translate('payment_error'));
                                  });
                                  // setBusy(false);
                                } else {
                                  print("### Payment Error, try again! ###");
                                  initScreen(context);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_error'))));
                                  setBusy(false);
                                }
                              });
                            } catch (ex) {
                              print("### Something went wrong, try again! ###");
                              print("### $ex ###");
                              initScreen(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('something_wrong'))));
                              setBusy(false);
                            }
                          }
                        })),
              );
            }
          } else {
            print("PAYMENT FAIL!!");
            setBusy(true);
            initScreen(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Failed(orderId.toString(), translate('payment_failed'))));
            setBusy(false);
          }
          // Map<String, Object> args;
          // args = {
          //   "customerToken": Strings.USER_TOKEN,
          //   "amount": payWithWallet
          //       ? (paymentMethod.totals.grandTotal - currentWalletBalance).toString()
          //       : paymentMethod.totals.grandTotal.toString(),
          //   "currency": cart.currency.baseCurrencyCode.toString(),
          //   "paymentType": "DB",
          //   "orderId": r.split(":")[1].toString(),
          //   "lang": SharedData.lang,
          //   "tokenized": false,
          //   "saveCard": true,
          //   "cardNumber": cardNumber,
          //   "cardHolderName": cardHolderName,
          //   "expirationDate": expiryDate,
          //   "cvv": cvvCode,
          //   "brand": CommonPaymentWidgets.detectCCType(cardNumber) == CardType.visa
          //       ? "VISA"
          //       : (CommonPaymentWidgets.detectCCType(cardNumber) == CardType.mastercard ? "MASTER" : null)
          // };
          // print('args > $args');
          // final Map result = await platform.invokeMethod('hyperPayPayment', args);
          // if (result["success"]) {

          // } else {

          // }
        } else {
          print('###HERE2####');
          // initScreen(context);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(r.split(":")[0])));
        }
      } else {
        handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('enter_card_credit'));
      }
      BotToast.closeAllLoading();
    } else {
      handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('select_pay_method'));
    }
  }

  changeSelectedMethod(context, PaymentMethod method) async {
    // print('select method > ${method.toJson()}');
    if (method.code == "cashondelivery") {
      payWithWallet = false;
    }
    if (method.code != "cashondelivery") {
      try {
        _loading.init();
        final resultCardPayments = await _api.getCardPayments(context);
        cardPayments = resultCardPayments;
        addNewCard = true;
        BotToast.closeAllLoading();
        notifyListeners();
      } on Exception catch (e) {
        BotToast.closeAllLoading();
      }
    }

    paymentMethod.paymentMethods.forEach((element) {
      if (element.code == method.code) {
        element.selected = true;
        selectedMethod = element;
      } else {
        element.selected = false;
      }
    });
    notifyListeners();
  }

  payWithWalletCheckboxChanged(bool value) {
    payWithWallet = value;
    paymentMethod.paymentMethods.forEach((element) {
      element.selected = false;
      selectedMethod = null;
    });
    notifyListeners();
  }

  usePointsCheckboxChanged(bool value) {
    usePoints = value;
    notifyListeners();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    notifyListeners();
  }

  subTotal(Item item) {
    double subTotal = double.parse((item.extensionAttributes.priceIncludingTax?.toString() ?? item.price?.toString() ?? '0')) * item.qty;
    return subTotal.toString();
  }
}
