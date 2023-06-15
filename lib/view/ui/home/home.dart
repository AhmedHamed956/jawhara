import 'package:agconnect_remote_config/agconnect_remote_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jawhara/core/config/connectivity_service.dart';
import 'package:jawhara/view/ui/account/contact_us/contact_us.dart';
import 'package:jawhara/view/ui/account/faq/faq_screen.dart';
import 'package:jawhara/view/ui/how_to_buy/how_to_buy_screen.dart';
import 'package:jawhara/view/widgets/not_internet.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

TabController tabController;

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // static final GlobalKey<ScaffoldState> scaffoldKey =
  //     new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController _scrollController = new ScrollController();
  int _selectedIndex = 0;

  static const MethodChannel methodChannel = MethodChannel('jawhara.channels/payment');
  bool _isHmsAvailable = false;
  bool _isGmsAvailable = true;

  // List<TabsLayout> categoriesTabs = [];

  checkHmsGms() async {
    await _isHMS();
    await _isGMS();
  }

  Future<void> _isHMS() async {
    bool status;

    try {
      bool result = await methodChannel.invokeMethod('isHmsAvailable');
      status = result;
      print('status : ${status.toString()}');
    } on PlatformException {
      print('Failed to get _isHmsAvailable.');
    }

    setState(() {
      _isHmsAvailable = status;
    });
  }

  Future<void> _isGMS() async {
    bool status;

    try {
      bool result = await methodChannel.invokeMethod('isGmsAvailable');
      status = result;
      print('status : ${status.toString()}');
    } on PlatformException {
      print('Failed to get _isGmsAvailable.');
    }

    setState(() {
      _isGmsAvailable = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _searching == false) {
        setState(() {
          _searching = true;
        });
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward && _searching == true) {
        setState(() {
          _searching = false;
        });
      }
    });
    if (Platform.isAndroid) {
      checkHmsGms();
      Future.delayed(Duration(seconds: 1), checkNewVersion);
    }
  }

  checkNewVersion() async {
    if (_isHmsAvailable && !_isGmsAvailable) {
      AGCRemoteConfig.instance.getValue('requiredBuildNumber').then((requiredBuildNumber) async {
        // onSuccess
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final currentBuildNumber = int.parse(packageInfo.buildNumber);

        if (currentBuildNumber < int.parse(requiredBuildNumber)) {
          await _showUpdateDialog();
        }
      }).catchError((error) {
        // onFailure
        print(error.toString());
      });
    } else {
      try {
        final RemoteConfig remoteConfig = RemoteConfig.instance;
        await remoteConfig.fetchAndActivate();

        final requiredBuildNumber = remoteConfig.getInt(Platform.isAndroid ? 'requiredBuildNumberAndroid' : 'requiredBuildNumberIOS');

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final currentBuildNumber = int.parse(packageInfo.buildNumber);

        if (requiredBuildNumber != null && currentBuildNumber < requiredBuildNumber) {
          await _showUpdateDialog();
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  _showUpdateDialog() {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    Image.asset(
                      "assets/images/app_logo.jpg",
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    Text(
                      translate("updateTheApp"),
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 35,
                      width: 120,
                      child: TextButton(
                        onPressed: () async {
                          String updateURL = Strings.kUpgradeURLConfig[
                              Platform.isAndroid ? ((_isHmsAvailable && !_isGmsAvailable) ? 'huawei' : 'android') : 'ios'];
                          await launch(updateURL);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            translate("update"),
                            style: TextStyle(color: Color(0xFFEB7E23), fontSize: 14),
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFFEB7E23), width: 1, style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(3.0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final connection = Provider.of<ConnectivityStatus>(context);

    //it must add
    super.build(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      onModelReady: (model) {
        return model.initScreen(context, t: _HomePageState());
      },
      builder: (context, model, child) {
        if (connection == ConnectivityStatus.Offline)
          return NoInternetWidget(retryFunc: () => model.initScreen(context, t: _HomePageState()));
        if (model.categories == null && !model.isBusy) return Center(child: Text('Error'));
        // if (categoriesTabs.isEmpty &&
        //     model.categories != null &&
        //     model.categories.childrenData != null &&
        //     model.categories.childrenData.isNotEmpty) {
        //   categoriesTabs = model.categories.childrenData
        //       .map((e) => TabsLayout(e))
        //       .toList();
        // }
        if (!model.isBusy &&
            model.categories.childrenData.isNotEmpty &&
            (tabController == null || tabController.length != model.categories.childrenData.length)) {
          // print('tabController');
          tabController = TabController(length: model.categories.childrenData.length, vsync: this);
          // tabController.addListener(() {
          //   setState(() {
          //     _selectedIndex = tabController.index;
          //   });
          // });
        }
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: AppBar(
                // leading: IconButton(
                //     icon: Icon(IcoMoon.line_circle),
                //     onPressed: () {
                //       BotToast.showText(
                //         text: translate("soon"),
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         contentColor: Colors.green,
                //         contentPadding: EdgeInsets.all(10),
                //       );
                //     }),
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
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.fade,
                        //     child: QrReaderScreen(),
                        //   ),
                        // );
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
                bottom: PreferredSize(
                  child: Text(translate('freeShippingMoreThan299')),
                  preferredSize: Size.fromHeight(20),
                ),
              ),
            ),
            Expanded(
                child: model.isBusy
                    ? Center(child: Text(translate('loading')))
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              height: 58,
                              child: TabBar(
                                controller: tabController,
                                // onTap: (index){
                                //   setState(() {
                                //     _selectedIndex = index;
                                //   });
                                // },
                                tabs: model.categories.childrenData
                                    .map((e) => Tab(
                                          child: e.id == 0
                                              ? Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Icon(Icons.home),
                                                )
                                              : Text(e.name),
                                        ))
                                    .toList(),
                                isScrollable: true,
                                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                labelColor: AppColors.mainTextColor,
                                indicatorColor: AppColors.yellowColor,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: model.categories.childrenData.map((e) {
                                  // Condition for Home or Tabs layout
                                  if (e.id == 0) {
                                    return Column(
                                      children: [
                                        // Login & FAQ
                                        Container(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Provider.of<NavigationBarViewModel>(context, listen: false).setTabIndex(3);
                                                },
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        IcoMoon.user,
                                                        size: 17,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        translate('account'),
                                                        style: TextStyle(fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(top: 2),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child: HowToBuyScreen(),
                                                  ),
                                                ),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        IcoMoon.shopping_cart,
                                                        size: 20,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        translate('how_to_buy'),
                                                        style: TextStyle(fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child: FaqScreen(),
                                                  ),
                                                ),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        IcoMoon.qa,
                                                        size: 22,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        translate('faq'),
                                                        style: TextStyle(fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child: ContactUs(),
                                                  ),
                                                ),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        IcoMoon.email,
                                                        size: 20,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        translate('contact_us'),
                                                        style: TextStyle(fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          color: AppColors.greyColor,
                                          padding: EdgeInsets.all(8),
                                        ),
                                        Expanded(
                                          child: RefreshIndicator(
                                            onRefresh: () => locator<HomeViewModel>().initScreen(context, t: _HomePageState()),
                                            color: AppColors.primaryColor,
                                            child: MediaQuery.removePadding(
                                              context: context,
                                              removeTop: true,
                                              child: ListView(
                                                controller: _scrollController,
                                                children: [
                                                  // Slider
                                                  // Todo hide now for test
                                                  if (model.sliderData.data != null && model.sliderData.data.isNotEmpty)
                                                    SliderBanner(data: model.sliderData.data),
                                                  // Categories Button
                                                  // Todo hide now for test
                                                  if (model.categoryButtonData.data != null && model.categoryButtonData.data.isNotEmpty)
                                                    CategoriesButton(data: model.categoryButtonData.data),
                                                  // Categories square
                                                  // Todo hide now for test
                                                  if (model.categorySquareData.data != null && model.categorySquareData.data.isNotEmpty)
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 10),
                                                            child: Text(
                                                              translate('shop_by_cat'),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: const Color(0xff333333),
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                          ),
                                                          CategoriesSquare(
                                                            data: model.categorySquareData.data,
                                                            height: 120,
                                                          )
                                                        ],
                                                      ),
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                      // padding: const EdgeInsets.all(10.0),
                                                      color: AppColors.bgColor,
                                                    ),
                                                  // // Banner 1
                                                  // if (model.categoryBannerData?.data != null && model.categoryBannerData.data.isNotEmpty)
                                                  //   Banners(
                                                  //     model.categoryBannerData.data[0].image,
                                                  //     isAsset: false,
                                                  //     datum: model.categoryBannerData.data[0],
                                                  //   ),
                                                  // Todo hide now for test
                                                  // New arrive
                                                  if (model.categoryTopData.dataProducts != null &&
                                                      model.categoryTopData.dataProducts.isNotEmpty)
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // Header Text
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                            child: Text(
                                                              translate('recent_arrive'),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: const Color(0xff333333),
                                                              ),
                                                            ),
                                                          ),
                                                          // Product Widget
                                                          Container(
                                                            height: model.categoryTopData.dataProducts.isEmpty ? 40 : 155,
                                                            child: Visibility(
                                                              visible: model.categoryTopData.dataProducts.isNotEmpty,
                                                              replacement: Center(child: Text(translate('empty_data'))),
                                                              child: Swiper(
                                                                itemBuilder: (BuildContext context, int index) {
                                                                  List<Widget> children = [];
                                                                  int newIndex = index == 0 ? 0 : (index * 3);
                                                                  for (int i = newIndex;
                                                                      i <
                                                                          ((model.categoryTopData.dataProducts.length - newIndex > 3)
                                                                              ? newIndex + 3
                                                                              : model.categoryTopData.dataProducts.length);
                                                                      i++) {
                                                                    children.add(Container(
                                                                      width: (MediaQuery.of(context).size.width / 3) - 10,
                                                                      height: 125,
                                                                      child: ProductScreen(
                                                                        product: model.categoryTopData.dataProducts[i],
                                                                        isSmall: true,
                                                                      ),
                                                                    ));
                                                                  }
                                                                  return Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: children,
                                                                  );
                                                                },
                                                                itemCount: (model.categoryTopData.dataProducts.length > 3)
                                                                    ? (model.categoryTopData.dataProducts.length ~/ 3)
                                                                    : 1,
                                                                pagination: SwiperPagination(
                                                                    margin: EdgeInsets.only(top: 20),
                                                                    builder: DotSwiperPaginationBuilder(
                                                                        color: Colors.grey, activeColor: Colors.black)),
                                                              ),
                                                            ),
                                                            margin: EdgeInsets.only(top: 10),
                                                          )
                                                        ],
                                                      ),
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                    ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  // Todo hide now for test
                                                  // Categories
                                                  if (model.categoryCircleData.data != null && model.categoryCircleData.data.isNotEmpty)
                                                    CategoriesSquare(data: model.categoryCircleData.data),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  // // Banner 2
                                                  // if (model.categoryBotSlider?.data != null && model.categoryBotSlider.data.isNotEmpty)
                                                  //   Banners(
                                                  //     model.categoryBotSlider.data[0].image,
                                                  //     isAsset: false,
                                                  //     datum: model.categoryBotSlider.data[0],
                                                  //   ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  // Todo hide now for test
                                                  // Most Sell
                                                  if (model.categoryBottomData.dataProducts != null &&
                                                      model.categoryBottomData.dataProducts.isNotEmpty)
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // Header Text
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                            child: Text(
                                                              translate('best_seller'),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: const Color(0xff333333),
                                                              ),
                                                            ),
                                                          ),
                                                          // Product Widget
                                                          Container(
                                                            height: model.categoryBottomData.dataProducts.isEmpty ? 40 : 125,
                                                            child: Visibility(
                                                              visible: model.categoryBottomData.dataProducts.isNotEmpty,
                                                              replacement: Center(child: Text(translate('empty_data'))),
                                                              child: GridView(
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount: 1, mainAxisSpacing: 10),
                                                                scrollDirection: Axis.horizontal,
                                                                children: model.categoryBottomData.dataProducts.map((e) {
                                                                  return ProductScreen(
                                                                    product: e,
                                                                    isSmall: true,
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                            margin: EdgeInsets.only(top: 10),
                                                          )
                                                        ],
                                                      ),
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return TabsLayout(e);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      )),
          ],
        );
      },
    );
  }
}
