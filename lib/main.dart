import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_core/firebase_core.dart';

import 'fcm_page.dart';

// 日時
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP');
  await Firebase.initializeApp();
  // fcm_configパッケージを初期化
  FCMConfig.instance.init(
    onBackgroundMessage: _fcmBackgroundHandler,
    defaultAndroidChannel: AndroidNotificationChannel(
      'high_importance_channel', // same as value from android setup
      'Fcm config',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.amber[50],
      ),
      //home: FcmPage(),
      home: const DefaultTabController(
        length: 2,
        child: MyHomePage(title: 'DingDong'),
      ),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.amber,
        bottom: const TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 7.5,
          unselectedLabelColor: Colors.white30,
          tabs: [
            Tab(
              height: 100,
              text: '来訪者',
              icon: Icon(
                Icons.doorbell_rounded,
                size: 60,
              ),
            ),
            Tab(
              height: 100,
              text: '分析',
              icon: Icon(
                Icons.assessment,
                size: 60,
              ),
            ),
          ],
        ),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/Dingding-logo.svg',
              fit: BoxFit.contain,
              height: 45,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              // （1） 指定した画面に遷移する
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // （2） 実際に表示するページ(ウィジェット)を指定する
                      builder: (context) => const FcmPage()));
            },
          ),
        ],
      ),
      body: TabBarView(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('yyyy年mm月dd日 \n hh：mm').format(DateTime.now()),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lime,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.black12,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                Image.network(
                    'https://picsum.photos/250?image=9'), // ここに最新の画像が入ります
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Hey'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
