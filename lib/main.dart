import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

import 'core/config/locator.dart';
import 'view/index.dart';
import 'dart:io' show Platform;

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // await FCMConfig.instance.init();
  print('Handling a background message ${message.messageId}');
  // BotToast.showText(
  //   text: 'A new onMessageOpenedApp event was published!',
  //   borderRadius: BorderRadius.all(Radius.circular(10)),
  //   contentColor: Colors.green,
  //   contentPadding: EdgeInsets.all(10),
  // );
  // selectNotification(jsonEncode(message.data));
  // try {
  //   await showDialog<void>(
  //     context: navigatorKey.currentState.context,
  //     barrierDismissible: false,
  //     // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Text(message.notification.title),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(translate('ok')),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }catch(e){
  //   print(e.toString());
  // }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

/// Initialize the [FlutterLocalNotificationsPlugin] package.
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await FCMConfig.instance.init(
      defaultAndroidForegroundIcon: '@mipmap/ic_launcher', //default is @mipmap/ic_launcher
      defaultAndroidChannel: AndroidNotificationChannel(
        'high_importance_channel', // same as value from android setup
        'Fcm config',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification'),
      ),
      onBackgroundMessage: _firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  try {
    var token = await FirebaseMessaging.instance.getToken();
    print('FCM Token :: $token');
  } catch (e) {
    print(e.toString());
  }

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  //Status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Get it
  setupLocator();
  // Translate localizations
  var delegate = await LocalizationDelegate.create(
      preferences: TranslatePreferences(), fallbackLocale: (Platform?.localeName?.split('_')[0]) ?? 'ar', supportedLocales: ['ar', 'en']);
  SharedPreferences _pref = await SharedPreferences.getInstance();
  SharedData.lang = _pref.get('selected_locale') ?? (Platform?.localeName?.split('_')[0]) ?? 'ar';
  if (SharedData.lang == 'en') {
    SharedData.currency = 'SAR';
  } else {
    SharedData.currency = "ر.س";
  }
  print('SharedData.lang  => ${SharedData.lang}');
  // MyApp
  runApp(LocalizedApp(delegate, MyApp()));
}
