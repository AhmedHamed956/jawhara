import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';
import 'auth_view_model.dart';

class SignUpViewModel extends BaseViewModel {
  SignUpViewModel();

  final GlobalKey<FormState> userForm = GlobalKey<FormState>();

  AuthApi _api = AuthApi();
  DataForm data = DataForm();
  final Loading _loading = Loading();
  List<String> gender = ['1', '2'];

  bool autoValidate = false;
  bool eyeLock = false;

  bool get _canSubmitLogin => userForm.currentState.validate();

  void get _saveSubmitLogin => userForm.currentState.save();

  int index = 0;

  initFirstTime() {
    print('initFirstTim');
    data = DataForm();
    index = 0;
  }

  void changeEye() {
    if (eyeLock == false) {
      eyeLock = true;
    } else {
      eyeLock = false;
    }
    print(eyeLock);
    notifyListeners();
  }

  updateGender(String val) {
    data.gender = val;
    notifyListeners();
  }

  updateIsSubscribed(bool val) {
    data.isSubscribed = val;
    notifyListeners();
  }

  // Sign in
  Future<void> signUpUser(context) async {
    // print(data.toJson());
    // setBusy(true);
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      // setBusy(false);
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.signUp(
        context,
        dataForm: data,
      );
      print('r => $r');
      if (r != null) {
        final _auth = Provider.of<AuthViewModel>(context, listen: false);
        _auth.currentUser = r;
        _auth.saveInCache(r, r.extensionAttributes.token);
        Strings.USER_TOKEN = r.extensionAttributes.token;
        await _api.addGuestCartToLoginUser(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationBar()),
            (Route<dynamic> route) => false);
      }
    }
    BotToast.closeAllLoading();
  }
}
