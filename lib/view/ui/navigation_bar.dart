import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/ui/auth/forget_password.dart';
import 'package:jawhara/view/ui/wishlist/wishlist.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/forget_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:provider/provider.dart';

import '../index.dart';
import 'auth/verfication_code.dart';
import 'cart/cart.dart';

class MainTabControlDelegate {
  // int index;
  // Function(String nameTab) changeTab;
  // Function(int index) tabAnimateTo;

  // Todo globalKey
  GlobalKey globalKey = GlobalKey();

  static MainTabControlDelegate _instance;

  static MainTabControlDelegate getInstance() {
    return _instance ??= MainTabControlDelegate._();
  }

  MainTabControlDelegate._();
}

class NavigationBar extends StatefulWidget {
  final int tabIndex;

  NavigationBar({this.tabIndex});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      MainTabControlDelegate.getInstance().globalKey = key;
    });
    initDynamicLinks();

    Future.delayed(Duration(seconds: 5), checkIfNotificationOpenedApp);
  }

  checkIfNotificationOpenedApp() async {
    var message = await FCMConfig.instance.getInitialMessage();
    if (message != null) {
      selectNotification(jsonEncode(message.data));
    }
  }

  initDynamicLinks() async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            final Uri deepLink = dynamicLink?.link;

            if (deepLink != null) {
              if (deepLink.path.contains("catalog/product")) {
                try {
                  String productId = deepLink.path
                      .split("/")
                      .last
                      .split(".")[0];
                  // Services()
                  //   ..getProduct(productId).then((product) {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ProductDetail(
                                product: Product(entityId: productId)),
                        fullscreenDialog: true,
                      ));
                  // });
                } catch (e) {
                  print("Couldn't handle opening screen $e");
                }
              } else if (deepLink.path.contains("account/createPassword")) {
                try {
                  String token = deepLink.path
                      .split("?token=")
                      .last;
                  String emailToReset =
                  await Provider.of<ForgetViewModel>(context, listen: false)
                      .getEmailFromSharedPrefs();
                  if (emailToReset != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              VerificationCode(
                                emailToReset,
                                token: token,
                              ),
                          fullscreenDialog: true,
                        ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ForgetPassword(),
                          fullscreenDialog: true,
                        ));
                  }
                  // });
                } catch (e) {
                  print("Couldn't handle opening screen $e");
                }
              }
            }
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.path.contains("catalog/product")) {
          try {
            String productId = deepLink.path
                .split("/")
                .last
                .split(".")[0];
            // Services()
            //   ..getProduct(productId).then((product) {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ProductDetail(product: Product(entityId: productId)),
                  fullscreenDialog: true,
                ));
            // });
          } catch (e) {
            print("Couldn't handle opening screen $e");
          }
        } else if (deepLink.path.contains("account/createPassword")) {
          try {
            String token = deepLink.path
                .split("?token=")
                .last;
            String emailToReset =
            await Provider.of<ForgetViewModel>(context, listen: false)
                .getEmailFromSharedPrefs();
            if (emailToReset != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        VerificationCode(
                          emailToReset,
                          token: token,
                        ),
                    fullscreenDialog: true,
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ForgetPassword(),
                    fullscreenDialog: true,
                  ));
            }
            // });
          } catch (e) {
            print("Couldn't handle opening screen $e");
          }
        }
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        if ((MainTabControlDelegate.getInstance().globalKey.currentWidget
                    as BottomNavigationBar)
                .currentIndex !=
            0) {
          (MainTabControlDelegate.getInstance().globalKey.currentWidget
                  as BottomNavigationBar)
              .onTap(0);
          return Future.value(false);
        }
        if (tabController.index != 0) {
          setState(() {
            tabController.animateTo(0);
            tabController.index = 0;
          });
          return Future.value(false);
        }
        return _auth.onWillPop(context);
      },
      child: ViewModelBuilder<NavigationBarViewModel>.reactive(
        onModelReady: (model) => model.initScreen(context),
        builder: (context, model, child) => Scaffold(
          body: IndexedStack(index: model.currentTabIndex, children: <Widget>[
            HomePage(),
            MainCategoriesPage(),
            WishListPage(),
            Account(),
            CartPage(),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            key: key,
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
                        child: Text(
                            '${value.cart.items == null ? 0 : value.cart.items.length}',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
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
                        child: Text(
                            '${value.cart.items == null ? 0 : value.cart.items.length}',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
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
            currentIndex: model.currentTabIndex,
            selectedItemColor: AppColors.thirdColor,
            unselectedItemColor: AppColors.darkGreyColor,
            showUnselectedLabels: true,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            type: BottomNavigationBarType.fixed,
            onTap: (value) => model.setTabIndex(value),
          ),
          drawer: Drawer(
              child: ViewModelBuilder<HomeViewModel>.reactive(
            viewModelBuilder: () => locator<HomeViewModel>(),
            disposeViewModel: false,
            fireOnModelReadyOnce: true,
            builder: (context, model, child) {
              if (model.categories == null && !model.isBusy)
                return Center(child: Text('Error'));
              return ListView(
                  children: (model.categories?.childrenData ?? [])
                      .map((e) => Tab(
                            child: ListTile(
                              title: e.id == 0
                                  ? Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Icon(Icons.home))
                                  : Text(e.name),
                              dense: true,
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                if (e.id == 0) {
                                  model.spiderFunction(context, 0, '0', '0');
                                }
                                if (e.id != 0) {
                                  model.spiderFunction(
                                      context,
                                      e.id,
                                      e.level.toString(),
                                      e.parentId.toString());
                                }
                              },
                            ),
                          ))
                      .toList());
            },
          )),
        ),
        viewModelBuilder: () => locator<NavigationBarViewModel>(),
        disposeViewModel: false,
      ),
    );
  }
}
