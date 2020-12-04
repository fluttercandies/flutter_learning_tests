import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController _accountController;
  TextEditingController _codeController;
  String _account = '未填写';
  String _code = '未填写';
  String _errorText;
  bool _empty = true;
  bool _obscureCode = true;
  bool _isLoad = false;
  bool _isConform = false;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    
    _accountController.addListener(_accountListener);
    _codeController.addListener(_codeListener);
  }

  @override
  void dispose() {
    super.dispose();
    _accountController.removeListener(_accountListener);
    _codeController.removeListener(_codeListener);
    _accountController.dispose();
    _codeController.dispose();
  }
  
  void _accountListener(){
    if(_accountController.text == ''){
      if(!_empty){
        setState(() {
          _empty = true;
          _isConform = false;
        });
      }
    } else {
      if(_empty){
        _empty = false;
        setState(() {});
      }
    }
    _codeListener();
  }
  
  void _codeListener(){
    if(!_empty){
      final bool res = _codeVerify(_codeController.text);
      if(res != _isConform){
        setState(() {
          _isConform = res;
        });
      }
    }
  }

  bool _codeVerify(String text){
    if(text.length < 8) return false;
  
    int num = 0;
    String old = '';
    for(int i = 0; i < text.length; i++){
      if(i == 0){
        num++;
        old = text.substring(i, i+1);
      } else if(i <= text.length -1){
        final String s = text.substring(i, i+1);
        if(!old.contains(s)){
          num++;
          old = old + s;
        }
      }
    }
    return num >= 6;
  }
  
  void _login(){
    setState(() {
      _account = _accountController.text;
      _code = _codeController.text;
      _isLoad = true;
    });
    Future.delayed(const Duration(seconds: 3),).then((value){
      if(mounted){
        setState(() {
          _isLoad = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _accountController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                icon: const Icon(Icons.supervisor_account),
                hintText: '请输入用户名',
                suffixIcon: _empty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _accountController.text = '';
                          setState(() {
                            _empty = false;
                            _isConform = false;
                          });
                        },
                ),
              ),
            ),
            TextField(
              controller: _codeController,
              textInputAction: TextInputAction.done,
              obscureText: _obscureCode,
              decoration: InputDecoration(
                icon: const Icon(Icons.lock),
                hintText: '请输入密码',
                errorText: _errorText,
                suffixIcon: IconButton(
                  icon: _obscureCode ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                  onPressed: (){
                    setState(() {
                      _obscureCode = !_obscureCode;
                    });
                  },
                ),
              ),
            ),
            FlatButton(
              onPressed: _isConform ? _login : null,
              child: _isLoad ? const CupertinoActivityIndicator() : const Text('登录'),
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey,
            ),
            Text('用户名: $_account', style: const TextStyle(decoration: TextDecoration.underline),),
            Text('密码: $_code', style: const TextStyle(fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }
}