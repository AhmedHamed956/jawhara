import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/shipping%20address/city_model.dart';
import 'package:jawhara/model/shipping%20address/countries.dart';
import 'package:jawhara/model/shipping%20address/state_model.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

// ignore: must_be_immutable
class ShippingAddress extends StatelessWidget {
  TextStyle styleHead = TextStyle(
      color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody =
      TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  Widget _customPopupItemBuilder(
      BuildContext context, String item, bool isSelected) {
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
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(translate('shipping_address')),
        ),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: AppColors.greyColor,
              ),
              padding:
                  EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 20),
              // margin: EdgeInsets.all(10),
              child: ViewModelBuilder<ShippingAddressViewModel>.reactive(
                viewModelBuilder: () => ShippingAddressViewModel(),
                disposeViewModel: false,
                onModelReady: (model) => model.getCountries(context),
                builder: (context, model, child) {
                  return Form(
                    key: model.globalKey,
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
                                      keyboardType: TextInputType.name,
                                      onChanged: (value) =>
                                          model.updateFirstName(value),
                                      validator: (String value) =>
                                          Validators.validateForm(value),
                                      decoration: InputDecoration(
                                        hintText: translate('first_name'),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        hintStyle: TextStyle(fontSize: 14),
                                        isDense: true,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
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
                                      keyboardType: TextInputType.name,
                                      onChanged: (value) =>
                                          model.updateLastName(value),
                                      validator: (String value) =>
                                          Validators.validateForm(value),
                                      decoration: InputDecoration(
                                        hintText: translate('last_name'),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        hintStyle: TextStyle(fontSize: 14),
                                        isDense: true,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
                                  ),
                                  flex: 1),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
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
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) =>
                                        model.updatePhone(value),
                                    validator: (String value) =>
                                        Validators.validatePhone(value),
                                    decoration: InputDecoration(
                                      hintText: translate('phone'),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      hintStyle: TextStyle(fontSize: 14),
                                      isDense: true,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 5),
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
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) =>
                                        model.updateAltPhone(value),
                                    validator: (String value) =>
                                        Validators.validatePhone(value,optional: true),
                                    decoration: InputDecoration(
                                      hintText: translate('another_phone'),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      hintStyle: TextStyle(fontSize: 14),
                                      isDense: true,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     color: Colors.white,
                        //   ),
                        //   child: TextFormField(
                        //     keyboardType: TextInputType.emailAddress,
                        //     onChanged: (value) => model.updateEmail(value),
                        //     validator: (String value) => Validators.validateEmail(value),
                        //     decoration: InputDecoration(
                        //       hintText: translate('email'),
                        //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        //       hintStyle: TextStyle(fontSize: 14),
                        //       isDense: true,
                        //     ),
                        //   ),
                        //   alignment: Alignment.center,
                        //   margin: EdgeInsets.symmetric(vertical: 8),
                        //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => model.updateEmail(value),
                            validator: (String value) =>
                                Validators.validateForm(value),
                            decoration: InputDecoration(
                              hintText: translate('email'),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(fontSize: 14),
                              isDense: true,
                            ),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) => model.updatePostalCode(value),
                            // validator: (String value) =>
                            //     Validators.validateForm(value),
                            decoration: InputDecoration(
                              hintText: translate('postal_code'),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(fontSize: 14),
                              isDense: true,
                            ),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
                                  child:
                                      DropdownButtonFormField<CountriesModel>(
                                    hint: Text(translate('country')),
                                    onChanged: (value) =>
                                        model.updateCountry(value),
                                    isDense: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    // validator: (CountriesModel value) => Validators.validateForm(value.id),
                                    items: model.countries
                                        .map<DropdownMenuItem<CountriesModel>>(
                                            (CountriesModel value) {
                                      return DropdownMenuItem<CountriesModel>(
                                        value: value,
                                        child: Text(
                                            value.fullNameLocale.toString()),
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
                                    mode: Mode.DIALOG,
                                    // maxHeight: 300,
                                    items: model.cities,
                                    onChanged: print,
                                    hint: translate('city'),
                                    dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    showSearchBox: true,
                                    // searchBoxDecoration: InputDecoration(
                                    //   border: OutlineInputBorder(),
                                    //   contentPadding:
                                    //       EdgeInsets.fromLTRB(12, 12, 8, 0),
                                    //   labelText: translate("searchForState"),
                                    // ),
                                    label: translate("searchForCity"),
                                    onSaved: (newValue) =>
                                        model.updateCityName(newValue),
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
                        // SizedBox(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       color: Colors.white,
                        //     ),
                        //     padding: EdgeInsets.only(right: 10, left: 10),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: DropdownButtonFormField(
                        //             hint: Text(translate('state')),
                        //             onChanged: (value) =>
                        //                 model.updateCountry(value),
                        //             isDense: true,
                        //             autovalidateMode:
                        //                 AutovalidateMode.onUserInteraction,
                        //             // validator: (CountriesModel value) => Validators.validateForm(value.id),
                        //             items: [],
                        //           ),
                        //           flex: 13,
                        //         )
                        //       ],
                        //     ),
                        //     margin: EdgeInsets.only(bottom: 10),
                        //   ),
                        //   width: MediaQuery.of(context).size.width,
                        // ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     color: Colors.white,
                        //   ),
                        //   child: TextFormField(
                        //     keyboardType: TextInputType.text,
                        //     onChanged: (value) => model.updateDistrict(value),
                        //     validator: (String value) =>
                        //         Validators.validateForm(value),
                        //     decoration: InputDecoration(
                        //       hintText: translate('district'),
                        //       contentPadding:
                        //           EdgeInsets.symmetric(horizontal: 10),
                        //       hintStyle: TextStyle(fontSize: 14),
                        //       isDense: true,
                        //     ),
                        //   ),
                        //   alignment: Alignment.center,
                        //   margin: EdgeInsets.symmetric(vertical: 8),
                        //   padding:
                        //       EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) => model.updateStreet(value),
                            validator: (String value) =>
                                Validators.validateForm(value),
                            decoration: InputDecoration(
                              hintText: translate('street'),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(fontSize: 14),
                              isDense: true,
                            ),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) => model.updateLandMark(value),
                            validator: (String value) =>
                                Validators.validateForm(value),
                            decoration: InputDecoration(
                              hintText: translate('landmark'),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(fontSize: 14),
                              isDense: true,
                            ),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        ),
                        // SizedBox(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       color: Colors.white,
                        //     ),
                        //     padding: EdgeInsets.only(right: 10, left: 10),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: DropdownButtonFormField<AvailableState>(
                        //             hint: Text(translate('state')),
                        //             onChanged: (value) => model.updateState(context,value),
                        //             isDense: true,
                        //             autovalidateMode: AutovalidateMode.onUserInteraction,
                        //             // validator: (AvailableState value) => Validators.validateForm(value.id),
                        //             items:
                        //             model.availableStates.map<DropdownMenuItem<AvailableState>>((AvailableState value) {
                        //               return DropdownMenuItem<AvailableState>(
                        //                 value: value,
                        //                 child: Text(value.statesName.toString()),
                        //               );
                        //             }).toList(),
                        //           ),
                        //           flex: 13,
                        //         )
                        //       ],
                        //     ),
                        //     margin: EdgeInsets.only(bottom: 10),
                        //   ),
                        //   width: MediaQuery.of(context).size.width,
                        // ),

                        // SizedBox(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       color: Colors.white,
                        //     ),
                        //     padding: EdgeInsets.only(right: 10, left: 10),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: DropdownButtonFormField<CountriesModel>(
                        //             hint: Text(translate('city')),
                        //             onChanged: (value) => model.updateCountry(value),
                        //             isDense: true,
                        //             autovalidateMode: AutovalidateMode.onUserInteraction,
                        //             // validator: (CountriesModel value) => Validators.validateForm(value.id),
                        //             items:
                        //             model.countries.map<DropdownMenuItem<CountriesModel>>((CountriesModel value) {
                        //               return DropdownMenuItem<CountriesModel>(
                        //                 value: value,
                        //                 child: Text(value.fullNameLocale.toString()),
                        //               );
                        //             }).toList(),
                        //           ),
                        //           flex: 13,
                        //         )
                        //       ],
                        //     ),
                        //     margin: EdgeInsets.only(bottom: 10),
                        //   ),
                        //   width: MediaQuery.of(context).size.width,
                        // ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     color: Colors.white,
                        //   ),
                        //   child: TextFormField(
                        //     keyboardType: TextInputType.text,
                        //     onChanged: (value) => model.updateCity(value),
                        //     validator: (String value) => Validators.validateForm(value),
                        //     decoration: InputDecoration(
                        //       hintText: translate('city'),
                        //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        //       hintStyle: TextStyle(fontSize: 14),
                        //       isDense: true,
                        //     ),
                        //   ),
                        //   alignment: Alignment.center,
                        //   margin: EdgeInsets.symmetric(vertical: 8),
                        //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        // ),
                        CheckboxListTile(
                          title: Text(translate('default_shipping')),
                          value:
                              model.defaultMyAddress.defaultShipping ?? false,
                          onChanged: (newValue) =>
                              model.updateDefaultShipping(newValue),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.primaryColor,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () => model.addNewAddress(context),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
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
                                translate('save'),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
