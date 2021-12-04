import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
// 日時
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import 'fcm_page.dart';

// jsonのパース先
class ImageData {
  final String date; //日時取得後で変える！！！[あやか]
  final String filename;
  final String id;
  final String user_id;

  // 宣言時にデータを入れる
  ImageData(
      {required this.date,
      required this.filename,
      required this.id,
      required this.user_id});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    var datelist = json["date"].split(" ");
    var daylist = datelist[0].split("-");
    var time = datelist[1].split(".");
    String date =
        daylist[0] + "年" + daylist[1] + "月" + daylist[2] + "日" + time[0];
    return ImageData(
      date: date,
      filename: json["filename"],
      id: json["id"],
      user_id: json["user_id"],
    );
  }
}

Future<List<ImageData>> _handleHttpGetImage(String ACCESS_TOKEN) async {
  var url = Uri.parse('http://192.168.10.102:8080/image/test'); // あやかさんのローカル
  //var url = Uri.parse('http://192.168.32.165:8080/image/test'); // たがいのローカル

  // var response = await http.get(url, headers: {
  //   "Content-Type": "application/json",
  //   "Accept": "application/json",
  //   "Authrorization": ACCESS_TOKEN
  // });
  var response = await http.get(url);
  List<ImageData> imagedatas = [];
  if (response.statusCode == 200) {
    // var jsonResponse =
    //     convert.jsonDecode(response.body) as Map<String, dynamic>;
    // var itemCount = jsonResponse['totalItems'];
    // print('Number of books about http: $itemCount.');
    var decodedJson = json.decode(response.body)["images"] as List;
    // ImageData student = new Map<String, dynamic>.fromJson(decodedJson);

    //Map<String, dynamic> decodedJson = json.decode(response.body)["images"];

    imagedatas = decodedJson.map((i) => ImageData.fromJson(i)).toList();
    imagedatas.forEach((ImageData item) {
      print(item.filename);
    });
    //decodedJson.forEach(
    //    (key, value) => imagedatas.add(ImageData.fromJson(decodedJson[key])));
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return imagedatas;
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
  late List<ImageData> imagedatas = [];
  // ここにサーバから取得した画像データが入ります
  // imagedata[index].filenameでファイル名が取得できます
  _currentDate() {
    return DateFormat("yyyy年 MM月 dd日").format(DateTime.now()) +
        "（" +
        DateFormat.EEEE('ja').format(DateTime.now())[0] +
        "）";
  }

  _currentTime() {
    return DateFormat("hh : mm : ss").format(DateTime.now());
  }

  _getimagedatas() async {
    imagedatas = await _handleHttpGetImage(widget.token);
    print(imagedatas.toString());
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
    _getimagedatas();
  }

  @override
  Widget build(BuildContext context) {
    var grid = [
      "IMG_9313.PNG",
      "IMG_9419.JPG",
      "IMG_9506.jpg",
      "IMG_9507.JPG",
      "IMG_9313.PNG",
      "IMG_9419.JPG",
      "IMG_9506.jpg",
      "IMG_9507.JPG",
      "IMG_9313.PNG",
      "IMG_9419.JPG",
      "IMG_9506.jpg",
      "IMG_9507.JPG",
      "IMG_9313.PNG",
      "IMG_9419.JPG",
      "IMG_9506.jpg",
      "IMG_9507.JPG"
    ]; //　タブバー/一覧/一覧させるテスト画像を入れてる
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    //animation = Tween(begin: -0.5, end: 0.5).animate(animation);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                text: '一覧',
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

                // fit: BoxFit.contain,

                height: 45,
                width: 200,

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
        body: Stack(
          children: <Widget>[
            Container(color: Colors.amber[50]), // 背景色の設定
            TabBarView(
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
                      const Center(child: CircularProgressIndicator()),
                      Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: 'http://192.168.10.102:8080/download',
                        ),

                        // Image.network(
                        //   'http://192.168.10.102:8080/download',
                        //   fit: BoxFit.fill,
                        // ),
                        // ここここここあああああああああああああやかさんのローカル
                        // Image.network(
                        //     'http://192.168.32.165:8080/download'), // たがいのローカル
                        // Image.network('http://133.51.76.11:8080/download?path=' +
                        //     imagedatas[0].filename), // ここにタブバー/一覧者の最新の画像が入ります(のっちまんオレンジ彼女）
                      )
                    ],
                  ),
                ),
                //SingleChildScrollView(
                //　タブバー/一覧/一覧表示の処理
                Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0), //全体padding
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //2画面表示
                            crossAxisSpacing: 10.0, //画像と画像の間のスペース(左右)
                            mainAxisSpacing: 10.0, //画像と画像の間のスペース(上下)
                            childAspectRatio: 0.8, // 高さ
                          ),
                          itemCount: imagedatas
                              .length, //gridView.builderに itemCountパラメータを入れてアイテム数を認識できるようにする
                          itemBuilder: (BuildContext context, int index) {
                            //itemBuilderは画像表示時に実行され無限にグリッド作れる
                            //サーバーから返ってくる画像URLをリストに入れ, for文でリスト表示させる
                            // if (index >= grid.length) {
                            //   // grid.addAll(["IMG_9313.PNG", "IMG_9313.PNG"]);
                            // }
                            return _photoItem(
                                context,
                                imagedatas[index].filename,
                                imagedatas[index].date); //画像ファイル名、撮影日時を取得
                          }),
                    ),
                  ],
                ),
                //),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () => _handleHttpGetImage(widget.token),
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ),
          ], // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}

Widget _photoItem(BuildContext context, String image, String date) {
  var assetsImage = //"assets/images/"
      "http://192.168.10.102:8080/download?path=" + image; // あやかさんのローカル
  //"http://192.168.32.165:8080/download?path=" + image; // たがいのローカル
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        new BoxShadow(
          color: Colors.grey,
          offset: new Offset(5.0, 5.0), //影の表示
          blurRadius: 10.0, //ボケ感
        )
      ],
    ),
    child: Column(

        //grid一塊をcolumnとする
        crossAxisAlignment: CrossAxisAlignment.start, //左寄せにされる
        children: <Widget>[
          //ここのマテリアル部分を画面を遷移させる処理（＝画像をタップしたら拡大画面にいける）
          Material(
            //color: Colors.teal[100],
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePageDetail(assetsImage, date)));
              }, //tapした時のイベントを記載

              child: ClipRRect(
                child: AspectRatio(
                    aspectRatio: 18.0 / 16.5, //写真のアスペクト比
                    child: Image.network(
                      assetsImage,
                      fit: BoxFit.cover,
                    )
                    // child: Image.asset(
                    //   assetsImage,
                    //   fit: BoxFit.cover,
                    ),
              ),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    date,
                    textAlign: TextAlign.center,
                  ))
                ], //時間取得する！！！！！！！
              ),
            ],
          ),
        ]),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              '',
            ),
            Text(
              '',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//タブバー/一覧/画面遷移2枚目の処理
@override
class MyHomePageDetail extends StatefulWidget {
  MyHomePageDetail(this._imageName, this.date);
  final String _imageName;
  final String date;

  @override
  _MyHomePageDetailState createState() =>
      new _MyHomePageDetailState(_imageName, date);
}

class _MyHomePageDetailState extends State<MyHomePageDetail> {
  _MyHomePageDetailState(
    this._imageName,
    this.date,
  );
  final String _imageName;
  final String date;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("画像の拡大表示"),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(_imageName),
              Container(
                child: ListTile(
                  title: Text("来訪日時"),
                  subtitle: Text(date),
                ),
              )
            ],
          ),
        ));
  }
}
