import 'package:flutter/material.dart';
import 'package:jawhara/view/index.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';

class Failed extends StatefulWidget {
  String orderId;
  String message;

  Failed(this.orderId,this.message);

  @override
  _FailedState createState() => _FailedState();
}

class _FailedState extends State<Failed> {
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
                      backgroundColor: AppColors.redColor,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 50,
                      ))),
              Text(
                translate('payment_failed'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.message,
                        textAlign: TextAlign.center),
                    Center(
                      child: GestureDetector(
                        onTap:   _clicked
                            ? null
                            :() {
                          setState(() => _clicked = true);
                          locator<CartViewModel>().initScreen(context, afterEnd: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            (MainTabControlDelegate.getInstance()
                                .globalKey
                                .currentWidget as BottomNavigationBar)
                                .onTap(0);
                          });
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
                        },
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
