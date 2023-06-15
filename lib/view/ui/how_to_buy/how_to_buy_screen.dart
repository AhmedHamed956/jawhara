import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HowToBuyScreen extends StatelessWidget {
  final String howToBuyArDiv =
      '''<html><body><div data-content-type="row" data-appearance="contained" data-element="main"><div data-enable-parallax="0" data-parallax-speed="0.5" data-background-images="{}" data-background-type="image" data-video-loop="true" data-video-play-only-visible="true" data-video-lazy-load="true" data-video-fallback-src="" data-element="inner" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; margin: 0px 0px 10px; padding: 10px;"><div class="pagebuilder-column-group" style="display: flex;" data-content-type="column-group" data-grid-size="12" data-element="main"><div class="pagebuilder-column" data-content-type="column" data-appearance="full-height" data-background-images="{}" data-element="main" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; width: 100%; margin: 0px; padding: 10px; align-self: stretch;"><div data-content-type="text" data-appearance="default" data-element="main" style="border-style: none; border-width: 1px; border-radius: 0px; margin: 0px; padding: 0px;"></div><div data-content-type="text" data-appearance="default" data-element="main" style="border-style: none; border-width: 1px; border-radius: 0px; margin: 0px; padding: 0px;"><h1 style="direction: rtl;">طرق الشراء</h1>
<div>
<div style="direction: rtl;">&nbsp;<strong>الشراء من موقع جوهره&nbsp; في غاية السهولة من خلال التصفح والبحث عن المنتجات كما يوجد العديد من خيارات الدفع لتلبي جميع احتياجاتك.</strong></div>
<div style="direction: rtl;"><strong>1</strong><strong>- ابحث وتصفح المنتجات .</strong></div>
<div style="direction: rtl;"><strong>2- تعرف على المنتج الذي تريده .</strong></div>
<div style="direction: rtl;"><strong>3- أضف المنتج إلى عربة المشتريات .</strong></div>
<div style="direction: rtl;"><strong>4- راجع عربة المشتريات و تسجيل الدخول إلى الحساب .</strong></div>
<div style="direction: rtl;"><strong>5- تأكيد طلبك.</strong></div>
<div>
<p style="direction: rtl;"><strong style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">6- تابع طلبك إلى أن يتم تسليم الطلب إليك.</strong></p>
<p style="direction: rtl;"><span style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;"><strong>&nbsp;</strong></span></p>
<p style="direction: rtl;"><strong style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">1-ابحث وتصفح المنتجات.</strong></p>
</div>
<div style="direction: rtl;">توجد الكثير والعديد من المنتجات المتنوعة.</div>
<div style="direction: rtl;">• من خلال الكتابة في صندوق البحث أعلى الصفحة بإمكانك البحث عن أي منتج تريده &nbsp;وستحصل على نتائج بحثك.</div>
<div style="direction: rtl;">• بإمكانك التصفح من خلال الفئات يمين الصفحة وستحصل على نتائج الفئة المختارة.</div>
<div>
<p style="direction: rtl;"><span style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">• بإمكانك متابعة و تصفح كل ما هو جديد من منتجات على الصفحة الرئيسية من عروض ومفاجآت.&nbsp;&nbsp;</span></p>
<p style="direction: rtl;"><span style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">&nbsp;</span></p>
<p style="direction: rtl;"><strong style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">2- تعرف على المنتج الذي تريده.</strong></p>
</div>
<div>
<p style="direction: rtl;"><span style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">• تحقق من المنتج الذي تريده من خلال الصور والمواصفات وتقييماته في صفحة المنتج الخاصة على الموقع.</span></p>
<p style="direction: rtl;"><span style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">&nbsp;</span></p>
<p style="direction: rtl;"><strong style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">3- أضف المنتج إلى عربة المشتريات</strong><strong style="color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif;">.</strong></p>
</div>
<div>
<ul><li style="direction: rtl;">من خلال الضغط على المنتج واختيار اضافته الى عربة المشتريات.</li>
</ul></div>
<div style="direction: rtl;"><strong>4- راجع عربة المشتريات وتسجيل الدخول إلى الحساب.</strong></div>
<div>
<ul><li style="direction: rtl;">من خلال عربة المشتريات بإمكانك&nbsp; التأكد من جميع المنتجات التي ترغب بشرائها.</li>
<li style="direction: rtl;">بعد مراجعة عربة المشتريات قم بالتسجيل في الموقع اذا لم تكن مسجل من قبل.</li>
<li style="direction: rtl;">بإمكانك التسجيل من خلال وسائل التواصل الاجتماعي المعروضة لك<strong>.</strong></li>
</ul></div>
<div style="direction: rtl;"><strong>5- تأكيد طلبك.</strong></div>
<div>
<ul><li style="direction: rtl;">• من خلال كتابة العناوين الخاصة بك واختيار شركة الشحن وطريقة الدفع و الضغط على زر التأكيد.</li>
<li style="direction: rtl;">• ستصلك رسالة عن طريق البريد الالكتروني بتأكيد طلبك.</li>
</ul></div>
<div style="direction: rtl;"><strong>&nbsp;6- تابع طلبك إلى إن يتم تسليم الطلب إليك.</strong></div>
<div>
<ul><li style="direction: rtl;">سيتم تزويدك برقم بوليصة الشحن لمتابعة شحناتك.</li>
</ul></div>
</div></div></div></div></div></div></body></html>''';

  WebViewController _controller;

  final howToBuyEnDiv = '''<html><body><div data-content-type="row" data-appearance="contained" data-element="main"><div data-enable-parallax="0" data-parallax-speed="0.5" data-background-images="{}" data-background-type="image" data-video-loop="true" data-video-play-only-visible="true" data-video-lazy-load="true" data-video-fallback-src="" data-element="inner" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; margin: 0px 0px 10px; padding: 10px;"><div class="pagebuilder-column-group" style="display: flex;" data-content-type="column-group" data-grid-size="12" data-element="main"><div class="pagebuilder-column" data-content-type="column" data-appearance="full-height" data-background-images="{}" data-element="main" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; width: 100%; margin: 0px; padding: 10px; align-self: stretch;"><div data-content-type="text" data-appearance="default" data-element="main" style="border-style: none; border-width: 1px; border-radius: 0px; margin: 0px; padding: 0px;"></div><div data-content-type="text" data-appearance="default" data-element="main" style="border-style: none; border-width: 1px; border-radius: 0px; margin: 0px; padding: 0px;"><h1>Purchase Methods</h1>
<div>
<div>Purchase from Jawhara Website is very easy by browsing and searching for products, there are many payment and delivery options to meet all your needs.</div>
<div>1) Search and browse products.</div>
<div>2) Know the product you want.</div>
<div>3) Add the product to the shopping cart.</div>
<div>4) Review your shopping cart and sign in to your account.</div>
<div>5) Confirm your order.</div>
<div>6) Follow your order until it is delivered to you.</div>
<div>1. Search and browse products.</div>
<div>There are many different products on the website.</div>
<div>
<ul><li>By typing in the search box at the top of the page you can search for any product you want and you will get the results of your search.</li>
<li>You can browse through the categories on the right of the page and you will get the results of the selected category.</li>
<li>You can browse and follow up with all new products on the homepage of offers and surprises.</li>
</ul>
2. Know the product you want
<ul><li>Check the product you want through the images, specifications and ratings on the product page.</li>
</ul>
3. Add the product to the shopping cart.
<ul><li>By clicking on the product and choosing add it to the shopping cart.</li>
</ul>
4. Review your shopping cart and sign in to your account.
<ul><li>Through the shopping cart you can check all the products you want to purchase.</li>
<li>After reviewing the shopping cart, sign up if you have not already registered.</li>
<li>You can register through the social media offered to you.</li>
</ul>
5. Confirm your order.
<ul><li>By typing your addresses and selecting the shipping company, payment method then pressing the Confirm button.</li>
<li>You will receive a message by email confirming your order.</li>
</ul>
6. Follow your order until it is delivered to you. You will be provided with your bill of shipment number to track your shipments.</div>
</div></div></div></div></div></div></body></html>''';

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('how_to_buy')),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor,
        ),
        // padding: EdgeInsets.only(right: 10, left: 10, top: 30),
        // margin: EdgeInsets.all(10),
        child: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _controller.loadUrl(Uri.dataFromString(
                (lang == "ar" ? howToBuyArDiv : howToBuyEnDiv).replaceAll("<body>",
                        "<body dir=\"${lang == "ar" ? "rtl" : "ltr"}\">"),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString());
          },
        ),
      ),
    );
  }
}
