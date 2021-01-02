import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginHomePage(title: 'Login Page'),
    );
  }
}

class LoginHomePage extends StatefulWidget {
  LoginHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> usernameCloseValue = ValueNotifier<bool>(true);
  final ValueNotifier<bool> passwordHiddenValue = ValueNotifier<bool>(true);
  final ValueNotifier<bool> textShowValue = ValueNotifier<bool>(false);
  final ValueNotifier<bool> buttonEnabled = ValueNotifier<bool>(false);

  void checkInputText() {
    buttonEnabled.value = (usernameController.text.isNotEmpty &&
        passwordController.text.length >= 8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 15, right: 15),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: usernameController,
              decoration: InputDecoration(
                hintText: '请输入用户名',
                prefixIcon: Icon(Icons.supervisor_account),
                suffix: usernameCloseValue.value
                    ? SizedBox.shrink()
                    : TextSuffixButton(
                        suffixIcon: Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                        clearTextTap: () {
                          usernameController.text = '';
                          setState(() {});
                        }),
              ),
              onChanged: (String text) {
                checkInputText();
                usernameCloseValue.value = text.length == 0;
                setState(() {});
              },
            ),
            TextField(
              controller: passwordController,
              obscureText: passwordHiddenValue.value,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("[a-zA-Z]|[0-9]"),
                    allow: true),
              ],
              decoration: InputDecoration(
                hintText: '请输入密码',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: passwordHiddenValue.value
                    ? TextSuffixButton(
                        suffixIcon: Icon(
                          Icons.visibility,
                        ),
                        clearTextTap: () {
                          print('open');
                          passwordHiddenValue.value = false;
                          setState(() {});
                        })
                    : TextSuffixButton(
                        suffixIcon: Icon(Icons.visibility_off),
                        clearTextTap: () {
                          print('hidden');
                          passwordHiddenValue.value = true;
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (String text) {
                checkInputText();
                setState(() {});
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: GestureDetector(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  color: buttonEnabled.value ? Colors.blue : Colors.grey,
                  child: Text(
                    '登录',
                  ),
                ),
                onTap: buttonEnabled.value
                    ? () {
                        textShowValue.value = true;
                        setState(() {});
                      }
                    : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 46),
              child: textShowValue.value
                  ? Text(
                      '用户名：' +
                          (usernameController.text.isEmpty
                              ? '未填写'
                              : usernameController.text),
                    )
                  : SizedBox.shrink(),
            ),
            textShowValue.value
                ? Text(
                    '密码：' +
                        (passwordController.text.isEmpty
                            ? '未填写'
                            : passwordController.text),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class TextSuffixButton extends StatelessWidget {
  const TextSuffixButton({
    Key key,
    @required this.suffixIcon,
    @required this.clearTextTap,
  })  : assert(suffixIcon != null),
        assert(clearTextTap != null),
        super(key: key);

  final Icon suffixIcon;
  final Function clearTextTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: suffixIcon,
      onTap: () {
        clearTextTap();
      },
    );
  }
}
