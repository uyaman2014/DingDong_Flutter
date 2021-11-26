import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'login_parts/login.dart';

Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  //print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP');
  await Firebase.initializeApp();
  // fcm_configパッケージを初期化
  FCMConfig.instance.init(
    onBackgroundMessage: _fcmBackgroundHandler,
    defaultAndroidChannel: const AndroidNotificationChannel(
      'high_importance_channel', // same as value from android setup
      'Fcm config',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.amber[50],
      ),
      home: const Login(),
      // home: const DefaultTabController(
      //   length: 2,
      //   child: MyHomePage(title: 'DingDong'),
      // ),
    );
  }
}
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key)
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const DefaultTabController(
//         length: 2,
//         child: MyHomePage(title: 'DingDong'),
//       ),
//     );
//   }
// }
