import 'package:flutter/material.dart';
import 'package:jawhara/view/index.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';

class Success extends StatefulWidget {
  String orderId;

  Success(this.orderId);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  heightFactor: 1.5,
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.greenColor,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 50,
                      ))),
              Text(
                translate('success_done'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate('success_title'), textAlign: TextAlign.center),
                    Text('${widget.orderId}', textAlign: TextAlign.center, style: TextStyle(color: AppColors.redColor)),
                    SizedBox(height: 5),
                    Text(translate('success_body'), textAlign: TextAlign.center),
                    Text('order@jawhara.online', textAlign: TextAlign.center, style: TextStyle(color: AppColors.redColor)),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        translate('success_footer'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.greenColor),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap:  _clicked
                            ? null
                            :() {
                          setState(() => _clicked = true);
                          locator<CartViewModel>().initScreen(context, afterEnd: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(0);
                          });
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
                        },
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
                            translate('confirm'),
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
              )
            ],
          ),
        ));
  }
}
