import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/view/ui/account/shipping/edit_shipping_address.dart';
import 'package:jawhara/view/ui/account/shipping/add_shipping_address.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

class MyAddress extends StatelessWidget {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('addresses')),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ShippingAddress(),
              ),
            ),
            icon: Icon(
              Icons.add_circle,
              color: AppColors.greenColor,
            ),
            label: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                translate('add_new_address'),
                style: styleBody.copyWith(color: AppColors.greenColor),
              ),
            ),
          )
        ],
      ),
      body: ViewModelBuilder<ShippingAddressViewModel>.reactive(
        viewModelBuilder: () => locator<ShippingAddressViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) => model.initScreen(context, _auth.currentUser.id),
        builder: (context, model, child) {
          if (model.isBusy) return Center(child: Text(translate('loading')));
          if (model.addresses.isEmpty) return Center(child: Text(translate('empty_data')));
          return ListView(
              children: model.addresses
                  .map((e) => Card(
                        color: Colors.grey[100],
                        elevation: 0,
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      translate('country'),
                                      style: styleHead,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      e.countryId,
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
                                      e.city,
                                      style: styleBody,
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       translate('district'),
                                //       style: styleHead,
                                //     ),
                                //     SizedBox(width: 5),
                                //     Text(e.customAttributes != null ? e.customAttributes[0].value : '', style: styleBody),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      translate('street'),
                                      style: styleHead,
                                    ),
                                    SizedBox(width: 5),
                                    Row(
                                      children: e.street.map((e) => Text(e.toString() + ' ', style: styleBody)).toList(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      translate('email'),
                                      style: styleHead,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                        (e.customAttributes != null && e.customAttributes.length > 1)
                                            ? e.customAttributes[0].value.contains('@')
                                                ? e.customAttributes[0].value
                                                : e.customAttributes[1].value
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
                                    Text((e.customAttributes != null && e.customAttributes.length > 1) ? e.customAttributes[1].value : '',
                                        style: styleBody),
                                  ],
                                ),
                                if (e.postcode != null && e.postcode.isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        translate('postal_code'),
                                        style: styleHead,
                                      ),
                                      SizedBox(width: 5),
                                      Text(e.postcode, style: styleBody),
                                    ],
                                  ),
                              ],
                            ),
                            subtitle: Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]),
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(Radius.circular(4))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: e.defaultShipping != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 2.5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  size: 18,
                                                  color: AppColors.fourthColor,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5, left: 2, right: 4),
                                                  child: Text(
                                                    translate('default'),
                                                    style: TextStyle(fontSize: 15, color: AppColors.fourthColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () => model.defaultAddress(context, e.id),
                                            child: Container(
                                              color: Colors.transparent,
                                              padding: const EdgeInsets.only(top: 2.5),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    size: 18,
                                                    color: AppColors.darkGreyColor,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5, left: 2, right: 4),
                                                    child: Text(
                                                      translate('default'),
                                                      style: TextStyle(fontSize: 15, color: AppColors.darkGreyColor),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Icon(Icons.edit, size: 22),
                                      onTap: () => Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: EditShippingAddress(e),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () => model.deleteAddress(context, e.id.toString()),
                                        child: Icon(Icons.delete, size: 22, color: Colors.redAccent)),
                                  ),
                                ],
                              ),
                            )),
                      ))
                  .toList());
        },
      ),
    );
  }
}
