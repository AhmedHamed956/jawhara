import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/return_order_view_model.dart';
import 'package:provider/provider.dart';
import '../../../index.dart';

class ReturnDetails extends StatelessWidget {
  String returnID;

  ReturnDetails(this.returnID);

  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 14, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('return_orders_details')),
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
          onModelReady: (model) => model.initScreenDetail(context, returnID),
          builder: (context, model, child) {
            if (model.isBusy) return Center(child: Text(translate('loading')));
            if (model.data == null) return Center(child: Text(translate('empty_data')));
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
                        child: HtmlWidget(model.data.shippingAddress),
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
                            Row(children: [Text(translate('return_id'), style: styleBody), SizedBox(width: 15), Text(model.data.returnId)]),
                            Row(children: [Text(translate('num_order'), style: styleBody), SizedBox(width: 15), Text(model.data.orderId)]),
                            Row(children: [
                              Text(translate('date'), style: styleBody),
                              SizedBox(width: 15),
                              Text(formatDate(model.data.dateRequested.toUtc(), [dd, '/', mm, '/', yyyy]))
                            ]),
                            Row(children: [
                              Text(translate('email'), style: styleBody),
                              SizedBox(width: 15),
                              Text(model.data.email.toString())
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

                  // detail order
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesome.refresh),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(translate('order_return_details'), style: styleHead),
                          )
                        ],
                      ),
                      Column(
                        children: model.data.items
                            .map((e) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(backgroundColor:e.status == 'pending'
                                                ? Colors.grey
                                                : e.status == 'processed_closed'
                                                ? Colors.red
                                                : e.status == 'received' || e.status == 'authorized'
                                                ? Colors.green
                                                : Colors.blue, maxRadius: 7),
                                            SizedBox(width: 5),
                                            Text(translate(e.status), style: styleHead)
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            children: [
                                              Wrap(children: [
                                                Text(translate('name'), style: styleBody),
                                                SizedBox(width: 15),
                                                Text(
                                                  e.name.toString(),
                                                )
                                              ]),
                                              Row(children: [
                                                Text(translate('sku'), style: styleBody),
                                                SizedBox(width: 15),
                                                Text(e.sku.toString())
                                              ]),
                                              Row(children: [
                                                Text(translate('condition'), style: styleBody),
                                                SizedBox(width: 15),
                                                Text(e.condition.toString())
                                              ]),
                                              Row(children: [
                                                Text(translate('resolution'), style: styleBody),
                                                SizedBox(width: 15),
                                                Text(e.resolution.toString())
                                              ]),
                                              Row(children: [
                                                Text(translate('request_qty'), style: styleBody),
                                                SizedBox(width: 15),
                                                Text(e.qtyRequested.toString())
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
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  // Comments
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesome.comments_o),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(translate('comments'), style: styleHead),
                          )
                        ],
                      ),
                      Column(
                        children: model.data.comments
                            .map((e) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                e.isAdmin == '1'
                                                    ? translate('admin')
                                                    : (_auth.currentUser.firstname + ' ' + _auth.currentUser.lastname),
                                                style: styleHead),
                                            SizedBox(width: 5),
                                            Row(
                                              children: [
                                                Text(translate('date'), style: styleBody),
                                                SizedBox(width: 5),
                                                Text(formatDate(e.createdAt.toUtc(), [dd, '/', mm, '/', yyyy]), style: styleBody),
                                              ],
                                            )
                                          ],
                                        ),
                                        Card(
                                          color: Colors.grey[300],
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(e.comment, style: styleBody),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                  color: e.isAdmin == '1' ? Colors.green[100] : Colors.grey[200],
                                ))
                            .toList(),
                      ),
                      Form(
                        key: model.userForm,
                        child: Column(
                          children: [
                            // Message
                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[400])),
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
                                  onTap: () => model.addComment(context),
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
