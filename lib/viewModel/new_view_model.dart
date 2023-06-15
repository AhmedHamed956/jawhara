import 'package:jawhara/core/api/common.dart';
import '../view/index.dart';

class NewViewModel extends BaseViewModel {
  NewViewModel();

  CommonApi _api = CommonApi();

  // init ViewModel data
  initScreen(context) async {
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    // final r = await _api.getData(context);
    setBusy(false);
  }
}
