import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/cart/cart.dart' as cart;
import 'package:jawhara/model/cart/shipping_method.dart';
import 'package:jawhara/model/shipping%20address/city_model.dart';
import 'package:jawhara/model/shipping%20address/countries.dart';

// import 'package:jawhara/model/shipping%20address/data_address.dart';
import 'package:jawhara/model/shipping%20address/my_address.dart';
import 'package:jawhara/model/shipping%20address/my_address.dart';
import 'package:jawhara/model/shipping%20address/state_model.dart';
import 'package:jawhara/view/ui/account/shipping/my_address.dart' as ship;
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';
import 'cart_view_model.dart';

class ShippingAddressViewModel extends BaseViewModel {
  ShippingAddressViewModel();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> globalKey2 = GlobalKey<FormState>();
  final HandlingError handle = HandlingError.handle;
  TabController tabController;

  CommonApi _api = CommonApi();
  List<Address> addresses = [];
  CountriesModel country = CountriesModel();
  List<CountriesModel> countries = [];
  List<AvailableState> availableStates = [];
  List<AvailableCity> availableCity = [];
  List<String> cities = [];
  List<String> arCities = [];
  List<String> enCities = [];
  List<ShippingMethod> shippingMethod = [];
  Address defaultMyAddress = Address();
  Address billingAddress = Address();
  ShippingMethod defaultShippingMethod = ShippingMethod();
  String stateName;
  String email, landMark, altPhone, district;
  String emailBilling, landMarkBilling, altPhoneBilling, districtBilling;

  // String customerId, region, countryId, street, firstname, lastname, telephone, postcode, city;
  // bool defaultShipping = false;
  bool checkBilling = true;
  bool isShippingMethodLoad = false;

  final Loading _loading = Loading();
  bool autoValidate = false;

  bool get _canSubmitLogin => globalKey.currentState.validate();

  bool get _canSubmitLogin2 => globalKey2.currentState.validate();

  void get _saveSubmitLogin => globalKey.currentState.save();

  void get _saveSubmitLogin2 => globalKey2.currentState.save();

  bool isLoadInit = false;

  // init Shipping Address
  initScreen(context, int id, {bool defaultAddress = false}) async {
    var cartModel = locator<CartViewModel>();
    bool onlyGiftCards = true;
    for (cart.Item item in cartModel.cart.items) {
      if (item.productType != "giftcard") {
        onlyGiftCards = false;
        break;
      }
    }
    if (onlyGiftCards) {
      if (tabController != null) tabController.animateTo(1);
      notifyListeners();
    }
    print('### Init ${this.runtimeType} ###');
    isLoadInit = true;
    setBusy(true);
    final r = await _api.getMyAddressData(context, id.toString());
    if (r != null) {
      addresses = r.addresses;
      setBusy(false);
      if (defaultAddress) {
        if (addresses.isEmpty) {
          return Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: ship.MyAddress(),
            ),
          ).then((value) {
            if (addresses.isNotEmpty) {
              final _auth = Provider.of<AuthViewModel>(context, listen: false);
              return initScreen(context, _auth.currentUser.id, defaultAddress: true);
            } else {
              Navigator.pop(context);
            }
          });
        }
        var checkDefault = addresses.firstWhere((element) => element.defaultShipping == true, orElse: () => null);
        if (checkDefault == null) {
          checkDefault = addresses[0];
        }
        print(checkDefault.toJson());
        initData(context, checkDefault, onFinish: () {
          getShippingMethod(context);
        });
      }
    }
    isLoadInit = false;
    setBusy(false);
  }

  initData(context, Address address, {onFinish}) {
    print(address.toJson());
    defaultMyAddress = address;
    billingAddress = address;
    notifyListeners();
    getCountries(context, onFinish: onFinish);
  }

  addNewAddress(context) async {
    print('### Init ${this.runtimeType} ###');
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      print('eee');
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final _auth = Provider.of<AuthViewModel>(context, listen: false);
      defaultMyAddress..customerId = _auth.currentUser.id;
      // BotToast.closeAllLoading();
      print(defaultMyAddress.toJson());
      print(email);
      print(landMark);
      print(altPhone);
      print(district);
      if (defaultMyAddress.city != null && defaultMyAddress.countryId != null) {
        final r = await _api.addNewAddressData(context, defaultMyAddress, email, landMark, altPhone, district);
        if (r) {
          locator<ShippingAddressViewModel>().initScreen(context, _auth.currentUser.id);
          Navigator.pop(context);
        }
      } else {
        handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('select_city_country'));
      }
    }
    BotToast.closeAllLoading();
  }

  editAddress(context, addressId) async {
    print('### Init ${this.runtimeType} ###');
    _loading.init();
    autoValidate = true;
    if (!_canSubmitLogin) {
      print('eee');
      BotToast.closeAllLoading();
    } else {
      _saveSubmitLogin;
      final _auth = Provider.of<AuthViewModel>(context, listen: false);
      defaultMyAddress..customerId = _auth.currentUser.id;
      // BotToast.closeAllLoading();
      // print(firstname);
      final r = await _api.editAddressData(context, addressId, defaultMyAddress);
      if (r) {
        locator<ShippingAddressViewModel>().initScreen(context, _auth.currentUser.id);
        Navigator.pop(context);
      }
    }
    BotToast.closeAllLoading();
  }

  defaultAddress(context, addressId) async {
    print('### Init ${this.runtimeType} ###');
    _loading.init();
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final r = await _api.changeDefaultAddress(context, addressId, _auth.currentUser.id);
    if (r) {
      locator<ShippingAddressViewModel>().initScreen(context, _auth.currentUser.id);
    }
    BotToast.closeAllLoading();
  }

  getCountries(context, {bool defaultAddress = false, onFinish}) async {
    getCity(context, onFinish: onFinish);
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    final r = await _api.getCountriesData(context);
    if (r != null) {
      countries.clear();
      print(countries.length);
      countries.add(r);
      print(countries.length);
      setBusy(false);
      if (defaultAddress) {
        final _auth = Provider.of<AuthViewModel>(context, listen: false);
        await initScreen(context, _auth.currentUser.id, defaultAddress: defaultAddress);
      }
    }
    setBusy(false);
  }

  // getStates(context) async {
  //   print('### Init ${this.runtimeType} ###');
  //   setBusy(true);
  //   final r = await _api.getStateData(context);
  //   if (r != null) {
  //     availableStates.clear();
  //     availableStates = r.availableStates;
  //     setBusy(false);
  //   }
  //   setBusy(false);
  // }

  getCity(context, {onFinish}) async {
    print('### Init ${this.runtimeType} ###');
    // setBusy(true);
    final enCitiesResponse = await _api.getCityData(context, lang: 'en');
    final arCitiesResponse = await _api.getCityData(context, lang: 'ar');
    if (enCitiesResponse != null && arCitiesResponse != null) {
      enCities.clear();
      arCities.clear();
      // availableCity.clear();
      // availableCity = r.availableCities;
      enCitiesResponse.availableCities.forEach((element) {
        enCities.add(element.citiesName);
      });
      arCitiesResponse.availableCities.forEach((element) {
        arCities.add(element.citiesName);
      });

      if (SharedData.lang == 'en') {
        cities = enCities;
      } else {
        cities = arCities;
      }
      if (onFinish != null) {
        onFinish();
      }
      setBusy(false);
    }
    // setBusy(false);
  }

  getData(filter) {
    print('onFind > $filter');
    final search = availableCity.firstWhere((element) => element.citiesName == filter, orElse: () => null);
    return search;
  }

  deleteAddress(context, String id) async {
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    final r = await _api.deleteAddressData(context, id);
    if (r) {
      final _auth = Provider.of<AuthViewModel>(context, listen: false);
      defaultMyAddress..customerId = _auth.currentUser.id;
      locator<ShippingAddressViewModel>().initScreen(context, _auth.currentUser.id);
    }
    setBusy(false);
  }

  getShippingMethod(context) async {
    print('### Init ${this.runtimeType} ###');
    isShippingMethodLoad = true;
    notifyListeners();
    var cityToSendIndex = arCities.indexOf(defaultMyAddress.city);
    final r = await _api.getShippingMethodData(context, defaultMyAddress, city: cityToSendIndex == -1 ? null : enCities[cityToSendIndex]);
    if (r != null) {
      shippingMethod = r.shippingMethods;

      if (defaultShippingMethod != null) {
        updateShippingMethod(defaultShippingMethod);
      }
    } else {
      shippingMethod.clear();
      isShippingMethodLoad = false;
      notifyListeners();
    }
    isShippingMethodLoad = false;
    notifyListeners();
  }

  // Confirm button shipping
  submitShipping(context) {
    print('### Init ${this.runtimeType} ###');
    // autoValidate = true;
    // if (!_canSubmitLogin) {
    //   return false;
    // } else {
    //   _saveSubmitLogin;
    final checkShipMethod = shippingMethod.firstWhere((element) => element.selected == true, orElse: () => null);
    // check
    if (checkShipMethod != null) {
      tabController.animateTo(1);
      notifyListeners();
    } else {
      handle.alertFlush(context: context, icon: Icons.close, color: AppColors.redColor, value: translate('select_ship_method'));
    }
    // }
  }

  updateCountry(CountriesModel value) {
    defaultMyAddress..countryId = value.id;
  }

  updateState(context, AvailableState value) {
    stateName = value.statesName;
  }

  @deprecated
  updateCity(AvailableCity value) {
    defaultMyAddress..city = value.citiesName;
  }

  updateCityName(String value) {
    defaultMyAddress..city = value;
  }

  updateFirstName(String value) {
    defaultMyAddress..firstname = value;
  }

  updateLastName(String value) {
    defaultMyAddress..lastname = value;
  }

  // updateRegion(String value) {
  //   my.Region t = my.Region(region: value, regionCode: '0', regionId: 0);
  //   defaultMyAddress.region = t;
  // }

  updateStreet(String value) {
    defaultMyAddress..street = [value];
  }

  updatePostalCode(String value) {
    defaultMyAddress..postcode = value;
  }

  updateEmail(String value) {
    email = value;
  }

  updateLandMark(String value) {
    landMark = value;
  }

  updateAltPhone(String value) {
    altPhone = value;
  }

  updateDistrict(String value) {
    district = value;
  }

  updatePhone(String value) {
    defaultMyAddress..telephone = value;
  }

  updateDefaultShipping(bool value) {
    defaultMyAddress..defaultShipping = value;
    notifyListeners();
  }

  updateShippingMethod(ShippingMethod e) {
    shippingMethod.forEach((element) {
      if (element.carrierCode == e.carrierCode) {
        element.selected = true;
        defaultShippingMethod = element;
      } else {
        element.selected = false;
      }
    });
    notifyListeners();
  }

  //Billing address
  updateBillingCountry(CountriesModel value) {
    billingAddress = billingAddress.copyWith(countryId: value.id);
  }

  updateBillingCheckbox(bool value) {
    checkBilling = value;
    if (checkBilling == true) {
      billingAddress = defaultMyAddress;
    }
    notifyListeners();
  }

  updateBillingCity(String value) {
    billingAddress = billingAddress.copyWith(city: value);
  }

  updateBillingFirstName(String value) {
    billingAddress = billingAddress.copyWith(firstname: value);
  }

  updateBillingLastName(String value) {
    billingAddress = billingAddress.copyWith(lastname: value);
  }

  // updateBillingRegion(String value) {
  //   my.Region t = my.Region(region: value, regionCode: '0', regionId: 0);
  //   billingAddress.region = t;
  // }

  updateBillingStreet(String value) {
    billingAddress = billingAddress.copyWith(street: [value]);
  }

  updateBillingPostalCode(String value) {
    billingAddress = billingAddress.copyWith(postcode: value);
  }

  updateBillingPhone(String value) {
    billingAddress = billingAddress.copyWith(telephone: value);
  }

  updateBillingAltPhone(String value) {
    altPhoneBilling = value;
  }

  updateBillingEmail(String value) {
    emailBilling = value;
  }

  updateBillingLandMark(String value) {
    landMarkBilling = value;
  }

  updateBillingDistrict(String value) {
    districtBilling = value;
  }
}
