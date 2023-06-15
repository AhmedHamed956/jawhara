import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/view/ui/auth/sign_up.dart';
import 'package:jawhara/viewModel/sign_in_view_model.dart';

import '../../index.dart';
import 'forget_password.dart';

class SignIn extends StatefulWidget {
  bool isFromCart;

  SignIn({this.isFromCart = false});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool passwordShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: SizedBox(
            height: 30, child: Image.asset('assets/images/thumbnail.png')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(translate('login')),
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
              padding: EdgeInsets.only(right: 10, left: 10, top: 30),
              margin: EdgeInsets.all(10),
              child: ViewModelBuilder<SignInViewModel>.reactive(
                viewModelBuilder: () => SignInViewModel(),
                disposeViewModel: false,
                builder: (context, model, child) {
                  return Form(
                    key: model.userForm,
                    child: Column(
                      children: [
                        // Email
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
                              // validator: (String value) => Validators.validateEmail(value),
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
                              // initialValue: model.data.password,
                              onChanged: (value) => model.data.password = value,
                              validator: (String value) =>
                                  Validators.validateForm(value),
                              decoration: InputDecoration(
                                  hintText: translate('password'),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passwordShown = !passwordShown;
                                      });
                                    },
                                    child: Icon(
                                      passwordShown
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      size: 16,
                                    ),
                                  )

                                  // suffix: Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //   child: Icon(
                                  //     IcoMoon.eye,
                                  //     size: 10,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // button forget
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: ForgetPassword(),
                                ),
                              ),
                              child: Container(
                                child: Text(
                                  translate('forget_password'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                            // button login
                            GestureDetector(
                              onTap: () => model.signInUser(context,widget.isFromCart),
                              child: Container(
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
                                  translate('login'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        // if (!Platform.isIOS)
                        Text(translate('or')), // TODO: Remove this condition after add apple sign in
                        // if (!Platform.isIOS)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: new RaisedButton(
                                    padding: EdgeInsets.all(1.0),
                                    color: HexColor('#DE4B39'),
                                    onPressed: () async {
                                      return await model.loginGoogle(context);
                                    },
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Icon(
                                              Ionicons.logo_google,
                                              color: HexColor('#DE4B39'),
                                              size: 18,
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: model.isGoogleLoad
                                              ? Center(
                                                  child: ShapeLoading(
                                                  color: Colors.white,
                                                  size: 30,
                                                ))
                                              : Container(
                                                  padding:
                                                      EdgeInsets.only(top: 4),
                                                  child: new Text(
                                                    translate('sign_in_google'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                          flex: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: new RaisedButton(
                                      padding: EdgeInsets.all(1.0),
                                      color: const Color(0xff3B5999),
                                      onPressed: () async {
                                        return await model
                                            .loginFacebook(context);
                                      },
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xff3B5999),
                                              ),
                                              child: Icon(
                                                Fontisto.facebook,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: model.isFaceLoad
                                                ? Center(
                                                    child: ShapeLoading(
                                                    color: Colors.white,
                                                    size: 30,
                                                  ))
                                                : Container(
                                                    padding:
                                                        EdgeInsets.only(top: 4),
                                                    child: new Text(
                                                      translate(
                                                          'sign_in_facebook'),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                    alignment: Alignment.center,
                                                  ),
                                            flex: 4,
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        // Apple Login
                        Row(
                          children: [
                            Spacer(),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                child: new RaisedButton(
                                    padding: EdgeInsets.all(1.0),
                                    color: const Color(0xff050708),
                                    onPressed: () async {
                                      return await model.loginApple(context);
                                    },
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color:  Color(0xff050708),
                                            ),
                                            child: Icon(
                                              Fontisto.apple,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: model.isFaceLoad
                                              ? Center(
                                              child: ShapeLoading(
                                                color: Colors.white,
                                                size: 30,
                                              ))
                                              : Container(
                                            padding: EdgeInsets.only(top: 4),
                                            child: new Text(
                                              translate('sign_in_apple'),
                                              style: TextStyle(color: Colors.white, fontSize: 10),
                                            ),alignment: Alignment.center,),
                                          flex: 4,
                                        )
                                      ],
                                    )),
                              ),
                              flex: 2,
                            ),
                            Spacer(),
                          ],
                        ),
                        // button sign up
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate('not_have_acc'),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  translate('register_now'),
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        )
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
