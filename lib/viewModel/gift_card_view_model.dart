import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';

class GiftCardViewModel extends BaseViewModel {
  GiftCardViewModel();

  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  CommonApi _api = CommonApi();
  final Loading _loading = Loading();
  bool autoValidate = false;
  String giftId;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  // Gift card
  checkBalance(context) async {
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.getBalanceGiftCard(context, giftId);
      if (r != null) {
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: translate('balance') + ' ' + r.toString() + ' ' + SharedData.currency);
      }
    }
    BotToast.closeAllLoading();
  }

  // Redeem card
  redeemCard(context) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);

    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.redeemGiftCard(context, _auth.currentUser.id.toString(), giftId);
      if (r != null) {
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: r.toString());
      }
    }
    BotToast.closeAllLoading();
  }
}
