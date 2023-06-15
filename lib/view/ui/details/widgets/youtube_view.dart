import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/view/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeView extends StatefulWidget {
  String url;

  YoutubeView(this.url);

  @override
  State<YoutubeView> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<YoutubeView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(translate('watchVideo'))),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        child: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
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
