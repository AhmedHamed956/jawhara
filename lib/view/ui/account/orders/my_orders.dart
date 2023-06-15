import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/view/ui/account/cancel/cancel_order.dart';
import 'package:jawhara/view/ui/account/orders/order_details.dart';
import 'package:jawhara/view/ui/account/return/new_return.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

import '../../../index.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);

  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 12);
  TabController _tabController;
  List array = [ALL_ORDERS, PENDING, PROCESS, SUSPECTED_FRAUD, PENDING_PAYMENT, PAYMENT_REVIEW, ON_HOLD, OPEN, COMPLETE, CLOSED, CANCELED];

  Map<String, dynamic> statusColors = {"pending": AppColors.yellowColor, "processing": Colors.blue, "complete": Colors.green};

  @override
  void dispose() {
    try {
      _tabController.dispose();
    } catch (e) {
      print(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
            title: Text(translate('my_order')),
            bottom: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: translate('all_orders')),
                Tab(text: translate('pending')),
                Tab(text: translate('prepare')),
                Tab(text: translate('suspect_fraud')),
                Tab(text: translate('pend_payment')),
                Tab(text: translate('payment_review')),
                Tab(text: translate('hold')),
                Tab(text: translate('open')),
                Tab(text: translate('completed')),
                Tab(text: translate('closed')),
                Tab(text: translate('canceled')),
              ],
              indicatorColor: AppColors.yellowColor,
              labelColor: AppColors.primaryColor,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14),
              unselectedLabelColor: AppColors.darkGreyColor,
            )),
        body: TabBarView(
          controller: _tabController,
          children: array.map((index) {
            return ViewModelBuilder<OrdersViewModel>.reactive(
              viewModelBuilder: () => OrdersViewModel(),
              disposeViewModel: false,
              onModelReady: (model) => model.initScreen(context, index),
              builder: (context, model, child) {
                if ((model.isBusy && !model.isLastPage) && (model.myOrders.items == null || model.myOrders.items.isEmpty))
                  return ShapeLoadingR();
                if (model.isBusy && model.isLastPage) return Center(child: Text(translate('loading')));
                if (model.myOrders.items == null || model.myOrders.items.isEmpty) return Center(child: Text(translate('empty_data')));

                final data = model.myOrders.items;
                return RefreshLoadmore(
                  onRefresh: () => model.initScreen(context, index),
                  onLoadmore: () => model.reCallInit(context, index, loadMore: true),
                  noMoreWidget: Center(child: Text(model.isLastPage ? model.noMoreDataMessage : "")),
                  isLastPage: model.isLastPage,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: data.map((e) {
                          return ListTile(
                            title: Row(
                              children: [
                                CircleAvatar(backgroundColor: statusColors[e.status] ?? Colors.grey, maxRadius: 7),
                                SizedBox(width: 5),
                                Text(translate(e.status), style: styleHead)
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(translate('num_order'), style: styleBody),
                                      SizedBox(width: 5),
                                      Text(e.incrementId.toString(), style: styleBody)
                                    ],
                                  ),
                                  Container(
                                    height: 120,
                                    child: GridView(
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                                      children: e.items
                                          .map((x) => Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: x.extensionAttributes == null
                                                  ? Image.asset(
                                                      'assets/images/placeholder.png',
                                                      fit: BoxFit.fill,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: Strings.Image_URL + x.extensionAttributes.imageUrl,
                                                      // maxHeightDiskCache: 80,
                                                      // maxWidthDiskCache: 80,
                                              )))
                                          .toList(),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(e.items.length.toString(), style: styleBody),
                                          SizedBox(width: 5),
                                          Text(translate('products'), style: styleBody),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Text(translate('total'), style: styleBody),
                                          SizedBox(width: 5),
                                          Text((e.grandTotal?.toString() ?? e.grandTotal.toString()) + ' ' + SharedData.currency,
                                              style: styleBody.copyWith(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  buttonCancelAndReorder(context: context, item: e, index: index, model: model)
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(e, index, model))),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

Widget buttonCancelAndReorder(
    {@required context, @required MyOrdersItem item, @required String index, @required OrdersViewModel model, isFromDetailOrder = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (item.status == 'complete' || item.status == 'completed')
        GestureDetector(
          onTap: () async {
            if (item.updatedAt.difference(DateTime.now()).inDays.abs() >= 21) {
              return showDialog<void>(
                context: context,
                barrierDismissible: false,
                // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(translate('return_order_message_alert')),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(translate('ok')),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              bool updated = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: NewReturn(item),
                ),
              );

              if (updated != null && updated) {
                model.initScreen(context, index);
              }
            }
          },
          child: Container(
            width: 80,
            height: 25.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: AppColors.mainTextColor,
            ),
            alignment: Alignment.center,
            child: Text(
              translate('return'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      if (item.status == 'pending')
        GestureDetector(
          onTap: () async {
            bool updated = await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: CancelOrder(item, isFromDetailOrder),
              ),
            );
            if (updated != null && updated) {
              model.initScreen(context, index);
            }
          },
          child: Container(
            width: 80,
            height: 25.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: AppColors.mainTextColor,
            ),
            alignment: Alignment.center,
            child: Text(
              translate('cancelOrder'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      if (item.status != 'canceled' || item.status == 'pending') SizedBox(width: 20),
      if (item.status == 'canceled' || item.status == 'complete' || item.status == 'completed' || item.status == 'processing')
        model.isReorder && item.items.first.orderId == model.selectedOrderId
            ? ShapeLoading()
            : GestureDetector(
                onTap: () {
                  model.reOrder(context, item.items.first.orderId, isFromDetailOrder);
                },
                child: Container(
                  width: 80,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: AppColors.mainTextColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    translate('reorder'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
    ],
  );
}
