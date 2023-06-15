import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/model/return/reasons.dart';
import 'package:jawhara/model/return/return_details.dart';
import 'package:jawhara/model/return/return_history.dart';

import '../view/index.dart';

class CancelOrderViewModel extends BaseViewModel {
  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  CommonApi _api = CommonApi();
  final Loading _loading = Loading();
  bool autoValidate = false;

  void get _saveSubmitLogin => userForm.currentState.save();

  Data data;
  String comment;
  TextEditingController commentText = TextEditingController();

  //return product
  List<String> reasons = [];
  String reasonValue;

  // init Reasons
  initReasonsData(context) async {
    print('init Reasons');
    setBusy(true);
    try {
      final r = await _api.getCancelOrderReasonsData(context);
      if (r != null) {
        print('reasons');
        reasons = r;
      }
    } catch (e) {
      print(e.toString());
    }
    setBusy(false);
  }

  // submit Cancel
  submitCancel(context, MyOrdersItem item, bool isFromDetailOrder) async {
    _loading.init();
    autoValidate = true;
    if (reasonValue == null || comment == null) {
      BotToast.closeAllLoading();
      handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate("fillMandatoryData"));
    } else {
      _saveSubmitLogin;
      final r = await _api.submitCancelOrder(
        context,
        comment: comment,
        orderId: item.entityId,
        reason: reasonValue,
      );
      if (r != null && r) {
        handle.alertFlush(
            context: context, icon: Icons.done_all, color: AppColors.greenColor, value: translate("orderCanceledSuccessfully"));
        commentText.clear();
        if (isFromDetailOrder) Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    }
    BotToast.closeAllLoading();
  }

  updateComment(String value) => comment = value;

  updateReason(String value) => reasonValue = value;
}
