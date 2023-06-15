import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/view/ui/account/return/return_details.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/return_order_view_model.dart';
import 'package:provider/provider.dart';
import '../../../index.dart';

class ReturnHistory extends StatelessWidget {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 14, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('return_orders')),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        margin: EdgeInsets.all(10),
        child: ViewModelBuilder<ReturnOrderViewModel>.reactive(
          viewModelBuilder: () => ReturnOrderViewModel(),
          disposeViewModel: false,
          onModelReady: (model) => model.initScreen(context),
          builder: (context, model, child) {
            if (model.isBusy) return Center(child: Text(translate('loading')));
            if (model.items.isEmpty) return Center(child: Text(translate('empty_data')));
            return ListView(
              children: model.items
                  .map((e) => GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ReturnDetails(e.orderIncrementId),
                          ),
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: e.status == 'pending'
                                            ? Colors.grey
                                            : e.status == 'processed_closed'
                                                ? Colors.red
                                                : e.status == 'received' || e.status == 'authorized'
                                                    ? Colors.green
                                                    : Colors.blue,
                                        maxRadius: 7),
                                    SizedBox(width: 5),
                                    Text(translate(e.status), style: styleHead)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    children: [
                                      Row(children: [Text(translate('num_order'), style: styleBody), SizedBox(width: 15), Text(e.orderId)]),
                                      Row(children: [
                                        Text(translate('date'), style: styleBody),
                                        SizedBox(width: 15),
                                        Text(formatDate(e.orderDate.toUtc(), [dd, '/', mm, '/', yyyy]))
                                      ]),
                                      Row(children: [
                                        Text(translate('ship_from'), style: styleBody),
                                        SizedBox(width: 15),
                                        Text(e.customerName)
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                          color: e.status == 'pending'
                              ? Colors.grey[100]
                              : e.status == 'processed_closed'
                              ? Colors.red[100]
                              : e.status == 'received' || e.status == 'authorized'
                              ? Colors.green[100]
                              : Colors.blue[100],
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
