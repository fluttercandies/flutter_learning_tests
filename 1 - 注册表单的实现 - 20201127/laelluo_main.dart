import 'package:flutter/material.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController usernameController;
  TextEditingController passwordController;

  /// 使用`ValueNotifier`和`ValueListenableBuilder`实现局部刷新
  ValueNotifier<bool> obscureTextState;
  ValueNotifier<bool> canSubmitState;
  ValueNotifier<bool> loadingState;
  ValueNotifier<String> usernameState;
  ValueNotifier<String> passwordState;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    usernameController.addListener(canSubmitUpdateListener);
    passwordController = TextEditingController();
    passwordController.addListener(canSubmitUpdateListener);
    obscureTextState = ValueNotifier(true);
    canSubmitState = ValueNotifier(false);
    loadingState = ValueNotifier(false);
    usernameState = ValueNotifier('');
    passwordState = ValueNotifier('');
  }

  @override
  void dispose() {
    usernameController.removeListener(canSubmitUpdateListener);
    passwordController.removeListener(canSubmitUpdateListener);
    usernameController.dispose();
    passwordController.dispose();
    obscureTextState.dispose();
    canSubmitState.dispose();
    loadingState.dispose();
    usernameState.dispose();
    passwordState.dispose();
    super.dispose();
  }

  void canSubmitUpdateListener() {
    canSubmitState.value = usernameController.text.isNotEmpty &&
        passwordController.text.length >= 8 &&
        passwordController.text.characters.toSet().length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              usernameTextField,
              passwordTextField,
              submitButton,
              usernameRichText,
              passwordRichText,
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<String> get passwordRichText {
    return ValueListenableBuilder(
      valueListenable: passwordState,
      builder: (BuildContext context, String value, Widget child) {
        return Text.rich(TextSpan(
          text: '密码：',
          children: [
            TextSpan(
              text: value.isEmpty ? '未填写' : value,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ));
      },
    );
  }

  ValueListenableBuilder<String> get usernameRichText {
    return ValueListenableBuilder(
      valueListenable: usernameState,
      builder: (BuildContext context, String value, Widget child) {
        return Text.rich(TextSpan(
          text: '用户名：',
          children: [
            TextSpan(
              text: value.isEmpty ? '未填写' : value,
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ));
      },
    );
  }

  ValueListenableBuilder<bool> get submitButton {
    return ValueListenableBuilder(
      valueListenable: canSubmitState,
      builder: (BuildContext context, bool value, Widget child) {
        VoidCallback onPressed;
        if (value) {
          onPressed = () {
            if (loadingState.value) return;
            loadingState.value = true;
            Future.delayed(
              Duration(seconds: 3),
              () => loadingState.value = false,
            );
            usernameState.value = usernameController.text;
            passwordState.value = passwordController.text;
          };
        } else {
          onPressed = null;
        }
        return RaisedButton(
          child: ValueListenableBuilder(
            valueListenable: loadingState,
            builder: (BuildContext context, bool value, Widget child) {
              if (value)
                return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white));
              return child;
            },
            child: Text('登陆'),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: onPressed,
        );
      },
    );
  }

  ValueListenableBuilder<bool> get passwordTextField {
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget child) {
        return TextField(
          controller: passwordController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: '请输入密码',
            suffixIcon: IconButton(
              icon: Icon(value ? Icons.visibility_off : Icons.visibility),
              onPressed: () => obscureTextState.value = !obscureTextState.value,
            ),
          ),
          obscureText: value,
        );
      },
      valueListenable: obscureTextState,
    );
  }

  TextField get usernameTextField {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.supervisor_account),
        hintText: '请输入用户名',
        suffixIcon: ValueListenableBuilder(
          valueListenable: usernameController,
          builder:
              (BuildContext context, TextEditingValue value, Widget child) {
            if (value.text.isEmpty) return SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.close),
              onPressed: () => usernameController.clear(),
            );
          },
        ),
      ),
    );
  }
}
