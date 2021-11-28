import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'fcm_page.dart';

// 日時
import 'package:intl/intl.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<void> _handleHttpGetImage(String ACCESS_TOKEN) async {
  var url = Uri.https('localhost:8080', '/image', {'q': 'Flutter'});

  var response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authrorization": ACCESS_TOKEN
  });
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var itemCount = jsonResponse['totalItems'];
    print('Number of books about http: $itemCount.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class Home extends StatefulWidget {
  // 以下を実装、受け渡し用のプロパティを定義
  final String token;

  // 以下を実装、コンストラクタで値を受領
  Home({Key? key, required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  _currentDate() {
    return DateFormat("yyyy年 MM月 dd日").format(DateTime.now()) +
        "（" +
        DateFormat.EEEE('ja').format(DateTime.now())[0] +
        "）";
  }

  _currentTime() {
    return DateFormat("hh : mm : ss").format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.reverse();
      } else if (animationController.isDismissed) {
        animationController.forward();
      }
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    //animation = Tween(begin: -0.5, end: 0.5).animate(animation);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                margin: const EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
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
                        builder: (context) => FcmPage()));
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
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        //border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            25.0,
                          ),
                        ),
                        color: Colors.lime,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ]),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                      height: 125,
                      child: Column(
                        children: <Widget>[
                          Text(
                            _currentDate(),
                            style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              _currentTime(),
                              style: const TextStyle(
                                fontSize: 48.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
        floatingActionButton: FloatingActionButton(
          onPressed: () => _handleHttpGetImage(widget.token),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
