import 'dart:async';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _visible = false;

  bool _isLogin = false;

  final StreamController<String> _usernameStream =
      StreamController<String>.broadcast();
  final StreamController<String> _passwordStream =
      StreamController<String>.broadcast();

  /// 不知道怎么合并两个流的结果 😄
  final StreamController<bool> _loginStream = StreamController<bool>();

  Timer _loginTimer;

  @override
  void initState() {
    _usernameController.addListener(() {
      _usernameStream.sink.add(_usernameController.text);

      _loginStream.sink.add(_usernameController.text.isNotEmpty &&
          _passwordController.text.length >= 8 &&
          _passwordController.text.split('').toSet().length >= 6);
    });
    _passwordController.addListener(() {
      _passwordStream.sink.add(_passwordController.text);

      _loginStream.sink.add(_usernameController.text.isNotEmpty &&
          _passwordController.text.length >= 8 &&
          _passwordController.text.split('').toSet().length >= 6);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget clearIcon = StreamBuilder<String>(
      stream: _usernameStream.stream,
      builder: (_, AsyncSnapshot<String> snapshot) {
        Widget child = const SizedBox.shrink();

        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          child = IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _usernameController.clear(),
          );
        }

        return child;
      },
    );

    final Widget usernameField = TextField(
      controller: _usernameController,
      maxLength: 20,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.supervisor_account),
        hintText: '请输入用户名',
        counterText: '',
        border: const UnderlineInputBorder(),
        suffixIcon: clearIcon,
      ),
    );

    final Widget visibilityIcon = IconButton(
      icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
      onPressed: () => setState(() => _visible = !_visible),
    );

    final Widget passwordField = StreamBuilder<String>(
      stream: _passwordStream.stream,
      builder: (_, AsyncSnapshot<String> snapshot) {
        String helperText;

        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          if (_passwordController.text.length < 8) {
            helperText = '密码不能少于8位';
          } else if (_passwordController.text.split('').toSet().length < 6) {
            helperText = '密码复杂度不能低于6';
          }
        }

        return TextField(
          controller: _passwordController,
          maxLength: 20,
          obscureText: !_visible,
          style: const TextStyle(fontStyle: FontStyle.italic),
          obscuringCharacter: '*',
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            hintText: '请输入密码',
            counterText: '',
            helperText: helperText,
            border: const UnderlineInputBorder(),
            suffixIcon: visibilityIcon,
            hintStyle: const TextStyle(fontStyle: FontStyle.normal),
          ),
        );
      },
    );

    final Widget loginButton = StreamBuilder<bool>(
      stream: _loginStream.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        bool canLogin = false;
        if (snapshot.hasData) {
          canLogin = snapshot.data;
        }
        return RaisedButton(
          child: _isLogin
              ? const SizedBox(
                  child: CircularProgressIndicator(strokeWidth: 2),
                  width: 20,
                  height: 20,
                )
              : const Text('登录'),
          color: Theme.of(context).primaryColor,
          onPressed: canLogin && !_isLogin
              ? () {
                  setState(() {
                    _isLogin = true;

                    _loginTimer = Timer.periodic(
                      const Duration(seconds: 3),
                      (Timer timer) => setState(() {
                        _isLogin = false;
                        timer.cancel();
                      }),
                    );
                  });
                }
              : null,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            usernameField,
            passwordField,
            loginButton,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameStream.close();
    _passwordStream.close();
    _loginStream.close();
    _loginTimer?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
