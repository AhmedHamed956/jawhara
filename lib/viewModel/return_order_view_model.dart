import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/model/return/reasons.dart';
import 'package:jawhara/model/return/return_details.dart';
import 'package:jawhara/model/return/return_history.dart';

import '../view/index.dart';

class ReturnOrderViewModel extends BaseViewModel {
  ReturnOrderViewModel();

  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  CommonApi _api = CommonApi();
  final Loading _loading = Loading();
  bool autoValidate = false;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  List<ReturnItem> items;
  Data data;
  String comment;
  TextEditingController commentText = TextEditingController();

  //return product
  Reasons reasons = Reasons();
  Reasons condition = Reasons();
  Reasons resolution = Reasons();
  String orderItemId;
  String reasonValue;
  String conditionValue;
  String resolutionValue;

  // init return orders
  initScreen(context, [orderId]) async {
    print('init return orders');
    // setBusy(true);
    final r = await _api.getReturnOrderHistory(context);
    if (r != null) {
      print('here');
      items = [];
      for (var i in r.items) {
        if (orderId == null || i.orderIncrementId == orderId) {
          items.add(i);
        }
      }
      print(items.length);
      // setBusy(false);
    }
  }

  // init return orders
  initScreenDetail(context, String returnID, {bool isLoad = true}) async {
    print('init return order details');
    if (isLoad) setBusy(true);
    final r = await _api.getReturnDetails(context, returnID);
    if (r != null) {
      print('here');
      data = r.data;
      setBusy(false);
    }
  }

  // init Reasons
  initReasonsData(context) async {
    print('init Reasons');
    setBusy(true);
    try {
      final r = await _api.getReasonsData(context, 'reason');
      if (r != null) {
        print('reasons');
        reasons = r;
      }
    } catch (e) {}
    try {
      final r = await _api.getReasonsData(context, 'condition');
      if (r != null) {
        print('condition');
        condition = r;
      }
    } catch (e) {}
    try {
      final r = await _api.getReasonsData(context, 'resolution');
      if (r != null) {
        print('resolution');
        resolution = r;
      }
    } catch (e) {}
    setBusy(false);
  }

// submit comment
  addComment(context) async {
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.addCommentData(context, data.returnId, comment);
      if (r != null) {
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: r.items.message);
        initScreenDetail(context, data.orderId, isLoad: false);
        commentText.clear();
      }
    }
    BotToast.closeAllLoading();
  }

  // submit return
  submitReturn(context, MyOrdersItem item) async {
    _loading.init();
    autoValidate = true;
    print(orderItemId);
    if (orderItemId == null ||
        reasonValue == null ||
        conditionValue == null ||
        resolutionValue == null ||
        comment == null) {
      BotToast.closeAllLoading();
      handle.alertFlush(
          context: context,
          icon: Icons.close,
          color: AppColors.redColor,
          value: 'Empty Field');
    } else {
      _saveSubmitLogin;
      final r = await _api.submitReturnOrder(context,
          message: comment,
          email: item.billingAddress.email,
          orderId: item.incrementId,
          orderItemID: orderItemId,
          qty: '1',
          condition: conditionValue,
          reason: reasonValue,
          resolution: resolutionValue);
      if (r != null) {
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: r.data.message);
        commentText.clear();
        Navigator.pop(context, true);
      }
    }
    BotToast.closeAllLoading();
  }

  updateComment(String value) => comment = value;

  updateProductReturn(String value) => orderItemId = value;

  updateReason(String value) => reasonValue = value;

  updateCondition(String value) => conditionValue = value;

  updateResolution(String value) => resolutionValue = value;
}
