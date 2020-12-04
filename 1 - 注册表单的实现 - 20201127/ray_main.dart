import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _accountController;
  TextEditingController _pwdController;
  String account = '未填写';
  String pwd = '未填写';
  bool obscureText = false;
  bool enabled = false;
  bool submitting = false;

  @override
  void initState() {
    _accountController = TextEditingController()..addListener(_checkInput);
    _pwdController = TextEditingController()..addListener(_checkInput);
  }

  void _checkInput() {
    var account = _accountController.text;
    var pwd = _pwdController.text;
    bool enable = account.isNotEmpty && _checkPwd(pwd);
    if (enabled != enable) {
      setState(() {
        enabled = enable;
      });
    }
  }

  bool _checkPwd(String pwd) {
    if (pwd == null || pwd.length < 8) {
      return false;
    }
    return pwd.split('').toSet().length >= 6;
  }

  void _onSubmit() {
    if (submitting) {
      return;
    }
    setState(() {
      submitting = true;
      account = _accountController.text;
      pwd = _pwdController.text;
      Future.delayed(
        Duration(seconds: 3),
      ).then(
        (value) => if (mounted) setState(() {
          submitting = false;
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text(
            '用户名:$account',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          Text(
            '密码:$pwd',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          TextField(
            controller: _accountController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.supervisor_account,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _accountController,
                builder: (_, value, __) {
                  bool empty = value.text.isEmpty;
                  return Visibility(
                    visible: !empty,
                    child: GestureDetector(
                      onTap: () => _accountController.text = '',
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        Icons.close,
                      ),
                    ),
                  );
                },
              ),
              hintText: '请输入用户名',
              border: UnderlineInputBorder(),
            ),
          ),
          TextField(
            controller: _pwdController,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => obscureText = !obscureText),
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              hintText: '请输入密码',
              border: UnderlineInputBorder(),
            ),
          ),
          FlatButton(
            onPressed: enabled ? _onSubmit : null,
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey,
            child: submitting
                ? Container(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.redAccent,
                    ),
                  )
                : Text('登录'),
          ),
        ],
      ),
    );
  }
}
