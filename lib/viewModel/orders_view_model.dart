import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/model/orders/track_information.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';
import 'cart_view_model.dart';

const ALL_ORDERS = 'all_orders';
const PENDING = 'pending';
const PROCESS = 'processing';
const SUSPECTED_FRAUD = 'fraud';
const PENDING_PAYMENT = 'pending_payment';
const PAYMENT_REVIEW = 'payment_review';
const ON_HOLD = 'holded';
const OPEN = 'STATE_OPEN';
const COMPLETE = 'complete';
const CLOSED = 'closed';
const CANCELED = 'canceled';

class OrdersViewModel extends BaseViewModel {
  OrdersViewModel();

  CommonApi _api = CommonApi();
  MyOrders myOrders = MyOrders();
  TrackInformation track = TrackInformation();
  bool isLastPage = false;
  String noMoreDataMessage;
  int page = 1;
  bool isReorder = false;
  int selectedOrderId;

  // init Categories data
  initScreen(context, index, {bool isLoadMore = false, pageInit = 1}) async {
    print(index);
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    if (!isLoadMore) page = pageInit;
    final r = await _api.getMyOrdersData(context, status: index, page: page);
    if (r != null) {
      if (isLoadMore) {
        r.items.forEach((element) {
          myOrders.items.add(element);
        });
      } else {
        myOrders = r;
        page = 2;
      }
      if (r.items.isEmpty) {
        isLastPage = true;
        noMoreDataMessage = translate('no_more_data');
      } else {
        noMoreDataMessage = translate('loading');
      }

      if (isLoadMore) page++;
    }
    setBusy(false);
  }

  reCallInit(context, index, {loadMore = false}) async {
    await Future.delayed(Duration(seconds: 1), () {
      initScreen(context, index, isLoadMore: loadMore);
    });
  }

  reOrder(context, orderId, isFromDetailOrder) async {
    print('orderId > $orderId');
    print('### Init ${this.runtimeType} ###');
    isReorder = true;
    selectedOrderId = orderId;
    notifyListeners();
    final r = await _api.reOrder(context, orderId);
    if (r) {
      if (isFromDetailOrder) Navigator.pop(context);
      Navigator.pop(context);
      (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(4);
      locator<CartViewModel>().initScreen(context);
    }
    isReorder = false;
    notifyListeners();
  }

  // get track information
  getTrack(context, int orderId) async {
    setBusy(true);
    final r = await _api.getTrack(context, orderId.toString());
    if (r != null) {
      track = r;
      print('track > $track');
    }
    setBusy(false);
  }
}
