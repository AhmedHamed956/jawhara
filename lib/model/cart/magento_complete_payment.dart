import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jawhara/view/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MagentoCompletePayment extends StatefulWidget {
  final String thirdRedirectURL;
  final Function onFinish;
  final bool isSavedCard;

  MagentoCompletePayment({this.thirdRedirectURL, this.onFinish,@required this.isSavedCard});

  @override
  State<StatefulWidget> createState() {
    return MagentoCompletePaymentState();
  }
}

class MagentoCompletePaymentState extends State<MagentoCompletePayment> {
  // final flutterWebViewPlugin = FlutterWebviewPlugin();
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  Future<void> secureScreen() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    // flutterWebViewPlugin.onUrlChanged.listen((String url) {
    //   print("URL: " + url);
    //   if (url.contains("amazonpaymentservicesfort/payment/responseapi/")) {
    //     flutterWebViewPlugin.hide();
    //     widget.onFinish("");
    //     Navigator.of(context).pop();
    //   }
    // });
  }

  Future<bool> _onWillPop() async {
    // flutterWebViewPlugin.hide();
    return (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('confirmation'),
            content: Text('Do you want to cancel payment process?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // flutterWebViewPlugin.show();
                },
                child: Text('no'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  widget.onFinish("cancel");
                  Navigator.of(this.context).pop();
                },
                child: Text('yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // withJavascript: true,
        // appCacheEnabled: true,
        // url: widget.thirdRedirectURL,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _onWillPop),
          backgroundColor: Colors.grey[200],
          elevation: 0.0,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: widget.thirdRedirectURL,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              if (widget.isSavedCard
                  ? url.contains("amazonpaymentservicesfort/payment/merchantPageVaultResponseApi")
                  : url.contains("amazonpaymentservicesfort/payment/responseapi/")) {
                widget.onFinish("");
                Navigator.of(context).pop();
              }
            },
            gestureNavigationEnabled: true,
          );
        }),
        // withZoom: true,
        // withLocalStorage: true,
        // hidden: true,
        // initialChild: Container(child: kLoadingWidget(context)),
      ),
    );
  }
}

Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
    );
