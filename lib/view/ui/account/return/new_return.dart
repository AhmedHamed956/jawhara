import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/model/return/reasons.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/return_order_view_model.dart';
import 'package:provider/provider.dart';
import '../../../index.dart';

class NewReturn extends StatelessWidget {
  MyOrdersItem item;

  NewReturn(this.item);

  TextStyle styleHead = TextStyle(
      color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle styleBody = TextStyle(
      color: AppColors.secondaryColor,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    print(item.toJson());
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
          onModelReady: (model) {
            model.initScreen(context, item.incrementId);
            model.initReasonsData(context);
          },
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
                            child: Text(translate('shipping_address'),
                                style: styleHead),
                          )
                        ],
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.billingAddress.street[0]),
                            Text(item.billingAddress.countryId +
                                ", " +
                                item.billingAddress.city),
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
                            child: Text(translate('personal_info'),
                                style: styleHead),
                          )
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(children: [
                              Text(translate('order_id'), style: styleBody),
                              SizedBox(width: 15),
                              Text(item.incrementId.toString())
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text(translate('user_name'), style: styleBody),
                              SizedBox(width: 15),
                              Text(item.billingAddress.firstname +
                                  ' ' +
                                  item.billingAddress.lastname)
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

                  if (model.items != null && model.items.isNotEmpty)
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
                              child: Text(translate('return_orders_history'),
                                  style: styleHead),
                            )
                          ],
                        ),
                        ...model.items.map((e) => Container(
                          child: Column(
                            children: [
                              Row(children: [
                                Text(translate('return_id'), style: styleBody),
                                SizedBox(width: 15),
                                Text(e.incrementId.toString())
                              ]),
                              SizedBox(height: 5),
                              Row(children: [
                                Text(translate('shipFrom'), style: styleBody),
                                SizedBox(width: 15),
                                Text(e.customerName)
                              ]),
                              SizedBox(height: 5),
                              Row(children: [
                                Text(translate('date'), style: styleBody),
                                SizedBox(width: 15),
                                Text(DateFormat("dd/MM/yyyy", "en").format(e.dateRequested))
                              ]),
                              SizedBox(height: 5),
                              Row(children: [
                                Text(translate('returnStatus'),
                                    style: styleBody),
                                SizedBox(width: 15),
                                Text(e.status)
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
                        )).toList(),
                      ],
                    ),

                  // if (model.items == null || model.items.isEmpty)
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
                              child: Text(translate('return_orders_details'),
                                  style: styleHead),
                            )
                          ],
                        ),
                        Form(
                          key: model.userForm,
                          child: Column(
                            children: [
                              // product
                              SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  margin: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:
                                            DropdownButtonFormField<ItemItem>(
                                          hint: Text(translate('product_name')),
                                          onChanged: (value) =>
                                              model.updateProductReturn(
                                                  value.itemId.toString()),
                                          isDense: true,
                                          validator: (value) =>
                                              Validators.validateForm(
                                                  value.name),
                                          items: item.items
                                              .map<DropdownMenuItem<ItemItem>>(
                                                  (ItemItem value) {
                                            return DropdownMenuItem<ItemItem>(
                                              value: value,
                                              child: SizedBox(
                                                  width: 250,
                                                  child: Text(value.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true)),
                                            );
                                          }).toList(),
                                        ),
                                        flex: 13,
                                      )
                                    ],
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              // resolution
                              SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  margin: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<Option>(
                                          hint: Text(translate('resolution')),
                                          onChanged: (value) =>
                                              model.updateReason(
                                                  value.value.toString()),
                                          isDense: true,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (Option value) =>
                                              Validators.validateForm(
                                                  value.label),
                                          items: model.reasons.options
                                              .map<DropdownMenuItem<Option>>(
                                                  (Option value) {
                                            return DropdownMenuItem<Option>(
                                              value: value,
                                              child:
                                                  Text(translate(value.label)),
                                            );
                                          }).toList(),
                                        ),
                                        flex: 13,
                                      )
                                    ],
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              // condition
                              SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  margin: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<Option>(
                                          hint: Text(translate('condition')),
                                          onChanged: (value) =>
                                              model.updateCondition(
                                                  value.value.toString()),
                                          isDense: true,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (Option value) =>
                                              Validators.validateForm(
                                                  value.label),
                                          items: model.condition.options
                                              .map<DropdownMenuItem<Option>>(
                                                  (Option value) {
                                            return DropdownMenuItem<Option>(
                                              value: value,
                                              child:
                                                  Text(translate(value.label)),
                                            );
                                          }).toList(),
                                        ),
                                        flex: 13,
                                      )
                                    ],
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              // reason
                              SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10),
                                  margin: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<Option>(
                                          hint: Text(translate('resolution')),
                                          onChanged: (value) =>
                                              model.updateResolution(
                                                  value.value.toString()),
                                          isDense: true,
                                          isExpanded: true,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (Option value) =>
                                              Validators.validateForm(
                                                  value.label),
                                          items: model.resolution.options
                                              .map<DropdownMenuItem<Option>>(
                                                  (Option value) {
                                            return DropdownMenuItem<Option>(
                                              value: value,
                                              child: Text(
                                                translate(value.label),
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
                                      border:
                                          Border.all(color: Colors.grey[400])),
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    // initialValue: model.data.email,
                                    controller: model.commentText,
                                    onChanged: (value) =>
                                        model.updateComment(value),
                                    validator: (String value) =>
                                        Validators.validateForm(value),
                                    decoration: InputDecoration(
                                        hintText: translate('message'),
                                        hintStyle: TextStyle(fontSize: 12),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10)),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),

                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        model.submitReturn(context, item),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.0),
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
