import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:jawhara/viewModel/forget_view_model.dart';

import '../../index.dart';

class ForgetPassword extends StatelessWidget {
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
              child: Text(translate('forget_password')),
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
                // onModelReady: (model) => model.initScreen(context),
                builder: (context, model, child) {
                  return Form(
                    key: model.userForm,
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Container(
                          child: Text(
                            translate('enter_verf_code'),
                            style: TextStyle(
                              color: AppColors.mainTextColor,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 5),
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
                        SizedBox(height: 10),
                        // button sign up
                        GestureDetector(
                          onTap: () => model.forgetPassword(context),
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
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              if (model.userForm.currentState.validate()) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: VerificationCode(model.data.email, showValidationToken: true,),
                                  ),
                                );
                              }
                            },
                            child: Text(translate('alreadyHaveToken')))
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
