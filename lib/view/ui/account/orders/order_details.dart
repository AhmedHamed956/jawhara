import 'dart:convert';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/orders/my_orders.dart';
import 'package:jawhara/view/ui/account/orders/my_orders.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/contact_us_view_model.dart';
import 'package:jawhara/viewModel/orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../index.dart';

class OrderDetails extends StatefulWidget {
  MyOrdersItem data;
  OrdersViewModel model;
  final index;

  OrderDetails(this.data, this.index, this.model);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 14);

  TextStyle styleTitle = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 13);

  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 13);

  Map<String, dynamic> statusColors = {"pending": AppColors.yellowColor, "processing": Colors.blue, "complete": Colors.green};

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    final _address = widget.data.extensionAttributes.shippingAssignments.first.shipping.address;
    final _billing = widget.data.billingAddress;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('order') + " #" + widget.data.incrementId.toString()),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        padding: EdgeInsets.only(right: 10, left: 10, top: 30),
        margin: EdgeInsets.all(10),
        child: ViewModelBuilder<OrdersViewModel>.reactive(
          viewModelBuilder: () => widget.model,
          disposeViewModel: false,
          onModelReady: (model) {
            if (widget.data.status == "complete")
              return model.getTrack(context, widget.data.items.first.orderId);
          },
          builder: (context, m, child) {
            var method;
            if (widget.data.payment.method == 'aps_fort_cc' ||
                widget.data.payment.method == 'HyperPay_Mada' ||
                widget.data.payment.method == 'HyperPay_Master' ||
                widget.data.payment.method == 'HyperPay_Visa') {
              method = 'mada_bank_credit';
            } else if (widget.data.payment.method == 'cashondelivery') {
              method = 'cod';
            } else if (widget.data.payment.method == 'aps_fort_vault') {
              method = 'APS Payment Method';
            } else {
              method = widget.data.payment.method;
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(backgroundColor: statusColors[widget.data.status] ?? Colors.grey, maxRadius: 7),
                              SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(translate(widget.data.status), style: styleHead),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(DateFormat('MMM d, yyyy hh:mm:ss a', "en").format(widget.data.updatedAt),
                                  style: styleHead.copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      buttonCancelAndReorder(
                          context: context, item: widget.data, index: widget.index, model: widget.model, isFromDetailOrder: true),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('items_ordered')),
                          Wrap(
                            children: widget.data.items
                                .map((e) => Column(
                                      children: [
                                        Divider(color: Colors.grey),
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(translate('product_name') + ':', style: styleTitle),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                      width: MediaQuery.of(context).size.width / 1.25,
                                                      child: Text(e.name, style: styleBody)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(flex: 0, child: Text(translate('SKU') + ':', style: styleTitle)),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(e.sku, style: styleBody),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(flex: 0, child: Text(translate('price') + ':', style: styleTitle)),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(e.basePriceInclTax + " ${SharedData.currency}", style: styleBody),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(flex: 0, child: Text(translate('QTY') + ':', style: styleTitle)),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(e.qtyOrdered.toString(), style: styleBody),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(flex: 0, child: Text(translate('sub_total') + ':', style: styleTitle)),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child:
                                                      Text(e.baseRowTotalInclTax.toString() + " ${SharedData.currency}", style: styleBody),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                          Divider(color: Colors.grey),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text(translate('sub_total'), style: styleTitle)),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child:
                                          Text(widget.data.baseSubtotalInclTax.toString() + " ${SharedData.currency}", style: styleBody))),
                            ],
                          ),
                          Visibility(
                            visible: widget.data.extensionAttributes.baseCashOnDeliveryFee != '0',
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text(translate('codCost'), style: styleTitle)),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            widget.data.extensionAttributes.baseCashOnDeliveryFee.toString() + " ${SharedData.currency}",
                                            style: styleBody))),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text(translate('shipping'), style: styleTitle)),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(widget.data.shippingInclTax.toString() + " ${SharedData.currency}", style: styleBody))),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text(translate('tax'), style: styleTitle)),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(widget.data.taxAmount.toString() + " ${SharedData.currency}", style: styleBody))),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text(translate('estimated_total'), style: styleTitle)),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(widget.data.grandTotal.toString() + " ${SharedData.currency}", style: styleBody))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(translate('order_information'), style: styleHead),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('shipping_address')),
                          Divider(color: Colors.grey),
                          Text((_address.firstname + " " + _address.lastname) ?? '', style: styleBody),
                          Text(_address.street[0] ?? '', style: styleBody),
                          Text(_address.city ?? '', style: styleBody),
                          Text(_address.region ?? '', style: styleBody),
                          Text("T: " + _address.telephone, style: styleBody),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('shipping_method')),
                          Divider(color: Colors.grey),
                          Text(widget.data.shippingDescription, style: styleBody),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('billing_address')),
                          Divider(color: Colors.grey),
                          Text((_billing.firstname + " " + _billing.lastname) ?? '', style: styleBody),
                          Text(_billing.street[0] ?? '', style: styleBody),
                          Text(_billing.city ?? '', style: styleBody),
                          Text(_billing.region ?? '', style: styleBody),
                          Text("T: " + _billing.telephone, style: styleBody),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate('payment_method')),
                          Divider(color: Colors.grey),
                          Text(translate(method), style: styleBody),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  m.isBusy
                      ? ShapeLoading()
                      : Visibility(
                          visible: m.track.trackUrl != null,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(translate('order_tracking'), style: styleHead),
                                  ),
                                ],
                              ),
                              SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[400])),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('tracking_information')),
                                      Divider(color: Colors.grey),
                                      Row(
                                        children: [
                                          Expanded(flex: 0, child: Text(translate('track_number'), style: styleTitle)),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(m.track.trackNumber.toString(), style: styleBody))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(flex: 0, child: Text(translate('track_title'), style: styleTitle)),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(m.track.title.toString(), style: styleBody))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(flex: 0, child: Text(translate('track_url'), style: styleTitle)),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: TextButton(
                                                    child: Text(m.track.trackUrl.toString(), style: styleTitle),
                                                    onPressed: () async {
                                                      await launch(m.track.trackUrl.toString());
                                                    },
                                                  ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                          replacement: Container(),
                        ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
