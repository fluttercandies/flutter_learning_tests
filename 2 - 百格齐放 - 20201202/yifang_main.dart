import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
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
  List<int> upRatio = <int>[2, 5, 8, 3, 6, 9, 1, 4, 7];
  List<List<int>> radioList = [];
  int belowCount = 7;

  @override
  void initState() {
    super.initState();
    //初始化比例数组
    for (final int radio in upRatio) {
      radioList.add(<int>[radio, 10 - radio]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _upList() {
    //支持总条数为 m，且每条比例条的区域数为 n 的比例条，并要求每个区域的比例均可以通过数组控制；

    final List<Widget> tList = [];
    for (final List<int> list in radioList) {
      tList.add(
        Expanded(
          child: Column(
            children: _item(list),
          ),
        ),
      );
    }
    return tList;
  }

  List<Widget> _item(List<int> list) {
    final List<Widget> itemList = [];
    for (int i = 0; i < list.length; i++) {
      itemList.add(
        Expanded(
          child: Container(
            color: RandomColor.getColor(),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                list[i].toString(),
              ),
            ),
          ),
          flex: list[i],
        ),
      );
    }
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: MediaQuery.of(context).orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(
            child: Row(
              children: _upList(),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                print('maxHeight: ${constraints.maxHeight}');
                print('maxWidth: ${constraints.maxWidth}');
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: SPainter(belowCount),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RandomColor {
  const RandomColor._();

  static final math.Random _random = math.Random();

  static Color getColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
    );
  }
}

class SPainter extends CustomPainter {
  SPainter(this.count);

  int count;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final double h = size.height;
    final double w = size.width;
    final double divWidth = w / (count + 1);
    final double divHeight = h / (count + 1);
    // //辅助线
    // for(int i = 1; i <= count; i++){
    //   final double dy = divHeight * i;
    //   canvas.drawLine(Offset(0, dy), Offset(w, dy), paint);
    // }
    // for(int i = 1; i <= count; i++){
    //   final double dx = divWidth * i;
    //   canvas.drawLine(Offset(dx, 0), Offset(dx, h), paint);
    // }
    paint.style = PaintingStyle.fill;
    //从左上到右下
    for (int i = 1; i <= count; i++) {
      paint.color = RandomColor.getColor();
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(divWidth * i, divHeight * i),
          width: divWidth * 2,
          height: divHeight * 2,
        ),
        paint,
      );
    }
    //从右上到左下
    for (int i = 1; i <= count; i++) {
      paint.color = RandomColor.getColor();
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(divWidth * (count + 1 - i), divHeight * i),
          width: divWidth * 2,
          height: divHeight * 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
