import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '注册表单',
      home: new RegisgtForm(),
    );
  }
}

class RegisgtForm extends StatefulWidget {
  const RegisgtForm({Key key}) : super(key: key);
  @override
  createState() => RegisgtFormState();
}

class RegisgtFormState extends State<RegisgtForm> {
  bool isMask = true;
  bool isUser = false;
  bool isPwd = false;
  String userName = '';
  String password = '';
  bool isLogin = false;
  Timer timer;

  Widget buildTextField(TextEditingController controller, String label, Icon icon, [bool obscure]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        labelText: label,
        prefixIcon: icon,
      ),
      obscureText: obscure != null ? obscure : false,
    );
  }

  final controller = TextEditingController();
  final pwdController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      final user = controller.text;
      setState(() {
        userName = user;
        isUser = !user.isEmpty;
      });
      // print('user ${controller.text}');
    });
    pwdController.addListener(() {
      final pwd = pwdController.text;
      RegExp reg = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$");
      setState(() {
        password = pwd;
        isPwd = reg.hasMatch(pwd);
      });
      // print('password ${pwdController.text}');
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('注册表单'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildTextField(controller, '请输入用户名', Icon(Icons.supervisor_account)),
              ),
              Positioned(
                child: Offstage(
                  offstage: !isUser,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    tooltip: 'Clear text',
                    onPressed: () {
                      print('pressed');
                      controller.clear();
                    },
                  ),
                ),
                top: 24,
                right: 20,
              ),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildTextField(pwdController, '请输入密码', Icon(Icons.lock), isMask),
              ),
              Positioned(
                child: IconButton(
                  icon: Icon(Icons.visibility),
                  tooltip: 'visibility',
                  onPressed: _isMask,
                ),
                top: 24,
                right: 20,
              ),
            ],
          ),
          Center(
            child: RaisedButton(
              onPressed: isUser && isPwd ? _confirm : null,
              // child: Text('登录'),
              child: !isLogin ? Text('登录') : Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ),
          Text(isLogin ? userName : ''),
          Text(isLogin ? password : '')
        ]
      )
    );
  }

  _clearUserText (controller) {
    controller.clear();
    print('clear text');
  }

  _isMask () {
    setState(() {
      isMask = !isMask;
    });
    print('whether to show mask ${isMask}');
  }

  _confirm () {
    setState(() {
      isLogin = true;
    });
    timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLogin = false;
      });
    });
  }
}

