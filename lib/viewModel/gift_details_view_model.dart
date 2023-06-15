import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/product%20details/gift_card_details.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/model/product%20details/reviews.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import '../view/index.dart';
import 'dart:convert';

class GiftDetailsViewModel extends BaseViewModel {
  GiftDetailsViewModel();

  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();

  CommonApi _api = CommonApi();
  final Loading _loading = Loading();
  bool autoValidate = false;

  GiftCardDetails giftCardDetails;
  bool cartLoad = false;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  String amount,senderName, senderEmail, recipientName, recipientEmail, message;
  int qty = 1;

  // init product details data
  initScreen(context, Product product) async {
    print('init gift screen details');
    setBusy(true);
    final r = await _api.getGiftDetails(context, product);
    if (r != null) {
      print('here');
      giftCardDetails = r;
      print(giftCardDetails.toJson());
      setBusy(false);
    }
  }

  addToCart(context) async {
    print('add To cart');
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.addToCartGiftData(
          context, giftCardDetails, qty.toString(),amount,senderName, senderEmail, recipientName, recipientEmail, message);
      print('r => $r');
      if (r == true) {
        handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.greenColor, value: translate('added_to_cart'));
        cartLoad = false;
        notifyListeners();
        locator<CartViewModel>().initScreen(context);
      }
    }
    BotToast.closeAllLoading();
  }

  addQuantity(context) {
    double max = double.parse(giftCardDetails.stockItem.maxSaleQty);
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
}
