import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/points_view_model.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

class MyPoints extends StatelessWidget {
  TextStyle styleHead = TextStyle(
      color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody =
      TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('my_points')),
      ),
      body: ViewModelBuilder<PointsViewModel>.reactive(
        viewModelBuilder: () => PointsViewModel(),
        disposeViewModel: false,
        onModelReady: (model) {
          model.initScreen(context);
          model.getHistory(context);
        },
        builder: (context, model, child) {
          if (model.isBusy) return Center(child: Text(translate('loading')));
          if (model.data == null)
            return Center(child: Text(translate('empty_data')));
          return Directionality(
            textDirection:
                SharedData.lang == "ar" ? TextDirection.rtl : TextDirection.ltr,
            child: ListView(children: [
              // Title
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(translate('reward_balance_info'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 13),
                      textAlign: TextAlign.start)),
              Container(
                  child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/bg_point.png',
                      fit: BoxFit.cover,
                    ),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                        // padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15.0),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    '${translate('your_balance')} ${(model.data.reward.pointsBalance?.toString()) ?? '0'} ${translate('reward')} ${translate('points')} (${double.parse(model.data.reward.currencyBalance.toString()).toDouble()} ${SharedData.currency})',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                    textAlign: TextAlign.center)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(model.data.rewardExchange,
                                  style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(model.data.rewardExchangePoint,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainTextColor,
                                      fontSize: 20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(model.data.rewardExchangeCurrency,
                                  style: TextStyle(
                                      color: AppColors.mainTextColor,
                                      fontSize: 20)),
                            ),
                          ],
                        )),
                  ),
                ],
              )),
              SizedBox(height: 10),
              Container(
                color: HexColor("#F7B402"),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/reward.png'),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  dense: true,
                  title: Text(model.data.rewardMaximumLimit,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              Container(
                color: HexColor("#2682E6"),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/reward.png'),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  dense: true,
                  title: Text(model.data.rewardMimimumBalance,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              Container(
                color: HexColor("#05BBBD"),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/reward.png'),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  dense: true,
                  title: Text(model.data.rewardReached,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(translate('balance_history'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 13),
                      textAlign: TextAlign.start)),
              model.isHistoryLoad
                  ? Center(child: Text(translate('loading')))
                  : (model.items == null || model.items.isEmpty)
                      ? Center(child: Text(translate('empty_data')))
                      : Column(
                          children: model.items
                              .map((e) => Container(
                                    color: Colors.grey[200],
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        e.reason,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      subtitle: Text(e.date.toString(),
                                          style: TextStyle(fontSize: 15)),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(e.action.contains("-") ? e.action : "+${e.action}"),
                                          Text(e.amount),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
            ]),
          );
        },
      ),
    );
  }
}
