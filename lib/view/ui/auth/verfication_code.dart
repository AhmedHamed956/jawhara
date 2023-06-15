import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/viewModel/forget_view_model.dart';

import '../../index.dart';

class VerificationCode extends StatelessWidget {
  final String email;
  final String token;
  final bool showValidationToken;

  VerificationCode(this.email, {this.token, this.showValidationToken = false});

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
              child: Text(translate('settingNewPassword')),
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
              child: ViewModelBuilder<ForgetViewModel>.reactive(
                viewModelBuilder: () => ForgetViewModel(),
                disposeViewModel: false,
                onModelReady: (model) => model.initScreen(context, email),
                builder: (context, model, child) {
                  return Form(
                    key: model.userForm,
                    child: Column(
                      children: [
                        // SizedBox(height: 5),
                        // Container(
                        //   child: Text(
                        //     translate('verf_code_sent'),
                        //     style: TextStyle(
                        //       color: AppColors.mainTextColor,
                        //     ),
                        //   ),
                        //   padding: EdgeInsets.all(10),
                        //   alignment: Alignment.centerRight,
                        // ),
                        SizedBox(height: 5),
                        if (showValidationToken)
                          // Token send
                          SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                onChanged: (value) =>
                                    model.data.verifyCode = value,
                                validator: (String value) =>
                                    Validators.validateForm(value),
                                decoration: InputDecoration(
                                    hintText: translate('verf_code'),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10)),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                          ),
                        if (showValidationToken) SizedBox(height: 10),
                        // New password
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onChanged: (value) => model.data.password = value,
                              validator: (String value) =>
                                  Validators.validatePassword(value),
                              decoration: InputDecoration(
                                hintText: translate('new_password'),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 10),
                        // Confirm new password
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onChanged: (value) =>
                                  model.data.rePassword = value,
                              validator: (String value) =>
                                  Validators.validatePasswordConfirm(value,
                                      password: model.data.password),
                              decoration: InputDecoration(
                                hintText: translate('confirm_new_password'),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 10),
                        // button sign up
                        GestureDetector(
                          onTap: () {
                            if (!showValidationToken) {
                              model.data.verifyCode = token;
                            }
                            model.changePassword(context,
                                showValidationToken: showValidationToken);
                          },
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
                              translate('confirm'),
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
