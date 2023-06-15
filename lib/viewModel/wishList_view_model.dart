import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/model/wishlist/wishlist.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';
import 'cart_view_model.dart';

class WishListViewModel extends BaseViewModel {
  WishListViewModel();

  CommonApi _api = CommonApi();
  List<ItemWish> wishlist = List();
  final Loading _loading = Loading();

  final HandlingError handle = HandlingError.handle;

  // init Wishlist data
  initScreen(context, {isLoad = true}) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    if (_auth.currentUser == null) {
      return;
    } else {
      print('### Init ${this.runtimeType} ###');
      if (isLoad) setBusy(true);
      final r = await _api.getWishList(context);
      wishlist = r.items;
      if (isLoad) setBusy(false);
      if (!isLoad) notifyListeners();
    }
  }

  addQuantity(index) {
    // double max = double.parse(wishlist[index].product.stockItem.maxSaleQty);
    // if (max > qty) {
    wishlist[index].qty++;
    notifyListeners();
    // } else {
    //   handle.showError(context: context, error: translate('max_stock') + max.roundToDouble().toString());
    // }
  }

  subQuantity(index) {
    if (wishlist[index].qty > 1) {
      wishlist[index].qty--;
      notifyListeners();
    }
  }

  addToCart(context, index) async {
    print('addTocAtt');
    _loading.init();
    notifyListeners();
    final r = await _api.addToCartData(
        context,
        ProductDetails(sku: wishlist[index].product.sku),
        wishlist[index].qty.toString(),
        []);
    print('r => $r');
    if(r == null){ //user not have active cart
      locator<CartViewModel>().initScreen(context, afterEnd: (){
        addToCart(context, index);
      });
    }
    if (r) {
      handle.alertFlush(
          context: context,
          icon: Icons.done_all,
          color: AppColors.greenColor,
          value: translate('added_to_cart'));
      notifyListeners();
      locator<CartViewModel>().initScreen(context);
    }
    notifyListeners();
  }

  // Check if product expire or not
  bool checkExpire(Product p) {
    bool specialExpire = p.specialFromDate != null ? !p.specialFromDate.isAfter(DateTime.now()) : false;
    return specialExpire;
    // return false;
  }

  // add Wishlist
  addItem(context, id) async {
    print('## Add item wishlist ##');
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    if (_auth.currentUser == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      _loading.init();
      final r = await _api.addWishItem(context, id);
      BotToast.closeAllLoading();
      if (r) {
        locator<WishListViewModel>().initScreen(context);
        checkAvailable(id);
        return true;
      } else {
        locator<WishListViewModel>().initScreen(context);
        return false;
      }
    }
  }

  // remove Wishlist
  removeItem(context, wishItemId) async {
    print('## Remove item wishlist ##');
    _loading.init();
    final r = await _api.removeWishItem(context, wishItemId);
    BotToast.closeAllLoading();
    if (r) {
      locator<WishListViewModel>().initScreen(context, isLoad: false);
      return true;
    } else {
      locator<WishListViewModel>().initScreen(context, isLoad: false);
      return false;
    }
  }

  // remove Wishlist from product
  removeProductWishItem(context, id) async {
    print('## Remove item from product wishlist ##');
    final check = wishlist.firstWhere((element) => element.productId == id,
        orElse: () => null);
    if (check != null) {
      _loading.init();
      final r = await _api.removeWishItem(context, check.wishlistItemId);
      BotToast.closeAllLoading();
      if (r) {
        locator<WishListViewModel>().initScreen(context, isLoad: false);
        return true;
      } else {
        locator<WishListViewModel>().initScreen(context, isLoad: false);
        return false;
      }
    }
  }

  bool checkAvailable(id) {
    final check = wishlist.firstWhere((element) => element.productId == id,
        orElse: () => null);
    if (check != null) {
      return true;
    } else {
      return false;
    }
  }
}
