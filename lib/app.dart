import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jawhara/core/config/connectivity_service.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/ui/auth/forget_password.dart';
import 'package:jawhara/view/ui/auth/verfication_code.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/navigation_bar_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'core/api/common.dart';
import 'view/index.dart';
import 'view/widgets/animated_splash.dart';

final navigatorKey = GlobalKey<NavigatorState>();
bool _initialUriIsHandled = false;

Future selectNotification(String payload) async {
  if (payload != null) {
    try {
      Map payloadMap = jsonDecode(payload);
      debugPrint('notification payload: $payload');
      debugPrint('notification payload: ${jsonDecode(payload)}');
      if (payloadMap["screen"] == 'product_details') {
        try {
          navigatorKey.currentState.push(
            MaterialPageRoute<void>(
                builder: (context) => ProductDetail(
                      product: Product(sku: payloadMap["sku"]),
                    )),
          );
        } catch (e) {
          print(e.toString());
        }
      } else if (payloadMap["screen"] == 'category') {
        Navigator.of(navigatorKey.currentState.context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationBar()), (Route<dynamic> route) => false);
        (MainTabControlDelegate.getInstance().globalKey.currentWidget as BottomNavigationBar).onTap(0);
        locator<HomeViewModel>()
            .spiderFunction(navigatorKey.currentState.context, int.parse(payloadMap["id"]), payloadMap["level"], payloadMap["parentId"]);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin, AfterLayoutMixin<MyApp>, FCMNotificationClickMixin {
  //call BotToastInit
  final botToastBuilder = BotToastInit();
  StreamSubscription _sub;

  @override
  void afterFirstLayout(BuildContext context) async {
    print('SharedData.lang > ${SharedData.lang}');
    if (SharedData.lang == null) {
      changeLocale(context, 'ar');
    }
    // await fetchGif(AssetImage(SharedData.lang == "ar"
    //     ? Strings.kSplashScreen
    //     : Strings.kSplashScreenEn));

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    // // final IOSInitializationSettings initializationSettingsIOS =
    // // IOSInitializationSettings(
    // //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // // final MacOSInitializationSettings initializationSettingsMacOS =
    // // MacOSInitializationSettings();
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: initializationSettingsAndroid,
    // );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: selectNotification);
  }

  // Future onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             // await Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => SecondScreen(payload),
  //             //   ),
  //             // );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print(
    //       'A new onMessage event was published! ${message?.notification?.title}');
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channel.description,
    //             // TODO add a proper drawable resource to android, for now using
    //             //      one that already exists in example app.
    //             // icon: 'launcher_icon',
    //           ),
    //         ),
    //         payload: jsonEncode(message.data));
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // BotToast.showText(
    //   //   text: 'A new onMessageOpenedApp event was published!',
    //   //   borderRadius: BorderRadius.all(Radius.circular(10)),
    //   //   contentColor: Colors.green,
    //   //   contentPadding: EdgeInsets.all(10),
    //   // );
    //   selectNotification(jsonEncode(message.data));
    //   // Navigator.pushNamed(context, '/message',
    //   //     arguments: MessageArguments(message, true));
    // });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri uri) async {
        if (!mounted) return;
        print('got uri: $uri');
        // _latestUri = uri;
        try {
          var parts = uri.path.split("/").where((element) => element.isNotEmpty).toList();
          if (parts.length == 2 && (parts[0] == 'ar' || parts[0] == 'en')) {
            final r = await CommonApi().getSearchItem(navigatorKey.currentState.context, parts[1].replaceAll(".html", ""), lang: parts[0]);
            if (r.items != null && r.items.isNotEmpty) {
              navigatorKey.currentState.push(MaterialPageRoute<void>(
                builder: (BuildContext context) => ProductDetail(product: Product(entityId: r.items[0].id.toString())),
                fullscreenDialog: true,
              ));
            }
          } else if (parts.length == 4 && parts[3] == 'createPassword') {
            SharedPreferences _pref = await SharedPreferences.getInstance();
            String email = _pref.get("emailToBeReset");
            String token = (uri.query != null && uri.query.isNotEmpty && uri.query.split("=").length == 2) ? uri.query.split("=")[1] : null;
            if (token != null && token.isNotEmpty && email != null && email.isNotEmpty) {
              navigatorKey.currentState.push(MaterialPageRoute<void>(
                builder: (BuildContext context) => VerificationCode(email, token: uri.query.split("=")[1]),
                fullscreenDialog: true,
              ));
            } else {
              navigatorKey.currentState.push(MaterialPageRoute<void>(
                builder: (BuildContext context) => ForgetPassword(),
                fullscreenDialog: true,
              ));
            }
          }
        } on Exception catch (e) {
          print(e.toString());
        }
        // _err = null;
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      // _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          try {
            var parts = uri.path.split("/");
            if (parts.length > 2 && (parts[0] == 'ar' || parts[0] == 'en')) {
              final r =
                  await CommonApi().getSearchItem(navigatorKey.currentState.context, parts[1].replaceAll(".html", ""), lang: parts[0]);
              if (r.items != null && r.items.isNotEmpty) {
                navigatorKey.currentState.push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProductDetail(product: Product(entityId: r.items[0].id.toString())),
                  fullscreenDialog: true,
                ));
              }
            } else if (parts.length == 4 && parts[3] == 'createPassword') {
              SharedPreferences _pref = await SharedPreferences.getInstance();
              String email = _pref.get("emailToBeReset");
              String token =
                  (uri.query != null && uri.query.isNotEmpty && uri.query.split("=").length == 2) ? uri.query.split("=")[1] : null;
              if (token != null && token.isNotEmpty && email != null && email.isNotEmpty) {
                navigatorKey.currentState.push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => VerificationCode(email, token: uri.query.split("=")[1]),
                  fullscreenDialog: true,
                ));
              } else {
                navigatorKey.currentState.push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => ForgetPassword(),
                  fullscreenDialog: true,
                ));
              }
            }
          } on Exception catch (e) {
            print(e.toString());
          }
        }
        if (!mounted) return;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('failed to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
      }
    }
  }

  @override
  void onClick(RemoteMessage notification) {
    selectNotification(jsonEncode(notification.data));
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    log('${localizationDelegate.supportedLocales}', name: '${this} # locale');
    Widget getHomePage(AuthViewModel auth) {
      // if (auth.currentUser == null) {
      //   return NavigationBar();
      // } else {
      return AnimatedSplash(
        imagePath: '',
        home: NavigationBar(),
        isGIF: false,
        duration: 2000,
        type: AnimatedSplashType.StaticDuration,
      );
      // }
    }

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationBarViewModel>(
            create: (BuildContext context) => NavigationBarViewModel(),
          ),
          ChangeNotifierProvider<AuthViewModel>(
            create: (BuildContext context) => AuthViewModel(),
          ),
          ChangeNotifierProvider<CartViewModel>(
            create: (BuildContext context) => CartViewModel(),
          ),
          ChangeNotifierProvider<WishListViewModel>(
            create: (BuildContext context) => WishListViewModel(),
          ),
        ],
        child: Consumer<AuthViewModel>(
          builder: (context, value, child) {
            return StreamProvider<ConnectivityStatus>(
              create: (context) => ConnectivityService().connectionStatusController.stream,
              child: MaterialApp(
                title: Strings.APP_NAME,
                theme: themeData,
                home: getHomePage(value),
                builder: (context, child) {
                  child = botToastBuilder(context, child);
                  return child;
                },
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [BotToastNavigatorObserver()],
                //Translate localizations
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  localizationDelegate
                ],
                supportedLocales: localizationDelegate.supportedLocales,
                locale: localizationDelegate.currentLocale,
              ),
            );
          },
        ),
      ),
    );
  }
}
