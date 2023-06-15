import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/index.dart';

class ForgetViewModel extends BaseViewModel {
  final HandlingError handle = HandlingError.handle;
  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  AuthApi _api = AuthApi();
  DataForm data = DataForm();
  final Loading _loading = Loading();
  bool autoValidate = false;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  initScreen(context, email) {
    data.email = email;
  }

  // Forget password
  forgetPassword(context) async {
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.forgetPasswordData(context, email: data.email);
      if (r == true) {
        saveEmailInSharedPrefs(data.email);
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: translate("emailSentWithTheResetLink"));
        // Navigator.push(
        //   context,
        //   PageTransition(
        //     type: PageTransitionType.fade,
        //     child: VerificationCode(data.email),
        //   ),
        // );
      }
    }
    BotToast.closeAllLoading();
  }

  // Change password
  changePassword(context, {bool showValidationToken}) async {
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.changePasswordData(context, dataForm: data);
      if (r == true) {
        handle.alertFlush(
            context: context,
            icon: Icons.done_all,
            color: AppColors.greenColor,
            value: translate("passwordResetSuccessfully"),
            seconds: 4);
        Navigator.of(navigatorKey.currentState.context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationBar()),
            (Route<dynamic> route) => false);
      }
    }
    BotToast.closeAllLoading();
  }

  // Get email from SharedPrefs
  Future<String> getEmailFromSharedPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String emailToBeReset = _pref.get("emailToBeReset");
    return emailToBeReset;
  }

  // Save email in SharedPrefs
  Future<void> saveEmailInSharedPrefs(String emailToBeReset) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("emailToBeReset", emailToBeReset);
  }
}
