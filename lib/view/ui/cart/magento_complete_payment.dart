// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:jawhara/view/widgets/loading.dart';
//
// class MagentoCompletePayment extends StatefulWidget {
//   final String thirdRedirectURL;
//   final Function onFinish;
//
//   MagentoCompletePayment({this.thirdRedirectURL, this.onFinish});
//
//   @override
//   State<StatefulWidget> createState() {
//     return MagentoCompletePaymentState();
//   }
// }
//
// class MagentoCompletePaymentState extends State<MagentoCompletePayment> {
//   final flutterWebViewPlugin = FlutterWebviewPlugin();
//
//   Future<void> secureScreen() async {
//     // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//   }
//
//   @override
//   void initState() {
//     secureScreen();
//     super.initState();
//     flutterWebViewPlugin.onUrlChanged.listen((String url) {
//       print("URL: " + url);
//       if (url.contains("payfortfort/payment/responseapi")) {
//         flutterWebViewPlugin.hide();
//         widget.onFinish("");
//         Navigator.of(context).pop();
//       }
//     });
//   }
//
//   Future<bool> _onWillPop() async {
//     flutterWebViewPlugin.hide();
//     return (await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => AlertDialog(
//             title: Text(translate("confirmation")),
//             content: Text(translate("wantToCancelPayment")),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                   flutterWebViewPlugin.show();
//                 },
//                 child: Text(translate("no")),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                   widget.onFinish("cancel");
//                   Navigator.of(this.context).pop();
//                 },
//                 child: Text(translate("yes")),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: WebviewScaffold(
//         withJavascript: true,
//         appCacheEnabled: true,
//         url: widget.thirdRedirectURL,
//         appBar: AppBar(
//           leading:
//               IconButton(icon: Icon(Icons.arrow_back), onPressed: _onWillPop),
//           backgroundColor: Color(0xFFEEEEEE),
//           elevation: 0.0,
//         ),
//         withZoom: true,
//         withLocalStorage: true,
//         hidden: true,
//         initialChild: Container(
//             child: Center(
//                 child: ShapeLoading(
//           color: Colors.white,
//           size: 30,
//         ))),
//       ),
//     );
//   }
// }
