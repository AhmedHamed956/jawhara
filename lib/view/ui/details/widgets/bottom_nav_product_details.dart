import 'package:flutter/material.dart';
import 'package:jawhara/view/ui/navigation_bar.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/svg.dart';
import '../../../index.dart';

class BottomNavProductDetails extends StatelessWidget {
  final bool fromProducts;

  const BottomNavProductDetails({Key key, this.fromProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/home.svg",
              color: AppColors.thirdColor,
            ),
          ),
          icon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/home.svg",
              color: Colors.black,
            ),
          ),
          label: translate('home'),
        ),
        BottomNavigationBarItem(
          activeIcon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/cat.svg",
              color: AppColors.thirdColor,
            ),
          ),
          icon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/cat.svg",
              color: Colors.black,
            ),
          ),
          label: translate('categories'),
        ),
        BottomNavigationBarItem(
          activeIcon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/favourite.svg",
              color: AppColors.thirdColor,
            ),
          ),
          icon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/favourite.svg",
              color: Colors.black,
            ),
          ),
          label: translate('my_fav'),
        ),
        BottomNavigationBarItem(
          activeIcon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/user.svg",
              color: AppColors.thirdColor,
            ),
          ),
          icon: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/icons/user.svg",
              color: Colors.black,
            ),
          ),
          label: translate('account'),
        ),
        BottomNavigationBarItem(
          activeIcon: ViewModelBuilder<CartViewModel>.reactive(
            viewModelBuilder: () => locator<CartViewModel>(),
            disposeViewModel: false,
            builder: (context, value, child) {
              // if(value.hasError)  Icon(IcoMoon.cart);
              return Badge(
                badgeContent: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${value.cart.items == null ? 0 : value.cart.items.length}',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                badgeColor: AppColors.primaryColor,
                elevation: 0,
                showBadge: value.cart.items != null,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(bottom: 5),
                  child: SvgPicture.asset(
                    "assets/icons/cart.svg",
                    color: AppColors.thirdColor,
                  ),
                ),
              );
            },
          ),
          icon: ViewModelBuilder<CartViewModel>.reactive(
            viewModelBuilder: () => locator<CartViewModel>(),
            disposeViewModel: false,
            builder: (context, value, child) {
              // if(value.hasError)  Icon(IcoMoon.cart);
              return Badge(
                badgeContent: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${value.cart.items == null ? 0 : value.cart.items.length}',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                badgeColor: AppColors.primaryColor,
                elevation: 0,
                showBadge: value.cart.items != null,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(bottom: 5),
                  child: SvgPicture.asset(
                    "assets/icons/cart.svg",
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
          label: translate('shop_cart'),
        ),
      ],
      currentIndex: locator<NavigationBarViewModel>().currentTabIndex,
      selectedItemColor: AppColors.thirdColor,
      unselectedItemColor: AppColors.darkGreyColor,
      showUnselectedLabels: true,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: (value) {
        if (fromProducts) Navigator.of(context).pop();
        Navigator.of(context).pop();
        locator<NavigationBarViewModel>().setTabIndex(value);
      },
    );
  }
}
