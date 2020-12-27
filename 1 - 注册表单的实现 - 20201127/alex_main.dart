import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestTextFieldPage(),
    );
  }
}

class TestTextFieldPage extends StatefulWidget {
  const TestTextFieldPage({Key? key}) : super(key: key);

  @override
  _TestTextFieldPageState createState() => _TestTextFieldPageState();
}

class _TestTextFieldPageState extends State<TestTextFieldPage> {
  final TextEditingController usernameController = TextEditingController();
  final ValueNotifier<String> usernameNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> passwordNotifier = ValueNotifier<String>('');
  final ValueNotifier<bool> isLoginNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isObscureNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    // 所有监听需要在 dispose 时销毁。
    usernameController.dispose();
    usernameNotifier.dispose();
    passwordNotifier.dispose();
    isLoginNotifier.dispose();
    isObscureNotifier.dispose();
    super.dispose();
  }

  /// 通过所有的数据，判断是否可以登录
  bool canLogin(String username, String password, bool isLogin) {
    return username.isNotEmpty && // 用户名不为空
        password.length >= 8 && // 密码长度超过 8 位
        password.codeUnits.toSet().length >= 6 && // 密码复杂度超过 6
        !isLogin; // 未在登录
  }

  /// 登录操作
  ///
  /// 延时三秒后切换回未登录状态
  void login() {
    isLoginNotifier.value = true;
    Future<void>.delayed(const Duration(seconds: 3), () {
      isLoginNotifier.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ValueListenableBuilder<String>(
            valueListenable: usernameNotifier,
            builder: (_, String u, __) => TextField(
              decoration: InputDecoration(
                hintText: '请输入用户名',
                icon: const Icon(Icons.supervisor_account),
                suffixIcon: u.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          // 通过 controller 清除内容
                          usernameController.clear();
                          // 清除时不会触发 onChanged，所以手动设置
                          // 当然，如果通过 controller 设置新值是可以触发的
                          usernameNotifier.value = '';
                        },
                        child: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (String u) => usernameNotifier.value = u,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isObscureNotifier,
            builder: (_, bool isObscure, __) => TextField(
              decoration: InputDecoration(
                hintText: '请输入密码',
                icon: const Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    isObscureNotifier.value = !isObscureNotifier.value;
                  },
                  child: const Icon(Icons.visibility),
                ),
              ),
              obscureText: isObscure,
              onChanged: (String p) => passwordNotifier.value = p,
            ),
          ),
          ValueListenableBuilder3<String, String, bool>(
            firstNotifier: usernameNotifier,
            secondNotifier: passwordNotifier,
            thirdNotifier: isLoginNotifier,
            builder: (_, String u, String p, bool isLogin, __) {
              return RaisedButton(
                onPressed: canLogin(u, p, isLogin) ? login : null,
                color: Theme.of(context).accentColor,
                child: isLogin
                    ? const CircularProgressIndicator()
                    : const Text('登录'),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 将三个 [ValueNotifier] 整合在一起的 builder widget。套中套中套。
class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  const ValueListenableBuilder3({
    Key? key,
    required this.firstNotifier,
    required this.secondNotifier,
    required this.thirdNotifier,
    required this.builder,
  }) : super(key: key);

  final ValueNotifier<A> firstNotifier;
  final ValueNotifier<B> secondNotifier;
  final ValueNotifier<C> thirdNotifier;
  final Widget Function(BuildContext, A, B, C, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: firstNotifier,
      builder: (_, A first, __) {
        return ValueListenableBuilder<B>(
          valueListenable: secondNotifier,
          builder: (_, B second, __) {
            return ValueListenableBuilder<C>(
              valueListenable: thirdNotifier,
              builder: (_, C third, __) {
                return builder(context, first, second, third, __);
              },
            );
          },
        );
      },
    );
  }
}
