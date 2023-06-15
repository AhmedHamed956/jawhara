import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/rendering.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/shipping%20address/countries.dart';
import 'package:jawhara/view/ui/account/shipping/my_address.dart';
import 'package:jawhara/view/ui/cart/checkout.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:provider/provider.dart';

import '../../index.dart';
import 'custom_tab_bar.dart';

class ShippingPage extends StatefulWidget {
  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController controller = new ScrollController();
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  Widget _customPopupItemBuilder(BuildContext context, String item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
      ),
    );
  }

  @override
  void initState() {
    locator<ShippingAddressViewModel>().tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text(translate('shop_cart')),
        actions: [
          Visibility(
            visible: !_searching,
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: SearchScreen(),
                    ),
                  );
                }),
          ),
          IconButton(icon: Icon(IcoMoon.barcode), onPressed: null),
          IconButton(
              icon: Icon(
                IcoMoon.notification,
                color: AppColors.secondaryColor,
              ),
              onPressed: null),
        ],
        bottom: ReadOnlyTabBar(
          child: TabBar(
              controller: locator<ShippingAddressViewModel>().tabController,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              onTap: (value) => print(value),
              tabs: [
                Tab(
                  child: Container(
                    child: Text(translate('shipping')),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(translate('payment')),
                    ),
                  ),
                ),
              ]),
        ),
      ),
      body: ViewModelBuilder<ShippingAddressViewModel>.reactive(
        viewModelBuilder: () => locator<ShippingAddressViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) => model.initScreen(context, _auth.currentUser.id, defaultAddress: true),
        builder: (context, model, child) {
          if (model.isBusy) return Center(child: Text(translate('loading')));
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TabBarView(
                controller: locator<ShippingAddressViewModel>().tabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: AppColors.greyColor,
                          ),
                          padding: EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 20),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListTile(
                                // leading: CircleAvatar(
                                //   child: Icon(Icons.home, size: 18, color: Colors.white),
                                //   backgroundColor: AppColors.darkGreyColor,
                                // ),
                                title: model.defaultMyAddress == null
                                    ? Text('empty')
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                translate('country'),
                                                style: styleHead,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                model.defaultMyAddress.countryId ?? '',
                                                style: styleBody,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                translate('city'),
                                                style: styleHead,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                model.defaultMyAddress.city ?? '',
                                                style: styleBody,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                translate('district'),
                                                style: styleHead,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                  model.defaultMyAddress.customAttributes != null
                                                      ? model.defaultMyAddress.customAttributes[0].value
                                                      : '',
                                                  style: styleBody),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                translate('landmark'),
                                                style: styleHead,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                  model.defaultMyAddress.customAttributes != null
                                                      ? model.defaultMyAddress.customAttributes[1].value
                                                      : '',
                                                  style: styleBody),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                translate('postal_code'),
                                                style: styleHead,
                                              ),
                                              SizedBox(width: 5),
                                              Text(model.defaultMyAddress.postcode ?? '', style: styleBody),
                                            ],
                                          ),
                                        ],
                                      ),
                                trailing: Icon(lang == 'ar' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                                onTap: () {
                                  return Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: MyAddress(),
                                    ),
                                  ).then((value) => model.initScreen(context, _auth.currentUser.id, defaultAddress: true));
                                },
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                    child: Text(
                                      translate('shipping_method'),
                                      style: TextStyle(
                                        fontFamily: FontFamily.cairo,
                                        fontSize: 16,
                                        color: AppColors.mainTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              if (model.shippingMethod.isEmpty && model.isShippingMethodLoad == false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    translate('no_shipping_method'),
                                    style: TextStyle(
                                      fontFamily: FontFamily.cairo,
                                      fontSize: 12,
                                      color: AppColors.darkGreyColor,
                                    ),
                                  ),
                                ),
                              Wrap(
                                children: model.shippingMethod
                                    .map(
                                      (e) => CheckboxListTile(
                                        title: Text("${e.carrierTitle}"),
                                        value: e.selected,
                                        onChanged: (newValue) => model.updateShippingMethod(e),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        activeColor: AppColors.primaryColor,
                                        secondary: Text('${e.baseAmount} ${SharedData.currency}'),
                                      ),
                                    )
                                    .toList(),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                    child: Text(
                                      translate('billing_address'),
                                      style: TextStyle(
                                        fontFamily: FontFamily.cairo,
                                        fontSize: 16,
                                        color: AppColors.mainTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              CheckboxListTile(
                                title: Text(translate('copy_shipping_address')),
                                value: model.checkBilling,
                                onChanged: (newValue) => model.updateBillingCheckbox(newValue),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppColors.primaryColor,
                              ),
                              Visibility(
                                visible: !model.checkBilling,
                                child: Form(
                                  key: model.globalKey2,
                                  child: Column(
                                    children: [
                                      // First Name & Last Name
                                      Container(
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: model.billingAddress.firstname,
                                                    keyboardType: TextInputType.name,
                                                    onChanged: (value) => model.updateBillingFirstName(value),
                                                    validator: (String value) => Validators.validateForm(value),
                                                    decoration: InputDecoration(
                                                      hintText: translate('first_name'),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                      hintStyle: TextStyle(fontSize: 14),
                                                      isDense: true,
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                                ),
                                                flex: 1),
                                            SizedBox(width: 5),
                                            Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: TextFormField(
                                                    initialValue: model.billingAddress.lastname,
                                                    keyboardType: TextInputType.name,
                                                    onChanged: (value) => model.updateBillingLastName(value),
                                                    validator: (String value) => Validators.validateForm(value),
                                                    decoration: InputDecoration(
                                                      hintText: translate('last_name'),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                      hintStyle: TextStyle(fontSize: 14),
                                                      isDense: true,
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                                ),
                                                flex: 1),
                                          ],
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                      ),

                                      Container(
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  initialValue: model.billingAddress.telephone,
                                                  keyboardType: TextInputType.phone,
                                                  onChanged: (value) => model.updateBillingPhone(value),
                                                  validator: (String value) => Validators.validatePhone(value),
                                                  decoration: InputDecoration(
                                                    hintText: translate('phone'),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                    hintStyle: TextStyle(fontSize: 14),
                                                    isDense: true,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(vertical: 8),
                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  initialValue: model.billingAddress?.customAttributes != null && model.billingAddress.customAttributes.length >= 3
                                                      ? model.billingAddress?.customAttributes[2].value ?? ""
                                                      : null,
                                                  keyboardType: TextInputType.phone,
                                                  onChanged: (value) => model.updateBillingAltPhone(value),
                                                  validator: (String value) => Validators.validatePhone(value),
                                                  decoration: InputDecoration(
                                                    hintText: translate('another_phone'),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                    hintStyle: TextStyle(fontSize: 14),
                                                    isDense: true,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(vertical: 8),
                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          initialValue: model.billingAddress.postcode,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => model.updateBillingPostalCode(value),
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                            hintText: translate('postal_code'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hintStyle: TextStyle(fontSize: 14),
                                            isDense: true,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.only(right: 10, left: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: DropdownButtonFormField<CountriesModel>(
                                                  hint: Text(model.countries.isNotEmpty
                                                      ? model.countries[0].fullNameLocale
                                                      : translate('country')),
                                                  onChanged: (value) => model.updateBillingCountry(value),
                                                  isDense: true,
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  items: model.countries.map<DropdownMenuItem<CountriesModel>>((CountriesModel value) {
                                                    return DropdownMenuItem<CountriesModel>(
                                                      value: value,
                                                      child: Text(value.fullNameLocale.toString()),
                                                    );
                                                  }).toList(),
                                                ),
                                                flex: 13,
                                              )
                                            ],
                                          ),
                                          margin: EdgeInsets.only(bottom: 10),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      SizedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.only(right: 10, left: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: DropdownSearch<String>(
                                                  mode: Mode.BOTTOM_SHEET,
                                                  maxHeight: 300,
                                                  items: model.cities,
                                                  onChanged: print,
                                                  hint: translate('city'),
                                                  selectedItem: model.defaultMyAddress.city,
                                                  dropdownSearchDecoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  showSearchBox: true,
                                                  label:  "Search for city",
                                                  // searchBoxDecoration: InputDecoration(
                                                  //   border: OutlineInputBorder(),
                                                  //   contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                                                  //   labelText: "Search for city",
                                                  // ),
                                                  onSaved: (newValue) => model.updateCityName(newValue),
                                                  popupTitle: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.fourthColor,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        translate('city'),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  popupShape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),
                                                    ),
                                                  ),
                                                  popupItemBuilder: _customPopupItemBuilder,
                                                ),
                                                flex: 13,
                                              )
                                            ],
                                          ),
                                          margin: EdgeInsets.only(bottom: 10),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          initialValue: model.billingAddress?.customAttributes != null
                                              ? model.billingAddress?.customAttributes[0]?.value ?? ""
                                              : null,
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) => model.updateBillingDistrict(value),
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                            hintText: translate('district'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hintStyle: TextStyle(fontSize: 14),
                                            isDense: true,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          initialValue: model.billingAddress?.street != null ? model.billingAddress?.street[0] ?? "" : null,
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) => model.updateBillingStreet(value),
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                            hintText: translate('street'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hintStyle: TextStyle(fontSize: 14),
                                            isDense: true,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          initialValue: model.billingAddress.customAttributes != null
                                              ? model.billingAddress?.customAttributes[1]?.value ?? ""
                                              : null,
                                          onChanged: (value) => model.updateBillingLandMark(value),
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                            hintText: translate('landmark'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            hintStyle: TextStyle(fontSize: 14),
                                            isDense: true,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Confirm
                              Center(
                                child: GestureDetector(
                                  onTap: () => model.submitShipping(context),
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
                                      model.isBusy? translate('loading') : translate('confirm'),
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
                          )),
                    ],
                  ),
                  CheckOut()
                ],
              ));
        },
      ),
    );
  }
}
