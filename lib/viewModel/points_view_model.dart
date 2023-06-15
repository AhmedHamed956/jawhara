import 'package:bot_toast/bot_toast.dart';
import 'package:jawhara/core/api/auth.dart';
import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/model/points/alert.dart' as alert;
import 'package:jawhara/model/points/check.dart';
import 'package:jawhara/model/points/history.dart';
import 'package:jawhara/model/points/points.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../view/index.dart';
import 'cart_view_model.dart';

class PointsViewModel extends BaseViewModel {
  PointsViewModel();

  final HandlingError handle = HandlingError.handle;
  CommonApi _api = CommonApi();
  Data data = Data();
  List<Item> items = [];

  bool isHistoryLoad = false;
  alert.Data alertData;
  CheckData checkPoint;

  // init Point data
  initScreen(context, {onComplete}) async {
    print('### Init initScreen ###');
    setBusy(true);
    final r = await _api.getPointsData(context);
    if (r != null) {
      data = r.data;
      if (onComplete != null) onComplete();
    }
    setBusy(false);
  }

  // init History data
  getHistory(context) async {
    print('### Init getHistory ###');
    isHistoryLoad = true;
    notifyListeners();
    final r = await _api.getHistoryData(context);
    if (r != null) {
      items = r.items;
    }
    isHistoryLoad = false;
    notifyListeners();
  }

  // Get alert data
  getAlert(context) async {
    print('### Init getAlert ###');
    setBusy(true);
    final r = await _api.getAlertData(context);
    if (r != null) {
      alertData = r.data;
    }
    setBusy(false);
  }

  // Get alert data
  checkAvailablePoint(context) async {
    print('### Init check For Available Point ###');
    setBusy(true);
    final r = await _api.getCheckAvailablePointData(context);
    if (r != null) {
      checkPoint = r.data;
    }
    setBusy(false);
  }

  useReward(context) async {
    print('### use Reward Point###');
    setBusy(true);
    await _api.useRewardData(context);
    setBusy(false);
    checkAvailablePoint(context);
    locator<CartViewModel>().initCheckOut(context);
  }
  removeReward(context) async {
    print('### remove Reward Point###');
    setBusy(true);
    await _api.removeRewardData(context);
    setBusy(false);
    checkAvailablePoint(context);
    locator<CartViewModel>().initCheckOut(context);
  }
}
