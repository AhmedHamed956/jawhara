import 'package:badges/badges.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:provider/provider.dart';
import '../../index.dart';
import 'filters.dart';

class ProductsPage extends StatefulWidget {
  List<CategoriesChildrenDatum> cat = List();
  int index;

  ProductsPage(this.cat, {this.index = 0});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController _scrollController = new ScrollController();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          _searching == false) {
        setState(() {
          _searching = true;
        });
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          _searching == true) {
        setState(() {
          _searching = false;
        });
      }
    });
    _tabController =
        new TabController(vsync: this, length: this.widget.cat.length);
    _handleSelected();
  }

  void _handleSelected() {
    setState(() {
      _tabController.animateTo((_tabController.index + widget.index));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context); //You must add this
    return DefaultTabController(
      length: widget.cat.length,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: SearchBar(
              isSearching: _searching,
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context)),
            elevation: 0,
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
              IconButton(icon: Icon(IcoMoon.barcode), onPressed: null),
              IconButton(
                  icon: Icon(
                    IcoMoon.notification,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: null),
            ],
            bottom: new TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: AppColors.secondaryColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: widget.cat
                  .map((e) =>
                      Tab(text: e.name == 'All' ? translate('all') : e.name))
                  .toList(),
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14),
              unselectedLabelColor: AppColors.darkGreyColor,
            )),
        bottomNavigationBar: BottomNavigationBar(
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
                          style: TextStyle(color: Colors.white, fontSize: 11)),
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
                          style: TextStyle(color: Colors.white, fontSize: 11)),
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
          currentIndex:
          locator<NavigationBarViewModel>()
              .currentTabIndex,
          selectedItemColor: AppColors.thirdColor,
          unselectedItemColor: AppColors.darkGreyColor,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            Navigator.of(context).pop();
            locator<NavigationBarViewModel>().setTabIndex(value);

          //   Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(builder: (context) => NavigationBar()),
          //       (Route<dynamic> route) => false);
          //   // Todo globalKey
          //   // .then((value) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     (MainTabControlDelegate.getInstance().globalKey.currentWidget
          //             as BottomNavigationBar)
          //         .onTap(value);
          //   });
          },
        ),
        endDrawer: Filters(),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list),
                          Text(translate('filter'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.cat.map((e) {
                  return TabsProducts(e);
                }).toList(),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
