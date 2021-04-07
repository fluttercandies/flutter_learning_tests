import 'dart:ffi';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int rows = 2;
  int cols = 6;
  List<String> array = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ColoredBox(
        color: Colors.blueGrey,
        child: _pageView(context),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _pageView(BuildContext context) {
    int count = array.length % (rows * cols) == 0
        ? array.length ~/ (rows * cols)
        : array.length ~/ (rows * cols) + 1;
    List<List<String>> subArrays = List<List<String>>();
    for (int i = 0; i < count; i++) {
      int start = i * rows * cols;
      int end = (i + 1) * rows * cols - 1;
      if (end > array.length) {
        end = array.length - 1;
      }
      subArrays.add(array.sublist(start, end + 1));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: PageController(
        initialPage: 0,
        viewportFraction: 1,
        keepPage: true,
      ),
      physics: BouncingScrollPhysics(),
      pageSnapping: true,
      onPageChanged: (index) {
        //监听事件
        print('index=====$index');
      },
      children: subArrays
          .map(
            (e) => Wrap(
              children: e.map((s) => _gridItem(context, title: s)).toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _gridItem(BuildContext context,
      {double width, Image icon, String title, Double height}) {
    double screenW = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        print(title);
      },
      child: Container(
        color: Colors.orange,
        width: screenW / cols,
        height: height ?? (screenW / cols),
        child: Column(
          children: <Widget>[
            Icon(Icons.android),
            Text(title),
          ],
        ),
      ),
    );
  }
}
