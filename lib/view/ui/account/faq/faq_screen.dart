import 'dart:convert';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../index.dart';

class FaqScreen extends StatelessWidget {
//   final String faqWebDiv =
//       '''<html><body><div class="columns"><div class="column main">
//
// <!-- Get and check site and campaign id. -->
//
// <div data-content-type="row" data-appearance="contained" data-element="main">
// <div data-enable-parallax="0" data-parallax-speed="0.5" data-background-images="{}" data-background-type="image" data-video-loop="true" data-video-play-only-visible="true" data-video-lazy-load="true" data-video-fallback-src="" data-element="inner" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; margin: 0px 0px 10px; padding: 10px;">
// <figure data-content-type="image" data-appearance="full-width" data-element="main" style="text-align: center; margin: 0px; padding: 0px; border-style: none;">
// <img class="pagebuilder-mobile-only" src="https://jawhara.online/media/wysiwyg/faq.jpg" alt="" title="" data-element="mobile_image" style="border-style: none; border-width: 1px; border-radius: 0px; max-width: 100%; height: auto;">
// </figure>
// </div></div><div data-content-type="row" data-appearance="contained" data-element="main"><div data-enable-parallax="0" data-parallax-speed="0.5" data-background-images="{}" data-background-type="image" data-video-loop="true" data-video-play-only-visible="true" data-video-lazy-load="true" data-video-fallback-src="" data-element="inner" style="justify-content: flex-start; display: flex; flex-direction: column; background-position: left top; background-size: cover; background-repeat: no-repeat; background-attachment: scroll; border-style: none; border-width: 1px; border-radius: 0px; margin: 0px 0px 10px; padding: 10px;"><div data-content-type="html" data-appearance="default" data-element="main" style="border-style: none; border-width: 1px; border-radius: 0px; margin: 0px; padding: 0px;" data-decoded="true"><div class="tabs-st1">
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck1">
//         <label class="tab-label" for="chck1">كم يستغرق الشحن؟</label>
//         <div class="tab-content">
// خلال 2 الى 7 ايام عمل .
//         </div>
//       </div>
//       <!-- end tab  -->
// <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck2">
//         <label class="tab-label" for="chck2">ماهي طرق الشحن  المتوفرة لديكم؟</label>
//         <div class="tab-content">
// نحاول دائما التعاقد مع أكثر شركات الشحن موثوقية و سرعة وندعم حاليا الشحن عن طريق أرامكس .
//         </div>
//       </div>
//       <!-- end tab  -->
//
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck3">
//         <label class="tab-label" for="chck3">هل التسوق في جوهره آمن ؟</label>
//         <div class="tab-content">
// نعم . التسوق آمن خلال موقع و تطبيق جوهره وعمليات الدفع آمنة
//         </div>
//       </div>
//       <!-- end tab  -->
//
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck4">
//         <label class="tab-label" for="chck4">ما هو رقم الطلب؟</label>
//         <div class="tab-content">
//             رقم الطلب هو الرقم الذي يظهر في قائمة طلباتي ويرسل خلال الايميل ومن خلال هذا الرقم سوف تتمكن  من معرفة حالة الطلب ورقم التتبع .
//         </div>
//       </div>
//       <!-- end tab  -->
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck5">
//         <label class="tab-label" for="chck5">اذا قمت بعملية شراء ولكن لم أحصل على رقم طلب ؟</label>
//         <div class="tab-content">
//  تفقد الايميل الخاص بك وقد  تكون في البريد المهمل  او التواصل معنا عبر الايميل او الاتصال بنا.
//         </div>
//       </div>
//       <!-- end tab  -->
// <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck6">
//         <label class="tab-label" for="chck6">هل يمكن الطلب من خارج المملكة العربية السعودية ؟</label>
//         <div class="tab-content">
//  لا يمكن في الوقت الحالي ونتطلع قريبا للتوصيل لأكثر من بلد.
//         </div>
//       </div>
//       <!-- end tab  -->
// <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck7">
//         <label class="tab-label" for="chck7">هل جميع المنتجات لديكم أصلية100% ؟</label>
//         <div class="tab-content">
//  نعم . جميع المنتجات أصلية 100%.
//         </div>
//       </div>
// <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck8">
//         <label class="tab-label" for="chck8">هل يمكنني شراء منتجاتكم و ارسالها كهدية لطرف ثالث ؟</label>
//         <div class="tab-content">
//  نعم في صفحة اتمام الطلب ضع عنوان الشخص الذي تحب ان تصل اليه الهدية.
//         </div>
//       </div>
//       <!-- end tab  -->
//       <!-- end tab  -->
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck9">
//         <label class="tab-label" for="chck9">أين أجد مواصفات المنتج ؟</label>
//         <div class="tab-content">
//             بإمكانك الاطلاع على المواصفات اسفل المنتج خلال(الوصف- المواصفات-التعليقات) .
//         </div>
//       </div>
//       <!-- end tab  -->
// <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck10">
//         <label class="tab-label" for="chck10">في حال لم استلم منتج ما , ماذا أفعل ؟</label>
//         <div class="tab-content">
//  الرجاء الاتصال بخدمة العملاء وتزويدهم برقم الطلبية.
//         </div>
//       </div>
//       <!-- end tab  -->
//       <div class="tab">
//         <input disabled="disabled" type="checkbox" id="chck11">
//         <label class="tab-label" for="chck11">هل يمكنني التواصل معكم؟ و كيف؟ </label>
//         <div class="tab-content">
//             نعم بإمكانك التواصل من 9 صباحا الى 6 مساءا من الأحد الى الخميس.
//
// خلال الرقم /966567302710+
//
// او الايميل/ <a href="mailto:contact@jawhara.online ">contact@jawhara.online </a>
//
//         </div>
//       </div>
//       <!-- end tab  -->
//
//     </div>
// <!-- end tabs-st1  -->
//
//
//
//
//   </div></div></div></div></div></body></html>''';

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('faq')),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: AppColors.bgColor,
          ),
          // padding: EdgeInsets.only(right: 10, left: 10, top: 30),
          // margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Image.network('https://jawhara.online/media/wysiwyg/faq.jpg'),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'كم يستغرق الشحن؟' : 'Can I buy from outside Saudi Arabia?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Container(
                    width: double.infinity,
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == "ar" ? 'خلال 2 الى 7 ايام عمل .' : 'You cannot currently.',
                        ),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'ماهي طرق الشحن  المتوفرة لديكم؟' : 'What shipping methods do you have?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Container(
                    width: double.infinity,
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang == "ar"
                            ? 'نحاول دائما التعاقد مع أكثر شركات الشحن موثوقية و سرعة وندعم حاليا الشحن عن طريق أرامكس .'
                            : 'We always try to contract with more companies Shipping is reliable and fast and we currently support shipping via Aramex.'),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'هل التسوق في جوهره آمن ؟' : 'What payment methods are available?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? 'نعم . التسوق آمن خلال موقع و تطبيق جوهره وعمليات الدفع آمنة'
                          : 'You can pay for Cash on Delivery or online through (Mada - Visa - MasterCard Card ).'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'ما هو رقم الطلب؟' : 'Can I buy from mobile?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? 'رقم الطلب هو الرقم الذي يظهر في قائمة طلباتي ويرسل خلال الايميل ومن خلال هذا الرقم سوف تتمكن  من معرفة حالة الطلب ورقم التتبع .'
                          : 'Yes, you can browse through mobile and download our app.'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'اذا قمت بعملية شراء ولكن لم أحصل على رقم طلب ؟' : 'How long does shipping take?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? ' تفقد الايميل الخاص بك وقد  تكون في البريد المهمل  او التواصل معنا عبر الايميل او الاتصال بنا.'
                          : 'Within 2 to 7 business days.'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'هل يمكن الطلب من خارج المملكة العربية السعودية ؟' : 'Is shopping through Jawhara safe?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? ' لا يمكن في الوقت الحالي ونتطلع قريبا للتوصيل لأكثر من بلد.'
                          : 'Yes . Secure shopping through the website and application of Jawhara and safe payment processes.'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'هل جميع المنتجات لديكم أصلية100% ؟' : 'Are all products available to you 100% original?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded:  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lang == "ar" ? ' نعم . جميع المنتجات أصلية 100%.' : 'Yes, all of our products are original 100%.'),
                        ],
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar"
                          ? 'هل يمكنني شراء منتجاتكم و ارسالها كهدية لطرف ثالث ؟'
                          : 'Can I buy your products and send them as a gift through you to a third party?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? ' نعم في صفحة اتمام الطلب ضع عنوان الشخص الذي تحب ان تصل اليه الهدية.'
                          : 'Yes, on the order completion page, put the address of the person you would like the gift to reach.'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'أين أجد مواصفات المنتج ؟' : 'What is the order number?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded:  Container(
                    width: double.infinity,
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang == "ar"
                            ? '            بإمكانك الاطلاع على المواصفات اسفل المنتج خلال(الوصف- المواصفات-التعليقات) .'
                            : 'The order number is the number that appears in my order list and will be sent via e-mail. Through this number you will know the status of the order and the tracking number.'),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'في حال لم استلم منتج ما , ماذا أفعل ؟' : 'If I did not receive a product, what should I do?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Container(
                    width: double.infinity,
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang == "ar"
                            ? ' الرجاء الاتصال بخدمة العملاء وتزويدهم برقم الطلبية.'
                            : 'Please contact to customer service and provide them with the order number'),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Container(
                    child: Text(
                      lang == "ar" ? 'هل يمكنني التواصل معكم؟ و كيف؟' : 'If you make a purchase but did not get an order number?',
                    ),
                  ),
                  theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                  expanded: Wrap(
                    children: [
                      Text(lang == "ar"
                          ? 'نعم بإمكانك التواصل من 9 صباحا الى 6 مساءا من الأحد الى الخميس. خلال الرقم /966567302710+ او الايميل/ contact@jawhara.online'
                          : 'You can check your e-mail, email us or contact us .'),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              if (lang == "en")
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandablePanel(
                    header: Container(
                      child: Text(
                        'Where do I find product specifications?',
                      ),
                    ),
                    theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                    expanded: Wrap(
                      children: [
                        Text('You can see the specifications below the product (description - specifications - comments).'),
                      ],
                    ),
                  ),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              if (lang == "en")
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandablePanel(
                    header: Container(
                      child: Text(
                        'How can I communicate with you?',
                      ),
                    ),
                    theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                    expanded: Wrap(
                      children: [
                        Text(
                            'Yes, you can communicate from 9 am to 6 pm from Sunday to Thursday. Through + 966567302710 Or email at contact@jawhara.online'),
                      ],
                    ),
                  ),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
            ],
          )
          // WebView(
          //   initialUrl: 'about:blank',
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (WebViewController webViewController) {
          //     _controller = webViewController;
          //     _controller.loadUrl(Uri.dataFromString(
          //         faqWebDiv.replaceAll("<body>",
          //                 "<body dir=\"${lang == "ar" ? "rtl" : "ltr"}\">"),
          //             mimeType: 'text/html',
          //             encoding: Encoding.getByName('utf-8'))
          //         .toString());
          //   },
          // ),
          ),
    );
  }
}
