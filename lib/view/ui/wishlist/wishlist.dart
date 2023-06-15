import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/widgets/product_wish_list.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';

import '../../index.dart';

class WishListPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<WishListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController controller = new ScrollController();
  List<Product> _linkedProducts = [
    Product(price: '100', name: 'test1', thumbnail: '', sale: '0'),
    Product(price: '200', name: 'test2', thumbnail: ''),
    Product(price: '300', name: 'test3', thumbnail: ''),
    Product(price: '400', name: 'test4', thumbnail: ''),
    Product(price: '500', name: 'test5', thumbnail: ''),
  ];

  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.width / 3;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final connection = Provider.of<ConnectivityStatus>(context);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
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
      body: ViewModelBuilder<WishListViewModel>.reactive(
        viewModelBuilder: () => locator<WishListViewModel>(),
        disposeViewModel: false,
        fireOnModelReadyOnce: true,
        onModelReady: (model) => model.initScreen(context),
        builder: (context, model, child) {
          // print(model.cart.items);
          if (connection == ConnectivityStatus.Offline) return NoInternetWidget(retryFunc: () => model.initScreen(context));
          if (_auth.currentUser == null)
            return Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: SignIn(),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
            );
          if (model.isBusy) return Center(child: Text(translate('loading')));
          if (model.wishlist == null|| model.wishlist.isEmpty)
            return Center(child: Text(translate('empty_data')));
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(translate('wish_list')),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: AppColors.greyColor,
                            ),
                          ),
                          Column(
                              children: model.wishlist
                                  .map((e) => Container(
                                        child: Column(
                                          children: [
                                            ProductWishListScreen(
                                                direction: Axis.vertical,
                                                item: e,
                                                index:
                                                    model.wishlist.indexOf(e)),
                                            Divider(
                                              endIndent: 60,
                                              indent: 20,
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList()),
                        ],
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}
