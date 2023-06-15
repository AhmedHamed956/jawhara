import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/view/widgets/credit_card/credit_card_form.dart';
import 'package:jawhara/view/widgets/product_list.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';

import '../../index.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.width / 2;
    final shipping = locator<ShippingAddressViewModel>();
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => locator<CartViewModel>(),
      disposeViewModel: false,
      createNewModelOnInsert: true,
      onModelReady: (model) => model.initPaymentMethod(context),
      builder: (context, model, child) {
        if (model.isBusy) return Center(child: Text(translate('loading')));
        // print(':508'.split(":")[0].toString());
        // print(int.parse(("000000256".split(":")[0].toString())));
        // model.paymentMethod.paymentMethods.forEach((element) {
        // print('paymentMethod > ${element.toJson()}');
        // });
        return ListView(
          children: [
            // Address
            if (shipping.defaultMyAddress != null && shipping.defaultMyAddress.firstname != null)
              Container(
                  child: ExpandablePanel(
                    header: Text(
                      translate('shipping_address'),
                    ),
                    theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                    expanded: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(shipping.defaultMyAddress.firstname + ' ' + shipping.defaultMyAddress.lastname),
                            Text(shipping.defaultMyAddress.city),
                            Text(shipping.defaultMyAddress.street[0]),
                            Text(shipping.defaultMyAddress.customAttributes[0].value),
                            Text(shipping.defaultMyAddress.customAttributes[1].value),
                            Text(shipping.defaultMyAddress.telephone),
                            Text(shipping.defaultMyAddress.postcode ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                  margin: EdgeInsets.symmetric(horizontal: 15)),
            // Billing address
            if (shipping.billingAddress != null && shipping.billingAddress.firstname != null)
              Container(
                  child: ExpandablePanel(
                    header: Text(
                      translate('billing_address'),
                    ),
                    theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                    expanded: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(shipping.billingAddress.firstname + ' ' + shipping.billingAddress.lastname),
                            Text(shipping.billingAddress.lastname),
                            Text(shipping.billingAddress.city),
                            Text(shipping.billingAddress.street[0]),
                            Text(shipping.billingAddress.customAttributes[0].value),
                            Text(shipping.billingAddress.customAttributes[1].value),
                            Text(shipping.billingAddress.telephone),
                            Text(shipping.billingAddress.postcode ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                  margin: EdgeInsets.symmetric(horizontal: 15)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('shop_cart'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(model.cart.items.length.toString() + ' ' + translate('products')),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                // color: AppColors.greyColor,
              ),
            ),
            Container(
              height: 180,
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.2,
                children: model.cart.items
                    .map(
                      (e) => Container(
                        height: kHeight,
                        width: kHeight,
                        child: ProductListScreen(
                          direction: Axis.horizontal,
                          item: e,
                        ),
                      ),
                    )
                    .toList(),
                scrollDirection: Axis.horizontal,
              ),
            ),
            // Column(
            //     children: model.cart.items
            //         .map((e) => Container(
            //       height: 120,
            //       child:      ProductListScreen(
            //         direction: Axis.horizontal,
            //         item: e,
            //       ),
            //     ))
            //         .toList()),
            if (model.currentWalletBalance != null && model.currentWalletBalance > 0)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: model.payWithWallet,
                        onChanged: (value) {
                          model.payWithWalletCheckboxChanged(value);
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${translate('payWithWallet')}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (${model.currentWalletBalance} ${translate("SAR")})",
                      style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#24ED22")),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  // color: AppColors.greyColor,
                ),
              ),
            if (model.payWithWallet)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFCCCCCC),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 30,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(translate("paymentToBeMade")),
                              Text("${model.paymentMethod.totals.baseGrandTotal} ${SharedData.currency}")
                            ],
                          ),
                          Container(height: 20, width: 20, child: Image.asset("assets/icons/minus.png")),
                          Column(
                            children: [Text(translate("amountInYourWallet")), Text("${model.currentWalletBalance} ${SharedData.currency}")],
                          ),
                          Container(height: 20, width: 20, child: Image.asset("assets/icons/equal.png")),
                          Column(
                            children: [
                              Text(translate("leftAmountToBePaid")),
                              Text(
                                  "${model.currentWalletBalance > model.paymentMethod.totals.baseGrandTotal ? "0.0" : (model.paymentMethod.totals.baseGrandTotal - model.currentWalletBalance).toStringAsFixed(2)} ${SharedData.currency}")
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${translate("remainingInWallet")}: ${model.currentWalletBalance > model.paymentMethod.totals.baseGrandTotal ? (model.currentWalletBalance - model.paymentMethod.totals.baseGrandTotal).toStringAsFixed(2) : "0.0"} ${SharedData.currency}",
                      style: TextStyle(color: HexColor("#298CCF")),
                    )
                  ],
                ),
              ),
            if (model.payWithWallet &&
                ((model.currentWalletBalance > model.paymentMethod.totals.baseGrandTotal
                        ? 0
                        : (model.paymentMethod.totals.baseGrandTotal - model.currentWalletBalance)) >
                    0))
              Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  "**${translate("selectPaymentMethodToPayTheRest")}",
                  style: TextStyle(fontSize: 12, color: Colors.redAccent, fontStyle: FontStyle.italic),
                ),
              ),
            if (!model.payWithWallet || (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance))
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      translate('payment_method'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  // color: AppColors.greyColor,
                ),
              ),
            model.isMethodLoad
                ? Center(child: ShapeLoading())
                : (!model.payWithWallet || (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance))
                    ? Wrap(
                        children: (model.paymentMethod?.paymentMethods ?? []).map(
                          (e) {
                            // print('e > ${e.toJson()}');
                            if (e.code.contains('aps_fort_cc')) {
                              return CheckboxListTile(
                                title: Align(
                                  child: SizedBox(
                                    child: Image.network('https://jawhara.online/media/wysiwyg/jawhara/visa2.png'),
                                    height: 30,
                                    width: 100,
                                  ),
                                  alignment: SharedData.lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                ),
                                value: e.selected,
                                onChanged: (newValue) => model.changeSelectedMethod(context, e),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.primaryColor,
                              );
                            }
                            if (e.code.contains('cashondelivery')) {
                              return CheckboxListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate('cod')),
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        '(${translate('codWillAddOnTotal')})',
                                        style: TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                                value: e.selected,
                                onChanged: (newValue) => model.changeSelectedMethod(context, e),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.primaryColor,
                              );
                            }
                            if (e.code.contains('aps_apple')) {
                              return CheckboxListTile(
                                title: Align(
                                  child: SizedBox(child: Icon(Fontisto.apple_pay, color: Colors.grey)),
                                  alignment: SharedData.lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                ),
                                value: e.selected,
                                // onChanged: (newValue) => model.changeSelectedMethod(context, e),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.primaryColor,
                              );
                            }
                            return Container();
                          },
                        ).toList(),
                      )
                    : Container(),
            Visibility(
                visible: model.selectedMethod != null &&
                    model.selectedMethod?.code != 'cashondelivery' &&
                    (!model.payWithWallet ||
                        (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance)),
                child: model.cardPayments.data == null
                    ? Container()
                    : Wrap(
                        children: model.cardPayments.data
                            .map((e) => CheckboxListTile(
                                  title: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 25,
                                      width: 20,
                                      child: Image.network(e.type == 'Mada'
                                          ? 'https://www.alahli.com/en-us/about-us/csr/PublishingImages/mada-logo-474-Px.png'
                                          : e.type == 'Master'
                                              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1000px-Mastercard-logo.svg.png'
                                              : e.type == 'VISA'
                                                  ? 'https://icons.iconarchive.com/icons/designbolts/credit-card-payment/256/Visa-icon.png'
                                                  : 'https://icon-library.com/images/online-payment-icon/online-payment-icon-13.jpg')),
                                  subtitle: Text(
                                    '${translate('ending')} ${e.maskedCc} ( ${translate('expires')}: ${e.expirationDate} )',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  secondary: SizedBox(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1.0),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey[200])),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        maxLines: 1,
                                        readOnly: !e.check,
                                        enabled: e.check,
                                        onChanged: (value) {
                                          model.cvvCode = value;
                                        },
                                        // validator: (String value) => Validators.validateName(value),
                                        decoration: InputDecoration(hintText: translate('cvv')),
                                      ),
                                    ),
                                    width: 50,
                                  ),
                                  value: e.check,
                                  onChanged: (value) {
                                    setState(() {
                                      e.check = value;
                                      model.addNewCard = false;
                                      model.useSavedCard = true;
                                      model.cvvCode = '';
                                      model.cardPayments.data.forEach((element) {
                                        if (e.publicHash != element.publicHash) {
                                          element.check = false;
                                        }
                                      });
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                ))
                            .toList(),
                      )),
            Visibility(
                visible: model.selectedMethod != null &&
                    model.selectedMethod?.code != 'cashondelivery' &&
                    (!model.payWithWallet ||
                        (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance)),
                child: CheckboxListTile(
                  title: Text(translate('add_new_card')),
                  value: model.addNewCard,
                  onChanged: (value) {
                    setState(() {
                      model.addNewCard = value;
                      model.rememberMe = false;
                      model.useSavedCard = false;
                      print('useSavedCard > ${model.useSavedCard}');
                      if (model.cardPayments.data != null) {
                        model.cardPayments.data.forEach((element) {
                          element.check = false;
                        });
                      }
                    });
                  },
                  activeColor: AppColors.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            Visibility(
              visible: model.addNewCard &&
                  model.selectedMethod != null &&
                  model.selectedMethod?.code != 'cashondelivery' &&
                  (!model.payWithWallet || (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance)),
              child: CreditCardForm(
                onCreditCardModelChange: model.onCreditCardModelChange,
                cardNumber: translate('card_number'),
                cardHolderName: translate('card_holder'),
                expiryDate: translate('expired_date'),
              ),
            ),
            // Todo staging
            Visibility(
                visible: model.addNewCard &&
                    model.selectedMethod != null &&
                    model.selectedMethod?.code != 'cashondelivery' &&
                    (!model.payWithWallet ||
                        (model.payWithWallet && model.paymentMethod.totals.baseGrandTotal > model.currentWalletBalance)),
                child: CheckboxListTile(
                  title: Text(translate('save_my_card')),
                  value: model.rememberMe,
                  onChanged: (value) {
                    setState(() {
                      model.rememberMe = value;
                      print('useSavedCard > ${model.useSavedCard}');
                    });
                  },
                  activeColor: AppColors.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                )),

            // if (model.currentPoints != null &&
            //     model.currentPoints.reward != null &&
            //     model.currentPoints.reward.pointsBalance != null &&
            //     double.parse(model.currentPoints.reward.pointsBalance.toString()) > 0)
            //   Container(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Checkbox(
            //             value: model.usePoints,
            //             onChanged: (value) {
            //               model.usePointsCheckboxChanged(value);
            //             }),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "${translate('useRewardPoints')}",
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               Align(
            //                 alignment: AlignmentDirectional.centerEnd,
            //                 child: Text(
            //                   "(${model.currentPoints.reward.pointsBalance.toString()} ${translate('reward')} ${translate('points')} (${double.parse(model.currentPoints.reward.currencyBalance.toString()).toDouble()} ${SharedData.currency}))",
            //                   style: TextStyle(fontWeight: FontWeight.bold, color: HexColor("#24ED22"), fontSize: 12),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     width: MediaQuery.of(context).size.width,
            //     margin: EdgeInsets.all(10),
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(4)),
            //       // color: AppColors.greyColor,
            //     ),
            //   ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: AppColors.bgColor,
                ),
                padding: EdgeInsets.only(right: 10, left: 10, top: 10),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.0),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[200])),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                // initialValue: model.data.email,
                                // onChanged: (value) => model.data.lastName = value,
                                // validator: (String value) => Validators.validateName(value),
                                decoration: InputDecoration(
                                    hintText: translate('enter_coupon'), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                controller: model.textEditingController,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                          ),
                          flex: 4,
                        ),
                        Expanded(
                            child: model.isCouponLoad
                                ? Center(child: ShapeLoading())
                                : model.paymentMethod.totals.couponCode == null
                                    ? GestureDetector(
                                        onTap: () => model.addCoupon(context),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          // padding: EdgeInsets.symmetric(
                                          //   horizontal: 25,
                                          // ),
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          alignment: Alignment.center,
                                          child: Text(
                                            translate('confirm'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => model.deleteCoupon(context),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          // padding: EdgeInsets.symmetric(
                                          //   horizontal: 25,
                                          // ),
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          alignment: Alignment.center,
                                          child: Text(
                                            translate('remove'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.redAccent,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                            flex: 1)
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.0),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[200])),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: translate('enter_gift_card'), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                controller: model.textEditingGiftController,
                                readOnly: model.giftCardSegment.code != null,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                          ),
                          flex: 4,
                        ),
                        Expanded(
                            child: model.isGiftLoad
                                ? Center(child: ShapeLoading())
                                : model.giftCardSegment.code == null
                                    ? GestureDetector(
                                        onTap: () => model.addGiftCard(context),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          // padding: EdgeInsets.symmetric(
                                          //   horizontal: 25,
                                          // ),
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          alignment: Alignment.center,
                                          child: Text(
                                            translate('confirm'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => model.deleteGiftCard(context),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          // padding: EdgeInsets.symmetric(
                                          //   horizontal: 25,
                                          // ),
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1.0),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey[200])),
                                          alignment: Alignment.center,
                                          child: Text(
                                            translate('remove'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.redAccent,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                            flex: 1)
                      ],
                    ),
                    ListTile(
                      title: Text(translate('products')),
                      trailing: Text('${model.cart.items.length ?? 0}'),
                      dense: true,
                    ),
                    ListTile(
                      title: Text(translate('sub_total')),
                      trailing: Text('${model.paymentMethod.totals.subtotalInclTax} ' + SharedData.currency),
                      dense: true,
                    ),
                    ListTile(
                      title: Text(translate('ship_cost')),
                      trailing: Text('${model.paymentMethod.totals.shippingInclTax} ' + SharedData.currency),
                      dense: true,
                    ),
                    if (model.selectedMethod != null && model.selectedMethod?.code == 'cashondelivery')
                      ListTile(
                        title: Text(translate('codCost')),
                        trailing: Text('18 ' + SharedData.currency),
                        dense: true,
                      ),
                    ListTile(
                      title: Text(translate('tax')),
                      trailing: Text(
                          '${((model.checkout?.taxAmount ?? 0) + (model.selectedMethod != null && model.selectedMethod?.code == 'cashondelivery' ? 2.35 : 0)).toStringAsFixed(2)} ' +
                              SharedData.currency),
                      dense: true,
                    ),
                    ListTile(
                      title: Text(translate('discount')),
                      trailing: Text('${model.checkout.baseDiscountAmount} ' + SharedData.currency),
                      dense: true,
                    ),
                    // ListTile(
                    //   title:
                    //       Text(translate('reward') + ' ' + translate('points')),
                    //   trailing: Text(
                    //       '${model.checkout.totalSegments == null ? '' : model.checkout.totalSegments.firstWhere((element) => element.code == 'reward', orElse: () => null)?.value ?? ""} ' +
                    //           SharedData.currency),
                    //   dense: true,
                    // ),
                    ListTile(
                      title: Text(translate('gift')),
                      trailing: Text('${model.giftCardSegment.value ?? '0'} ' + SharedData.currency),
                      dense: true,
                    ),
                    ListTile(
                      title: Text(
                        translate('total'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                          '${model.paymentMethod.totals.baseGrandTotal + (model.selectedMethod != null && model.selectedMethod?.code == 'cashondelivery' ? 18 : 0)} ' +
                              SharedData.currency,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      dense: true,
                    ),
                    if (model.payWithWallet)
                      ListTile(
                        title: Text(
                          translate('leftToPayAfterUsingWallet'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                            '${model.currentWalletBalance > model.paymentMethod.totals.baseGrandTotal ? "0.0" : (model.paymentMethod.totals.baseGrandTotal - model.currentWalletBalance).toStringAsFixed(2)} ${SharedData.currency}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        dense: true,
                      ),
                  ],
                )),
            // ViewModelBuilder<PointsViewModel>.reactive(
            //   viewModelBuilder: () => PointsViewModel(),
            //   disposeViewModel: false,
            //   onModelReady: (model) {
            //     model.getAlert(context);
            //     model.checkAvailablePoint(context);
            //   },
            //   builder: (context, model, child) {
            //     if (model.isBusy)
            //       return Center(child: Text(translate('loading')));
            //     return Visibility(
            //       visible: model.alertData != null,
            //       child: Wrap(
            //         children: [
            //           Container(
            //             child: Text(
            //               translate('check_earn') +
            //                   ' ${model.alertData?.itemRewardPoints ?? ""} ' +
            //                   translate('reward') +
            //                   ' ' +
            //                   translate('points') +
            //                   ' (${model.alertData?.itemRewardAmount ?? ""}) ' +
            //                   translate('for_order') +
            //                   '\n' +
            //                   translate('your_balance') +
            //                   ' ${model.alertData?.totalPointsBalance ?? ""} ' +
            //                   translate('reward') +
            //                   ' ' +
            //                   translate('points'),
            //               style: TextStyle(
            //                   color: AppColors.primaryColor, fontSize: 12),
            //             ),
            //             width: MediaQuery.of(context).size.width,
            //             margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            //             padding: EdgeInsets.all(10),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.all(Radius.circular(4)),
            //               color: AppColors.yellowColor.withOpacity(0.6),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               translate('check_earn') +
            //                   ' ${model.alertData?.ruleRewardPoints ?? ""} ' +
            //                   translate('reward') +
            //                   ' ' +
            //                   translate('points') +
            //                   ' (${model.alertData?.ruleRewardAmount ?? ""}) ' +
            //                   translate('for_order') +
            //                   '\n' +
            //                   translate('your_balance') +
            //                   ' ${model.alertData?.totalPointsBalance ?? ""} ' +
            //                   translate('reward') +
            //                   ' ' +
            //                   translate('points'),
            //               style: TextStyle(
            //                   color: AppColors.primaryColor, fontSize: 12),
            //             ),
            //             width: MediaQuery.of(context).size.width,
            //             margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            //             padding: EdgeInsets.all(10),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.all(Radius.circular(4)),
            //               color: AppColors.yellowColor.withOpacity(0.6),
            //             ),
            //           ),
            //           Visibility(
            //             visible: model.checkPoint.response,
            //             child: GestureDetector(
            //               onTap: () => model.useReward(context),
            //               child: Container(
            //                 margin: EdgeInsets.symmetric(
            //                     horizontal: 15, vertical: 10),
            //                 padding: EdgeInsets.symmetric(
            //                   horizontal: 25,
            //                 ),
            //                 height: 35.0,
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(0.0),
            //                   color: AppColors.greenColor,
            //                 ),
            //                 alignment: Alignment.center,
            //                 child: Text(
            //                   '(${model.alertData?.totalPointsBalance?.toString() ?? "0"})' +
            //                       ' ' +
            //                       translate('reward') +
            //                       ' ' +
            //                       translate('points'),
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.white,
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //                 width: MediaQuery.of(context).size.width / 2,
            //               ),
            //             ),
            //             replacement: GestureDetector(
            //               onTap: () => model.removeReward(context),
            //               child: Container(
            //                 margin: EdgeInsets.symmetric(
            //                     horizontal: 15, vertical: 10),
            //                 padding: EdgeInsets.symmetric(
            //                   horizontal: 25,
            //                 ),
            //                 height: 35.0,
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(0.0),
            //                   color: AppColors.redColor,
            //                 ),
            //                 alignment: Alignment.center,
            //                 child: Text(
            //                   translate('remove') +
            //                       ' ' +
            //                       translate('reward') +
            //                       ' ' +
            //                       translate('points'),
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: Colors.white,
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //                 width: MediaQuery.of(context).size.width / 2,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            CheckboxListTile(
              title: Text(
                translate('accept_terms'),
                style: TextStyle(fontSize: 12),
              ),
              value: true,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primaryColor,
            ),
            Center(
              child: GestureDetector(
                onTap: () => model.placeOrder(context),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: AppColors.mainTextColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    translate('confirm'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
