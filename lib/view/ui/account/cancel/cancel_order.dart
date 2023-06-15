import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/viewModel/cancel_order_view_model.dart';

import '../../../index.dart';

class CancelOrder extends StatelessWidget {
  final MyOrdersItem item;
  final bool isFromDetailOrder;

  CancelOrder(this.item, this.isFromDetailOrder);

  final TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16);
  final TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 14, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('submitCancelOrderRequest')),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        margin: EdgeInsets.all(10),
        child: ViewModelBuilder<CancelOrderViewModel>.reactive(
          viewModelBuilder: () => CancelOrderViewModel(),
          disposeViewModel: false,
          onModelReady: (model) => model.initReasonsData(context),
          builder: (context, model, child) {
            if (model.isBusy) return Center(child: Text(translate('loading')));
            // if (model.data == null) return Center(child: Text(translate('empty_data')));
            return ListView(children: [
              Column(
                children: [
                  // Shipping address
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(IcoMoon.home),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(translate('shipping_address'), style: styleHead),
                          )
                        ],
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.billingAddress.street[0]),
                            Text(item.billingAddress.countryId + ", " + item.billingAddress.city),
                            Text(item.billingAddress.telephone),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  // information personal
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesome.files_o),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(translate('personal_info'), style: styleHead),
                          )
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(children: [
                              Text(translate('return_id'), style: styleBody),
                              SizedBox(width: 15),
                              Text(item.incrementId.toString())
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text(translate('user_name'), style: styleBody),
                              SizedBox(width: 15),
                              Text(item.billingAddress.firstname + ' ' + item.billingAddress.lastname)
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text(translate('email'), style: styleBody),
                              SizedBox(width: 15),
                              Text(item.billingAddress.email)
                            ]),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),

                  // Comments
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesome.shopping_bag,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(translate('cancel_order_details'), style: styleHead),
                          )
                        ],
                      ),
                      Form(
                        key: model.userForm,
                        child: Column(
                          children: [
                            // reason
                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[400])),
                                padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        hint: Text(translate('resolution')),
                                        onChanged: (value) => model.updateReason(value.toString()),
                                        isDense: true,
                                        isExpanded: true,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (String value) => Validators.validateForm(value),
                                        items: model.reasons.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              translate(value),
                                              overflow: TextOverflow.visible,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                            // Message
                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[400])),
                                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  // initialValue: model.data.email,
                                  controller: model.commentText,
                                  onChanged: (value) => model.updateComment(value),
                                  validator: (String value) => Validators.validateForm(value),
                                  decoration: InputDecoration(
                                      hintText: translate('message'),
                                      hintStyle: TextStyle(fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => model.submitCancel(context, item, isFromDetailOrder),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      color: AppColors.mainTextColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      translate('send'),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
            ]);
          },
        ),
      ),
    );
  }
}
