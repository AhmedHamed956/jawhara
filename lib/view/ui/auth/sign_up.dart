import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/viewModel/sign_up_view_model.dart';

import '../../index.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool passwordShown = false;
  bool confirmPasswordShown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: SizedBox(
            height: 30, child: Image.asset('assets/images/thumbnail.png')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(translate('sign_up_user')),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: AppColors.greyColor,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: AppColors.bgColor,
              ),
              padding: EdgeInsets.only(right: 10, left: 10, top: 10),
              margin: EdgeInsets.all(10),
              child: ViewModelBuilder<SignUpViewModel>.reactive(
                viewModelBuilder: () => SignUpViewModel(),
                disposeViewModel: false,
                // onModelReady: (model) => model.initScreen(context),
                builder: (context, model, child) {
                  return Form(
                    key: model.userForm,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text(
                                translate('personal_info'),
                                style: TextStyle(
                                    color: AppColors.mainTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              padding: EdgeInsets.all(10),
                              // alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        // First Name
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) =>
                                  model.data.firstName = value,
                              validator: (String value) =>
                                  Validators.validateName(value),
                              decoration: InputDecoration(
                                  hintText: translate('first_name'),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 15),
                        // Family Name
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              // initialValue: model.data.email,
                              onChanged: (value) => model.data.lastName = value,
                              validator: (String value) =>
                                  Validators.validateName(value),
                              decoration: InputDecoration(
                                  hintText: translate('last_name'),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 15),
                        // Gender
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
                                  child: DropdownButtonFormField<String>(
                                    hint: Text(translate('gender')),
                                    onChanged: model.updateGender,
                                    // value: model.data.gender,
                                    isDense: true,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    // validator: (String value) =>
                                    //     Validators.validateGender(value),
                                    items: model.gender
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child:
                                            Text(translate(value.toString())),
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
                        SizedBox(height: 25),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                translate('login_info'),
                                style: TextStyle(
                                    color: AppColors.mainTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              padding: EdgeInsets.all(10),
                              // alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        // Email address
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              // initialValue: model.data.email,
                              onChanged: (value) => model.data.email = value,
                              validator: (String value) =>
                                  Validators.validateEmail(value),
                              decoration: InputDecoration(
                                  hintText: translate('email'),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 15),
                        // Password
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: !passwordShown,
                              onChanged: (value) => model.data.password = value,
                              validator: (String value) =>
                                  Validators.validatePassword(value),
                              decoration: InputDecoration(
                                hintText: translate('password'),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        passwordShown = !passwordShown;
                                      });
                                    },
                                    child: Icon(passwordShown
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye, size: 16,),
                                  )
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 15),
                        // Re Password
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: !confirmPasswordShown,
                              onChanged: (value) =>
                                  model.data.rePassword = value,
                              validator: (String value) =>
                                  Validators.validatePasswordConfirm(value,
                                      password: model.data.password),
                              decoration: InputDecoration(
                                hintText: translate('re_password'),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        confirmPasswordShown = !confirmPasswordShown;
                                      });
                                    },
                                    child: Icon(confirmPasswordShown
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye, size: 16,),
                                  )
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 15),
                        CheckboxListTile(
                          value: model.data.isSubscribed,
                          onChanged: (value) {
                            model.updateIsSubscribed(value);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(translate("signupNewsletter")),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SizedBox(height: 10),
                        // button sign up
                        GestureDetector(
                          onTap: () => model.signUpUser(context),
                          child: Container(
                            width: 140,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: AppColors.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x7500acff),
                                  offset: Offset(0, 0),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              translate('sign_up'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}
