import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/contact_us_view_model.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

class ContactUs extends StatelessWidget {
  TextStyle styleHead = TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12);
  TextStyle styleBody = TextStyle(color: AppColors.secondaryColor, fontSize: 12);

  Widget title(element) {
    return Row(children: [
      Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            translate(element) + '*',
            style: TextStyle(fontSize: 14),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('contact_now')),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        padding: EdgeInsets.only(right: 10, left: 10, top: 30),
        margin: EdgeInsets.all(10),
        child: ViewModelBuilder<ContactUsViewModel>.reactive(
          viewModelBuilder: () => ContactUsViewModel(),
          disposeViewModel: false,
          builder: (context, model, child) {
            return Form(
              key: model.userForm,
              child: Column(
                children: [
                  // Name
                  title('user_name'),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        // initialValue: model.data.name,
                        onChanged: (value) => model.updateName(value),
                        validator: (String value) => Validators.validateName(value),
                        decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(fontSize: 12),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 10),
                  // Email
                  title('email'),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        // initialValue: model.data.email,
                        onChanged: (value) => model.updateEmail(value),
                        validator: (String value) => Validators.validateEmail(value),
                        decoration: InputDecoration(
                            hintText: '',
                            isDense: true,
                            hintStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 10),
                  // Phone
                  title('phone'),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        // initialValue: model.data.email,
                        onChanged: (value) => model.updatePhone(value),
                        validator: (String value) => Validators.validatePhone(value),
                        decoration: InputDecoration(
                            hintText: translate(''),
                            isDense: true,
                            hintStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 10),
                  // Message
                  title('message'),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        // initialValue: model.data.email,
                        onChanged: (value) => model.updateComment(value),
                        validator: (String value) => Validators.validateForm(value),
                        decoration: InputDecoration(
                            hintText: translate(''), isDense: true,
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
                        onTap: () => model.submit(context),
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
            );
          },
        ),
      ),
    );
  }
}
