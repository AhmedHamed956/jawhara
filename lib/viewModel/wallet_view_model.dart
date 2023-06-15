import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/model/points/history.dart';
import 'package:jawhara/model/points/points.dart';

import '../view/index.dart';

class WalletViewModel extends BaseViewModel {
  final HandlingError handle = HandlingError.handle;
  CommonApi _api = CommonApi();
  Data data = Data();
  List<Item> items = [];
  double currentBalance;

  // init Point data
  initScreen(context, {onComplete}) async {
    print('### Init initScreen WalletViewModel ###');
    setBusy(true);
    final r = await _api.getWalletBalance(context);
    if (r != null) {
      currentBalance = r;
      if (onComplete != null) onComplete();
    }
    setBusy(false);
  }
}
