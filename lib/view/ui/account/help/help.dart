import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/view/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(translate('help'))),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        child: Stack(
          children: [
            WebView(
              initialUrl: lang == 'ar' ? Strings.AR_HELP : Strings.EN_HELP,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {},
            ),
            isLoading ? ShapeLoadingR() : Stack(),
          ],
        ),
      ),
    );
  }
}
