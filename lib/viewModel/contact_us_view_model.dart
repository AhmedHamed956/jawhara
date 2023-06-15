import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';

class ContactUsViewModel extends BaseViewModel {
  ContactUsViewModel();

  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  CommonApi _api = CommonApi();
  final Loading _loading = Loading();
  bool autoValidate = false;
  String giftId;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  var name, phone, email, comment;

// Submit
  submit(context) async {
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.submitContact(context, name, phone, email, comment);
      if (r != null) {
        var d = jsonDecode(r);
        handle.alertFlush(context: context, icon: Icons.done_all, color: AppColors.greenColor, value: d['message']);
        userForm.currentState.reset();
      }
    }
    BotToast.closeAllLoading();
  }

  updateName(String value) => name = value;

  updatePhone(String value) => phone = value;

  updateEmail(String value) => email = value;

  updateComment(String value) => comment = value;
}
