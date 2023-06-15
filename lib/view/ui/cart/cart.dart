import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:jawhara/view/ui/cart/shipping.dart';
import 'package:jawhara/view/widgets/product_list.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../index.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController controller = ScrollController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _onRefresh(model) {
    model.initScreen(context, afterEnd: () {
      _refreshController.refreshCompleted();
    });
  }

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
      body: ViewModelBuilder<CartViewModel>.reactive(
        viewModelBuilder: () => locator<CartViewModel>(),
        disposeViewModel: false,
        fireOnModelReadyOnce: true,
        onModelReady: (model) => model.initScreen(context),
        builder: (context, model, child) {
          if (connection == ConnectivityStatus.Offline) return NoInternetWidget(retryFunc: () => model.initScreen(context));

          print(model.cart.items);
          if (model.cart.items != null &&
              model.cart.items.isNotEmpty &&
              (model.checkout == null || model.checkout.subtotalInclTax == null) &&
              !model.isCheckoutLoad &&
              !model.isCheckoutLoadFailed) {
            model.initCheckOut(context);
          }
          // if (_auth.currentUser == null)
          //   return Center(
          //     child: GestureDetector(
          //       onTap: () => Navigator.push(
          //         context,
          //         PageTransition(
          //           type: PageTransitionType.fade,
          //           child: SignIn(),
          //         ),
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Center(
          //               heightFactor: 1.5,
          //               child: CircleAvatar(
          //                 backgroundImage: NetworkImage(Strings.GUEST_IMAGE),
          //                 radius: 50,
          //               )),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(translate('welcomeL')),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          if (model.isBusy) return Center(child: Text(translate('loading')));
          if (model.cart.items == null) return Center(child: Text(translate('empty_shop_cart')));
          if (model.cart.items.isEmpty) return Center(child: Text(translate('empty_shop_cart')));
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: _refreshController,
                onRefresh: () {
                  _onRefresh(model);
                },
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_hasOutOfStockItems(model.cart.items))
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                translate('itemsOutOfStock'),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontFamily.cairo,
                                    decorationThickness: 4,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ]),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(translate('shop_cart')),
                              Text("${model.cart.items.length ?? 0}" + ' ' + translate('products')),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: AppColors.greyColor,
                          ),
                        ),
                        Column(
                            children: model.cart.items
                                .map((e) => Container(
                                      child: Column(
                                        children: [
                                          ProductListScreen(
                                            direction: Axis.vertical,
                                            item: e,
                                          ),
                                          Divider(
                                            endIndent: 60,
                                            indent: 20,
                                          )
                                        ],
                                      ),
                                    ))
                                .toList()),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              color: AppColors.bgColor,
                            ),
                            padding: EdgeInsets.only(right: 10, left: 10, top: 10),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: translate('enter_coupon'), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            controller: model.textEditingController,
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                        child: model.isCouponLoad
                                            ? Center(child: ShapeLoading())
                                            : model.checkout.couponCode == null
                                                ? GestureDetector(
                                                    onTap: () => model.addCoupon(context),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                      // padding: EdgeInsets.symmetric(
                                                      //   horizontal: 25,
                                                      // ),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(1.0),
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.grey[200])),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        translate('confirm'),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () => model.deleteCoupon(context),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                      // padding: EdgeInsets.symmetric(
                                                      //   horizontal: 25,
                                                      // ),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(1.0),
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.grey[200])),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        translate('remove'),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.redAccent,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                        flex: 1)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          child: TextFormField(
                                            keyboardType: TextInputType.name,
                                            // initialValue: model.data.email,
                                            // onChanged: (value) => model.data.lastName = value,
                                            // validator: (String value) => Validators.validateName(value),
                                            decoration: InputDecoration(
                                                hintText: translate('enter_gift_card'),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            controller: model.textEditingGiftController,
                                            readOnly: model.giftCardSegment.code != null,
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                        child: model.isGiftLoad
                                            ? Center(child: ShapeLoading())
                                            : model.giftCardSegment.code == null
                                                ? GestureDetector(
                                                    onTap: () => model.addGiftCard(context),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                      // padding: EdgeInsets.symmetric(
                                                      //   horizontal: 25,
                                                      // ),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(1.0),
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.grey[200])),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        translate('confirm'),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () => model.deleteGiftCard(context),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                      // padding: EdgeInsets.symmetric(
                                                      //   horizontal: 25,
                                                      // ),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(1.0),
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.grey[200])),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        translate('remove'),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.redAccent,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                        flex: 1)
                                  ],
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text(translate('products')),
                                  trailing: Text('${model.cart.items.length ?? 0}'),
                                ),
                                if (model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  Center(
                                      child: ShapeLoading(
                                    color: Colors.black,
                                    size: 60,
                                  )),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text(translate('sub_total')),
                                    trailing: Text('${model.checkout.subtotalInclTax} ' + SharedData.currency),
                                  ),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text("${translate('ship_cost')}"),
                                    trailing: Text('${model.checkout.shippingInclTax} ' + SharedData.currency),
                                  ),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text(translate('tax')),
                                    trailing: Text('${model.checkout?.taxAmount} ' + SharedData.currency),
                                  ),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text(translate('discount')),
                                    trailing: Text('${model.checkout.baseDiscountAmount} ' + SharedData.currency),
                                  ),
                                // ListTile(
                                //   title: Text(translate('reward') +
                                //       ' ' +
                                //       translate('points')),
                                //   trailing: Text(
                                //       '${model.checkout.totalSegments == null ? '' : model.checkout.totalSegments.firstWhere((element) => element.code == 'reward', orElse: () => null)?.value ?? ""} ' +
                                //           SharedData.currency),
                                //   dense: true,
                                // ),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text(translate('gift')),
                                    trailing: Text('${model.giftCardSegment.value ?? '0'} ' + SharedData.currency),
                                  ),
                                if (!model.isCheckoutLoad && !model.isCheckoutLoadFailed)
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      translate('total'),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text('${(model.checkout?.baseGrandTotal ?? 0)} ' + SharedData.currency,
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                if (model.isCheckoutLoadFailed)
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      translate('errorWhileGettingCheckoutInfo'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                              ],
                            )),
                        // Todo Reward hidden now
                        // if (_auth.currentUser != null)
                        //   ViewModelBuilder<PointsViewModel>.reactive(
                        //     viewModelBuilder: () => PointsViewModel(),
                        //     disposeViewModel: false,
                        //     onModelReady: (model) {
                        //       model.getAlert(context);
                        //       model.checkAvailablePoint(context);
                        //     },
                        //     builder: (context, model, child) {
                        //       if (model.isBusy)
                        //         return Center(child: Text(translate('loading')));
                        //       if (model.alertData != null)
                        //         return Wrap(
                        //           children: [
                        //             Container(
                        //               child: Text(
                        //                 translate('check_earn') +
                        //                     ' ${model.alertData.itemRewardPoints} ' +
                        //                     translate('reward') +
                        //                     ' ' +
                        //                     translate('points') +
                        //                     ' (${model.alertData.itemRewardAmount}) ' +
                        //                     translate('for_order') +
                        //                     '\n' +
                        //                     translate('your_balance') +
                        //                     ' ${model.alertData.totalPointsBalance} ' +
                        //                     translate('reward') +
                        //                     ' ' +
                        //                     translate('points'),
                        //                 style: TextStyle(
                        //                     color: AppColors.primaryColor,
                        //                     fontSize: 12),
                        //               ),
                        //               width: MediaQuery.of(context).size.width,
                        //               margin: EdgeInsets.only(
                        //                   top: 10, left: 10, right: 10),
                        //               padding: EdgeInsets.all(10),
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius.all(Radius.circular(4)),
                        //                 color: AppColors.yellowColor
                        //                     .withOpacity(0.6),
                        //               ),
                        //             ),
                        //             Container(
                        //               child: Text(
                        //                 translate('check_earn') +
                        //                     ' ${model.alertData.ruleRewardPoints} ' +
                        //                     translate('reward') +
                        //                     ' ' +
                        //                     translate('points') +
                        //                     ' (${model.alertData.ruleRewardAmount}) ' +
                        //                     translate('for_order') +
                        //                     '\n' +
                        //                     translate('your_balance') +
                        //                     ' ${model.alertData.totalPointsBalance} ' +
                        //                     translate('reward') +
                        //                     ' ' +
                        //                     translate('points'),
                        //                 style: TextStyle(
                        //                     color: AppColors.primaryColor,
                        //                     fontSize: 12),
                        //               ),
                        //               width: MediaQuery.of(context).size.width,
                        //               margin: EdgeInsets.only(
                        //                   top: 10, left: 10, right: 10),
                        //               padding: EdgeInsets.all(10),
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius.all(Radius.circular(4)),
                        //                 color: AppColors.yellowColor
                        //                     .withOpacity(0.6),
                        //               ),
                        //             ),
                        //             Visibility(
                        //               visible: model.checkPoint.response,
                        //               child: GestureDetector(
                        //                 onTap: () => model.useReward(context),
                        //                 child: Container(
                        //                   margin: EdgeInsets.symmetric(
                        //                       horizontal: 15, vertical: 10),
                        //                   padding: EdgeInsets.symmetric(
                        //                     horizontal: 25,
                        //                   ),
                        //                   height: 35.0,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(0.0),
                        //                     color: AppColors.greenColor,
                        //                   ),
                        //                   alignment: Alignment.center,
                        //                   child: Text(
                        //                     '(${model.alertData.totalPointsBalance.toString()})' +
                        //                         ' ' +
                        //                         translate('reward') +
                        //                         ' ' +
                        //                         translate('points'),
                        //                     style: TextStyle(
                        //                       fontSize: 12,
                        //                       color: Colors.white,
                        //                     ),
                        //                     textAlign: TextAlign.center,
                        //                   ),
                        //                   width:
                        //                       MediaQuery.of(context).size.width /
                        //                           2,
                        //                 ),
                        //               ),
                        //               replacement: GestureDetector(
                        //                 onTap: () => model.removeReward(context),
                        //                 child: Container(
                        //                   margin: EdgeInsets.symmetric(
                        //                       horizontal: 15, vertical: 10),
                        //                   padding: EdgeInsets.symmetric(
                        //                     horizontal: 25,
                        //                   ),
                        //                   height: 35.0,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(0.0),
                        //                     color: AppColors.redColor,
                        //                   ),
                        //                   alignment: Alignment.center,
                        //                   child: Text(
                        //                     translate('remove') +
                        //                         ' ' +
                        //                         translate('reward') +
                        //                         ' ' +
                        //                         translate('points'),
                        //                     style: TextStyle(
                        //                       fontSize: 12,
                        //                       color: Colors.white,
                        //                     ),
                        //                     textAlign: TextAlign.center,
                        //                   ),
                        //                   width:
                        //                       MediaQuery.of(context).size.width /
                        //                           2,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         );
                        //       return Container();
                        //     },
                        //   ),
                        GestureDetector(
                          onTap: _hasOutOfStockItems(model.cart.items)
                              ? null
                              : () {
                                  model.initScreen(context, afterEnd: () {
                                    _refreshController.refreshCompleted();
                                    if (!_hasOutOfStockItems(model.cart.items)) {
                                      if (_auth.currentUser == null) {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: SignIn(isFromCart: true),
                                          ),
                                        );
                                      } else
                                        return Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: ShippingPage(),
                                          ),
                                        );
                                    }
                                  });
                                },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              color: _hasOutOfStockItems(model.cart.items) ? Color(0xffd3d3d3) : AppColors.mainTextColor,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              translate('continue_checkout'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (model.youMightLikeProducts.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              translate('may_like'),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        if (model.youMightLikeProducts.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: model.youMightLikeProducts
                                    .map((item) => Container(
                                        height: 200,
                                        width: (MediaQuery.of(context).size.width / 3) - 10,
                                        child: ProductScreen(
                                          direction: Axis.vertical,
                                          product: item,
                                          isRelative: true,
                                        )))
                                    .toList()),
                          ),
                      ],
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  bool _hasOutOfStockItems(items) {
    bool hasOutStockItems = false;
    for (var item in items) {
      if (item.extensionAttributes.isInStock != null && !item.extensionAttributes.isInStock) {
        hasOutStockItems = true;
        break;
      }
    }

    return hasOutStockItems;
  }
}
