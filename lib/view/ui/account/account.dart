import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/view/ui/account/contact_us/contact_us.dart';
import 'package:jawhara/view/ui/account/gift/gift_card.dart';
import 'package:jawhara/view/ui/account/help/help.dart';
import 'package:jawhara/view/ui/account/orders/my_orders.dart';
import 'package:jawhara/view/ui/account/points/my_points.dart';
import 'package:jawhara/view/ui/account/shipping/my_address.dart';
import 'package:jawhara/view/ui/account/wallet/my_wallet.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../index.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController controller = new ScrollController();
  bool notificationFlag = true;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final connection = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        // leading: IconButton(icon: Icon(IcoMoon.line_circle), onPressed: (){
        //   BotToast.showText(
        //     text: translate("soon"),
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //     contentColor: Colors.green,
        //     contentPadding: EdgeInsets.all(10),
        //   );
        // }),
        title: SearchBar(
          isSearching: _searching,
        ),
        actions: [
          Visibility(
            visible: !_searching,
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: SearchScreen(),
                    ),
                  );
                }),
          ),
          IconButton(
              icon: Icon(IcoMoon.barcode),
              onPressed: () {
                BotToast.showText(
                  text: translate("soon"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  contentColor: Colors.green,
                  contentPadding: EdgeInsets.all(10),
                );
              }),
          IconButton(
              icon: Icon(
                IcoMoon.notification,
                color: AppColors.secondaryColor,
              ),
              onPressed: () {
                BotToast.showText(
                  text: translate("soon"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  contentColor: Colors.green,
                  contentPadding: EdgeInsets.all(10),
                );
              }),
        ],
      ),
      body: connection == ConnectivityStatus.Offline
          ? NoInternetWidget(retryFunc: () => null)
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _auth.currentUser != null
                      ? Column(
                          children: [
                            Center(
                                heightFactor: 1.5,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(Strings.GUEST_IMAGE),
                                  radius: 50,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(translate('user_name')),
                                  SizedBox(width: 8),
                                  Text(_auth.currentUser.firstname + ' ' + _auth.currentUser.lastname, style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(translate('email')),
                                  SizedBox(width: 8),
                                  Text(_auth.currentUser.email, style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SignIn(),
                            ),
                          ),
                          child: Column(
                            children: [
                              Center(
                                  heightFactor: 1.5,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(Strings.GUEST_IMAGE),
                                    radius: 50,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(translate('welcomeL')),
                              ),
                            ],
                          ),
                        ),

                  // information personal
                  Visibility(
                    visible: _auth.currentUser != null,
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(translate('information_account'),
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 13),
                                textAlign: TextAlign.start)),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_home.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('addresses'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          onTap: () {
                            return Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: MyAddress(),
                              ),
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_wishlist.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('my_fav'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          // Todo globalKey
                          onTap: () {
                            locator<NavigationBarViewModel>().setTabIndex(2);
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            //   (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(2);
                            // });
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_notification.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('notification'), style: TextStyle(fontSize: 13)),
                          trailing: Switch(
                            value: notificationFlag,
                            onChanged: (newValue) {
                              setState(() {
                                notificationFlag = newValue;
                              });
                            },
                            activeColor: Colors.black,
                            inactiveTrackColor: Colors.grey.withAlpha(50),
                            inactiveThumbColor: Colors.grey,
                          ),
                          onTap: () => null,
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        // ListTile(
                        //   leading: Container(
                        //       width: 20,
                        //       height: 20,
                        //       child: SvgPicture.asset(
                        //         "assets/icons/menu_profile.svg",
                        //         color: Colors.grey,
                        //       )),
                        //   title: Text(translate('profile'),
                        //       style: TextStyle(fontSize: 13)),
                        //   trailing: Icon(lang == 'ar'
                        //       ? Icons.keyboard_arrow_left
                        //       : Icons.keyboard_arrow_right),
                        //   onTap: () => null,
                        // ),
                        // Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 30),
                        //     child: Divider()),
                      ],
                    ),
                  ),
                  // Services
                  if (_auth.currentUser != null)
                    Wrap(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(translate('services'),
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 13),
                                textAlign: TextAlign.start)),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_my_orders.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('my_order'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          onTap: () {
                            return Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: MyOrders(),
                              ),
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_wallet.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('wallet'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: MyWallet(),
                              ),
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        // ListTile(
                        //   leading: Container(
                        //       width: 20,
                        //       height: 20,
                        //       child: SvgPicture.asset(
                        //         "assets/icons/menu_my_orders.svg",
                        //         color: Colors.grey,
                        //       )),
                        //   title: Text(translate('return_orders'),
                        //       style: TextStyle(fontSize: 13)),
                        //   trailing: Icon(lang == 'ar'
                        //       ? Icons.keyboard_arrow_left
                        //       : Icons.keyboard_arrow_right),
                        //   onTap: () {
                        //     return Navigator.push(
                        //       context,
                        //       PageTransition(
                        //         type: PageTransitionType.fade,
                        //         child: ReturnHistory(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 30),
                        //     child: Divider()),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_gift_card.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('gift'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          onTap: () => Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: GiftCard(),
                            ),
                          ),
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        // ListTile(
                        //   leading: Container(
                        //       width: 20,
                        //       height: 20,
                        //       child: SvgPicture.asset(
                        //         "assets/icons/menu_points.svg",
                        //         color: Colors.grey,
                        //       )),
                        //   title: Text(translate('my_points'), style: TextStyle(fontSize: 13)),
                        //   trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     PageTransition(
                        //       type: PageTransitionType.fade,
                        //       child: MyPoints(),
                        //     ),
                        //   ),
                        // ),
                        // Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_credit_card.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('payment_card'), style: TextStyle(fontSize: 13)),
                          trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                          onTap: () {
                            BotToast.showText(
                              text: translate("soon"),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              contentColor: Colors.green,
                              contentPadding: EdgeInsets.all(10),
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                      ],
                    ),
                  // Contact us
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(translate('contact_us'),
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 13),
                          textAlign: TextAlign.start)),
                  ListTile(
                    leading: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/icons/menu_whatsapp.svg",
                          color: Colors.grey,
                        )),
                    title: Text(translate('contact_whatsapp'), style: TextStyle(fontSize: 13)),
                    trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                    onTap: () async {
                      await launch("whatsapp://send?phone=966567302710");
                    },
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                  ListTile(
                    leading: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/icons/menu_information.svg",
                          color: Colors.grey,
                        )),
                    title: Text(translate('help'), style: TextStyle(fontSize: 13)),
                    trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                    onTap: () {
                      return Navigator.of(context)
                          .push(PageTransition(type: PageTransitionType.fade, duration: Duration(milliseconds: 100), child: HelpScreen()));
                    },
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                  ListTile(
                    leading: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/icons/menu_call_us.svg",
                          color: Colors.grey,
                        )),
                    title: Text(translate('contact_now'), style: TextStyle(fontSize: 13)),
                    trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                    onTap: () => Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ContactUs(),
                      ),
                    ),
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                  // Settings
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(translate('settings'),
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 13),
                          textAlign: TextAlign.start)),
                  ListTile(
                    leading: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/icons/menu_language.svg",
                          color: Colors.grey,
                        )),
                    title: Text(translate('change_language'), style: TextStyle(fontSize: 13)),
                    trailing: Text(
                      '${lang == 'ar' ? 'ar' : 'en'}'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGreyColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    onTap: () {
                      print('change');
                      if (lang == 'ar') {
                        setState(() {
                          changeLocale(context, 'en');
                          SharedData.currency = 'SAR';
                          SharedData.lang = 'en';
                          print(SharedData.lang);
                          print('english');
                          locator<HomeViewModel>().initScreen(context);
                        });
                      } else {
                        setState(() {
                          changeLocale(context, 'ar');
                          SharedData.currency = 'ر.س';
                          SharedData.lang = 'ar';
                          print(SharedData.lang);
                          print('arabic');
                          locator<HomeViewModel>().initScreen(context);
                        });
                      }
                    },
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                  Visibility(
                    visible: _auth.currentUser != null,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/menu_logout.svg",
                                color: Colors.grey,
                              )),
                          title: Text(translate('logout'), style: TextStyle(fontSize: 13)),
                          onTap: () async {
                            await _auth.logout();
                            locator<CartViewModel>().initScreen(context);

                            return Navigator.of(context).push(
                              PageTransition(type: PageTransitionType.fade, duration: Duration(milliseconds: 100), child: SignIn()),
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 30), child: Divider()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
