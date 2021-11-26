import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'fcm_page.dart';

// 日時
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  // 引数からユーザー情報を受け取れるようにする
  const Home(this.token, {Key? key}) : super(key: key);
  // ユーザー情報
  final String token;

  @override
  Widget build(BuildContext context) {
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
                  SelectableText(token),
                  Container(
                    height: 100,
                    margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('yyyy年mm月dd日 \n hh：mm').format(DateTime.now()),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lime,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
