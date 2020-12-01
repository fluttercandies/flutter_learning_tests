// import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  bool passflag = true;
  bool canSub = false;
  bool isSub = false;
  bool subEnd = false;
  String name = '';
  String password = '';
  String userErr;
  String passErr;
  Timer timer;
  List passlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                child: Column(children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(Icons.supervisor_account),
                  new Container(
                    width: 350,
                    margin: EdgeInsets.only(left: 20.0),
                    child: new TextField(
                      obscureText: false,
                      onSubmitted: (val) => {
                        this.setState(() {
                          name = val;
                          subEnd = false;
                        })
                      },
                      controller: new TextEditingController(text: name),
                      decoration: InputDecoration(
                          errorText:
                              name.replaceAll(" ", '') == "" ? "用户名不能为空" : null,
                          hintText: "请输入用户名",
                          suffixIcon: name != ''
                              ? InkWell(
                                  child: Icon(Icons.close),
                                  onTap: () => {
                                        this.setState(() {
                                          name = '';
                                        })
                                      })
                              : null),
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(Icons.lock),
                  Container(
                    width: 350,
                    margin: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: passflag,
                      onSubmitted: (val) => {
                        passlist = [],
                        for (var i = 0; i < val.length; i++)
                          {
                            if (passlist.indexOf(val[i]) == -1 &&
                                passlist.length < 6)
                              {passlist.add(val[i])}
                          },
                        if (val.length > 7 && val.length < 20)
                          {
                            if (passlist.length == 6)
                              {
                                {
                                  this.setState(() {
                                    password = val;
                                    subEnd = false;
                                    passErr = null;
                                  })
                                }
                              }
                            else
                              {
                                this.setState(() {
                                  password = val;
                                  subEnd = false;
                                  passErr = '请输入6位以上不同字符组成的密码';
                                })
                              }
                          }
                        else
                          {
                            this.setState(() {
                              password = val;
                              subEnd = false;
                              passErr = "请输入8-20位的密码";
                            })
                          }
                      },
                      controller: new TextEditingController(text: password),
                      decoration: InputDecoration(
                        hintText: "请输入密码",
                        errorText: passErr,
                        suffixIcon: InkWell(
                            child: passflag
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onTap: () => {
                                  this.setState(() {
                                    passflag = !passflag;
                                  })
                                }),
                      ),
                    ),
                  ),
                ],
              ),
            ])),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: !isSub
                    ? RaisedButton(
                        color: name != "" && passErr == null
                            ? Colors.lightBlue
                            : Colors.grey,
                        onPressed: () => {
                          if (name != "" && passErr == null)
                            {
                              this.setState(() {
                                isSub = true;
                              }),
                              timer = new Timer(new Duration(seconds: 3), () {
                                this.setState(() {
                                  isSub = false;
                                  subEnd = true;
                                });
                              }),
                            }
                        },
                        child: Text("登录"),
                      )
                    : CupertinoActivityIndicator()),
            Column(
              children: [
                Row(
                  children: [
                    Text("用户名:"),
                    Text(
                      name != "" && subEnd ? name : "未填写",
                      style: TextStyle(decoration: TextDecoration.underline),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("密码:"),
                    Text(password != "" && subEnd ? password : "未填写",
                        style: TextStyle(fontStyle: FontStyle.italic))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
