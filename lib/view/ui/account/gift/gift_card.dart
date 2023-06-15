import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/view/ui/account/shipping/edit_shipping_address.dart';
import 'package:jawhara/view/ui/account/shipping/add_shipping_address.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/gift_card_view_model.dart';
import 'package:jawhara/viewModel/shipping_address_view_model.dart';
import 'package:jawhara/viewModel/sign_in_view_model.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

class GiftCard extends StatelessWidget {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('gift')),
      ),
      body:            Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        padding: EdgeInsets.only(right: 10, left: 10, top: 30),
        margin: EdgeInsets.all(10),
        child: ViewModelBuilder<GiftCardViewModel>.reactive(
          viewModelBuilder: () => GiftCardViewModel(),
          disposeViewModel: false,
          builder: (context, model, child) {
            return Form(
              key: model.userForm,
              child: Column(
                children: [
                  // Card number
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        // initialValue: model.data.email,
                        onChanged: (value) => model.giftId = value,
                        validator: (String value) => Validators.validateForm(value),
                        decoration: InputDecoration(
                            hintText: translate('card_number'), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => model.checkBalance(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.0),
                            color: AppColors.mainTextColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            translate('check_balance'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => model.redeemCard(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.0),
                            color: AppColors.fourthColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            translate('redeem_card'),
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
            );
          },
        ),
      ),
    );
  }
}
