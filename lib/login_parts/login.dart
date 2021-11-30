import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'authentication_error.dart';
import 'registration.dart';
import '../home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<Login> {
  String login_Email = ""; // 入力されたメールアドレス
  String login_Password = ""; // 入力されたパスワード
  String infoText = ""; // ログインに関する情報を表示

  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  //FirebaseAuth result;
  // FirebaseUser user;

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error();
  late String token = "";

  Future<String> test() async {
    String idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    return Future<String>.value(idToken);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace =
        MediaQuery.of(context).viewInsets.bottom; // キーボードの表示分Bottomを確保する
    return Scaffold(
      resizeToAvoidBottomInset: false, // 自動で高さ対応
      body: SingleChildScrollView(
        reverse: true, // スクロールを逆にする（上向き）
        child: Container(
          padding: EdgeInsets.only(bottom: bottomSpace),
          color: Colors.amber,
          child: Column(
//           mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 75, 0, 30),
                    child: Image.asset(
                      'assets/D.png',
                      height: 135,
                      //color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: SvgPicture.asset(
                      'assets/Dingding-logo.svg',
                      fit: BoxFit.contain,
                      height: 65,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    color: Colors.lime[900],
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Text(
                      "家の中でも訪問者を見逃さない",
                      style: TextStyle(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 5.0,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Text(
                        "- E-mailでログイン -",
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        "アカウントをお持ちの方はこちらから",
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // メールアドレスの入力フォーム
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        onChanged: (String value) {
                          login_Email = value;
                        },
                      )),

                  // パスワードの入力フォーム
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: "パスワード（8～20文字）"),
                      obscureText: true, // パスワードが見えないようRにする
                      maxLength: 20, // 入力可能な文字数
                      maxLengthEnforcement:
                          MaxLengthEnforcement.none, // 入力可能な文字数の制限を超える場合の挙動の制御
                      onChanged: (String value) {
                        login_Password = value;
                      },
                    ),
                  ),

                  // ログイン失敗時のエラーメッセージ
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                    child: Text(
                      infoText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                  ButtonTheme(
                    minWidth: 350.0,
                    // height: 100.0,
                    child: ElevatedButton(
                        child: const Text(
                          'ログイン',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          try {
                            // メール/パスワードでログイン
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            UserCredential result =
                                await auth.signInWithEmailAndPassword(
                              email: login_Email,
                              password: login_Password,
                            );

                            User? user = result.user;
                            //print(user!.uid);
                            // ログインに成功した場合
                            // チャット画面に遷移＋ログイン画面を破棄
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                test().then((String result) {
                                  setState(() {
                                    token = result;
                                    print(token);
                                  });
                                });
                                return Home(token: "aa");
                              }),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' ||
                                e.code == 'wrong-password') {
                              setState(() {
                                infoText = "メールアドレスかパスワードが間違っています";
                              });
                            } else if (e.code == 'too-many-requests') {
                              setState(() {
                                infoText = "回線が混み合っています．時間が経ってから再度お試しください．";
                              });
                            } else {
                              setState(() {
                                infoText = "正しいメールアドレスとパスワードを入力してください．";
                              });
                            }
                          }
                        }),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    color: Colors.amber[100],
                    // height: 100.0,
                    child: TextButton(
                        // 角丸くしたい
                        child: const Text(
                          'アカウントを作成する',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),

                        // ボタンクリック後にアカウント作成用の画面の遷移する。
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  const Registration(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
