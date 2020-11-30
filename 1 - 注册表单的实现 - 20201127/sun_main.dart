import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Test'),
      // RegisterPage(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("首页"),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.supervisor_account),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "请输入用户名",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                CupertinoButton(
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ],
            ),
            Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.lock),
                ),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    obscureText: true,
                    onChanged: ((v) {
                      print("value: $v");
                    }),
                    decoration: InputDecoration(
                      hintText: "请输入密码",
                      border: InputBorder.none,
                      // prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                CupertinoButton(
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ],
            ),
            CupertinoButton(
              onPressed: () {},
              child: Text("登录"),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 是否展示密码
  bool _isOpen = false;
  bool _isShowContent = false;
  bool _isLoginEnabled = false;
  TextEditingController _userCtrl = new TextEditingController();
  TextEditingController _pwdCtrl = new TextEditingController();

  void _login() {
    if (!_isLoginEnabled) {
      return;
    }
    setState(() {
      _isShowContent = true;
    });
  }

  void _openEye() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _changed(String v) {
    setState(() {
      if (_userCtrl.text.isEmpty && _pwdCtrl.text.length < 8) {
        _isLoginEnabled = false;
      } else {
        _isLoginEnabled = true;
      }
    });
    print('$v');
  }

  @override
  Widget build(BuildContext context) {
    String v;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("首页"),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.supervisor_account),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _userCtrl,
                    decoration: InputDecoration(
                      hintText: "请输入用户名",
                      border: InputBorder.none,
                    ),
                    // onChanged: ((v) {
                    //   // print("value: $v");
                    //   setState(() {
                    //     if (_userCtrl.text.isEmpty ||
                    //         _pwdCtrl.text.length < 8) {
                    //       _isLoginEnabled = false;
                    //     } else {
                    //       _isLoginEnabled = true;
                    //     }
                    //   });
                    // }),
                    onChanged: _changed,
                  ),
                ),
                CupertinoButton(
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _userCtrl.text = "";
                    }),
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 35, right: 10, top: 0),
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.lock),
                ),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    controller: _pwdCtrl,
                    obscureText: _isOpen ? false : true,
                    onChanged: (v) => _changed(v),
                    decoration: InputDecoration(
                      hintText: "请输入密码",
                      border: InputBorder.none,
                      // prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Icon(
                    _isOpen ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _openEye,
                ),
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 35, right: 10),
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.only(top: 10),
              child: CupertinoButton(
                onPressed: _login,
                child: Text("登录"),
                color: _isLoginEnabled ? Colors.blue : Colors.grey,
              ),
            ),

            // result
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                _isShowContent
                    ? (_userCtrl.text.isEmpty
                        ? "用户名:未填写"
                        : "用户名:" + _userCtrl.text)
                    : "",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),

            Text(
              _isShowContent
                  ? ((_pwdCtrl.text.length < 8)
                      ? "密码要大于8位"
                      : "密码:" + _pwdCtrl.text)
                  : "",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
