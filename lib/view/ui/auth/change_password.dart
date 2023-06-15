import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../index.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: SizedBox(height: 30, child: Image.asset('assets/images/thumbnail.png')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(translate('change_password')),
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
              child: ViewModelBuilder<NewViewModel>.reactive(
                viewModelBuilder: () => NewViewModel(),
                disposeViewModel: false,
                // onModelReady: (model) => model.initScreen(context),
                builder: (context, model, child) {
                  return Form(
                    // key: model.userForm,
                    child: Column(
                      children: [
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
                              obscureText: true,
                              // initialValue: model.data.password,
                              // onChanged: (value) => model.data.password = value,
                              // validator: (String value) => Validators.validateForm(value),
                              decoration: InputDecoration(
                                hintText: translate('password'),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),

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
                              obscureText: true,
                              // initialValue: model.data.password,
                              // onChanged: (value) => model.data.password = value,
                              // validator: (String value) => Validators.validateForm(value),
                              decoration: InputDecoration(
                                hintText: translate('re_password'),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),

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
                        // button sign up
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width:140,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
