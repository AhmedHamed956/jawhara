import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/core/config/shared_data.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/model/user.dart';
import 'package:jawhara/view/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel() {
    this.autoLogin();
  }

  // User model
  User currentUser;
  DateTime currentBackPressTime;
  final HandlingError handle = HandlingError.handle;

  // Auto login
  Future<bool> autoLogin() async {
    print('autoLogin');
    if (currentUser != null) return true;
    try {
      currentUser = await getFromCache();
      return true;
    } on SocketException catch (_) {
      currentUser = await getFromCache();
      return false;
    } catch (e) {
      print('E => $e');
      await logout(removeCartId: false);
      currentUser = null;
      return false;
    } finally {}
  }

  // Log out
  Future<void> logout({removeCartId = true}) async {
    print('logout');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.remove('customerData');
    if (removeCartId) await _pref.remove('cardId');
    currentUser = null;
    try {
      FacebookAuth.instance.logOut();
      GoogleSignIn().signOut();
    } catch (e) {
      print('log out socialMedia > $e');
    }
    notifyListeners();
  }

  checkUser() {
    if (currentUser != null) {
      Strings.CART_MINE = "carts/mine/";
    } else {
      Strings.CART_MINE = "guest-carts/${SharedData.cartId}/";
    }
    Strings.DEFAULT_SHIPPING_CART = "guest-carts/${SharedData.cartId}/estimate-shipping-methods";
    // notifyListeners();
  }

  // Get from cache
  Future<User> getFromCache() async {
    print('getFromCache');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    currentUser = User.fromJson(json.decode(_pref.get("customerData")));
    Strings.USER_TOKEN = _pref.get("token");
    notifyListeners();
    return currentUser;
  }

  // Save in cache
  Future<void> saveInCache(User data, String token) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var d = json.encode(data);
    _pref.setString("customerData", d);
    _pref.setString("token", token);
    print(_pref.getKeys());
    getFromCache();
  }

  Future<bool> onWillPop(context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // handle.alertFlush(context: context, icon: null, color: AppColors.secondaryColor, value: translate('back_again'));
      BotToast.showText(
        text: translate('back_again'),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        contentColor: AppColors.secondaryColor,
        contentPadding: EdgeInsets.all(8),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
