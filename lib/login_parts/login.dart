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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
      ),

      body: Center(
        child: Column(
//           mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "ログイン",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
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
                decoration: const InputDecoration(labelText: "パスワード（8～20文字）"),
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
                          return Home(user!);
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
          ],
        ),
      ),

      // 画面下にボタンの配置
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            minWidth: 350.0,
            // height: 100.0,
            child: ElevatedButton(
                child: const Text(
                  'アカウントを作成する',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // ボタンクリック後にアカウント作成用の画面の遷移する。
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => const Registration(),
                    ),
                  );
                }),
          ),
        ),
      ]),
    );
  }
}
