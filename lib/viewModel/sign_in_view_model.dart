// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';

import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import '../view/index.dart';
import 'auth_view_model.dart';
import 'cart_view_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignInViewModel extends BaseViewModel {
  SignInViewModel();

  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  final HandlingError handle = HandlingError.handle;

  AuthApi _api = AuthApi();
  DataForm data = DataForm();
  final Loading _loading = Loading();

  bool autoValidate = false;
  bool eyeLock = false;
  bool isGoogleLoad = false;
  bool isFaceLoad = false;
  bool isAppleLoad = false;

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

  // Sign in
  Future<void> signInUser(context, isFromCart) async {
    print('[isFromCart] > $isFromCart');
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final r = await _api.login(context, email: data.email, password: data.password);
      print('r => $r');
      if (r != null) {
        final result = await _api.getUserInfo(context, token: r);
        print('result => $result');
        final _auth = Provider.of<AuthViewModel>(context, listen: false);
        _auth.currentUser = result;
        _auth.saveInCache(result, r);
        Strings.USER_TOKEN = r;
        await _api.addGuestCartToLoginUser(context);

        Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isFromCart) {
            (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(4);
          } else {
            (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(0);
          }
          locator<CartViewModel>().initScreen(context);
          locator<WishListViewModel>().initScreen(context);
        });
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
      }
    }
    BotToast.closeAllLoading();
  }

  // Google login
  Future<void> loginGoogle(context) async {
    try {
      isGoogleLoad = true;
      notifyListeners();
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount res = await _googleSignIn.signIn();
      if (res == null) {
        handle.showError(
          context: context,
          error: translate('user_cancel'),
        );
      } else {
        GoogleSignInAuthentication auth = await res.authentication;
        final r = await _api.loginGoogle(context, token: auth.accessToken);
        if (r != null) {
          print('token social => $r');
          final result = await _api.getUserInfo(context, token: r);
          print('result => $result');
          final _auth = Provider.of<AuthViewModel>(context, listen: false);
          _auth.currentUser = result;
          _auth.saveInCache(result, r);
          Strings.USER_TOKEN = r;
          await _api.addGuestCartToLoginUser(context);
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
        }
      }
      isGoogleLoad = false;
      notifyListeners();
    } catch (err, trace) {
      print(err);
      isGoogleLoad = false;
      handle.showError(context: context, error: err.toString());
      notifyListeners();
    }
  }

  // Facebook login
  Future<void> loginFacebook(context) async {
    try {
      isFaceLoad = true;
      notifyListeners();
      final result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final accessToken = await FacebookAuth.instance.accessToken;
          final r = await _api.loginFacebook(context, token: accessToken.token);
          if (r != null) {
            final result = await _api.getUserInfo(context, token: r);
            print('result => $result');
            final _auth = Provider.of<AuthViewModel>(context, listen: false);
            _auth.currentUser = result;
            _auth.saveInCache(result, r);
            Strings.USER_TOKEN = r;
            await _api.addGuestCartToLoginUser(context);
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
          }
          break;
        case LoginStatus.cancelled:
          handle.showError(
            context: context,
            error: translate('user_cancel'),
          );
          break;
        default:
          handle.showError(
            context: context,
            error: result.message,
          );
          break;
      }
      isFaceLoad = false;
      notifyListeners();
    } catch (err, trace) {
      isFaceLoad = false;
      notifyListeners();
      handle.showError(context: context, error: err.toString());
    }
  }

// Apple login
  Future<void> loginApple(context) async {
    try {
      isAppleLoad = true;
      notifyListeners();
      final result = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);
      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          print('Authorize > ${result.status}');
          final r = await _api.loginApple(context, token: String.fromCharCodes(result.credential.identityToken));
          print('Result_Apple_Login > ${r}');
          if (r != null) {
            final result = await _api.getUserInfo(context, token: r);
            print('result => $result');
            final _auth = Provider.of<AuthViewModel>(context, listen: false);
            _auth.currentUser = result;
            _auth.saveInCache(result, r);
            Strings.USER_TOKEN = r;
            await _api.addGuestCartToLoginUser(context);
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
          }
          break;
        case apple.AuthorizationStatus.cancelled:
          handle.showError(
            context: context,
            error: translate('user_cancel'),
          );
          break;
        case apple.AuthorizationStatus.error:
          handle.showError(
            context: context,
            error: result.error.domain,
          );
          break;
      }
      isAppleLoad = false;
      notifyListeners();
    } catch (err, trace) {
      isAppleLoad = false;
      notifyListeners();
      handle.showError(context: context, error: err.toString());
    }
  }
}
