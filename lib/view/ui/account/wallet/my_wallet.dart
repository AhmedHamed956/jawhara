import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/viewModel/wallet_view_model.dart';

import '../../../index.dart';

class MyWallet extends StatelessWidget {
  final TextStyle styleHead = TextStyle(
      color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  final TextStyle styleBody =
      TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    // var localizationDelegate = LocalizedApp.of(context).delegate;
    // var lang = localizationDelegate.currentLocale.languageCode;
    // final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translate('wallet')),
      ),
      body: ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => WalletViewModel(),
        disposeViewModel: false,
        onModelReady: (model) {
          model.initScreen(context);
        },
        builder: (context, model, child) {
          if (model.isBusy) return Center(child: Text(translate('loading')));
          if (model.data == null)
            return Center(child: Text(translate('empty_data')));
          return ListView(children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Card(
                color: HexColor("#F8F8F8"),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(translate("walletDetails"),
                        style: TextStyle(
                            color: HexColor("#111111"),
                            fontSize: 20)),
                    SizedBox(height: 10),
                    Container(
                        height: 80,
                        child: Image.asset("assets/images/wallet.png")),
                    SizedBox(height: 10),
                    Text(translate("availableBalance"),
                        style: TextStyle(
                            color: HexColor("#111111"),
                            fontSize: 20)),
                    SizedBox(height: 10),
                    Text("${model.currentBalance} ${translate("SAR")}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#24ED22"),
                            fontSize: 20)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
