import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/locator.dart';
import 'package:jawhara/view/index.dart';
import 'package:jawhara/view/ui/cart/cart.dart';
import 'package:jawhara/view/ui/wishlist/wishlist.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:stacked/stacked.dart';

import 'cart_view_model.dart';

class NavigationBarViewModel extends BaseViewModel {
  CommonApi _api = CommonApi();

  int currentTabIndex = 0;
  // int get currentTabIndex => _currentTabIndex;

  final Map<int, Widget> _viewCache = Map<int, Widget>();

  Widget getViewForIndex(int index) {
    if (!_viewCache.containsKey(index)) {
      switch (index) {
        case 0:
          _viewCache[index] = HomePage();
          break;
        case 1:
          _viewCache[index] = MainCategoriesPage();
          break;
        case 2:
          _viewCache[index] = WishListPage();
          break;
        case 3:
          _viewCache[index] = Center(child: Account());
          break;
        case 4:
          _viewCache[index] = CartPage();
          break;
      }
    }

    return _viewCache[index];
  }

  void setTabIndex(int value) {
    print('value > $value');
    currentTabIndex = value;
    notifyListeners();
  }
  // init Navigation
  initScreen(context) async {
      locator<CartViewModel>().initScreen(context);
      locator<WishListViewModel>().initScreen(context);
  }


}