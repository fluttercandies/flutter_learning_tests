///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/12/27 14:25
///
import 'dart:math' as math;

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

class BlossomPage extends StatelessWidget {
  const BlossomPage({Key? key}) : super(key: key);

  List<List<int>> get flexLists {
    return <List<int>>[
      <int>[2, 7, 1],
      <int>[4, 3, 1, 2],
      <int>[3, 1, 2, 4],
      <int>[3, 4, 2, 1],
      <int>[1, 2, 1, 2, 1, 2, 1],
    ];
  }

  int get stackedRectangles => 10;

  Widget get _part1 {
    return Row(
      children: List<Widget>.generate(
        flexLists.length,
        (int i) {
          final List<int> list = flexLists[i];
          return Expanded(
            child: Column(
              children: List<Widget>.generate(
                list.length,
                (int j) => _part1ItemWidget(list[j]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget get _part2 {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double _w = constraints.maxWidth / (stackedRectangles + 1);
        final double _h = constraints.maxHeight / (stackedRectangles + 1);
        return Stack(
          children: <Widget>[
            ...List<Widget>.generate(stackedRectangles, (int i) {
              return _part2ItemWidget(i, _w, _h, true);
            }),
            ...List<Widget>.generate(stackedRectangles, (int i) {
              return _part2ItemWidget(i, _w, _h, false);
            }),
          ],
        );
      },
    );
  }

  Widget _part1ItemWidget(int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        color: RandomColor.getColor(),
        child: Text('$flex'),
      ),
    );
  }

  Widget _part2ItemWidget(int i, double w, double h, bool left) {
    return Positioned(
      left: left ? i * w : null,
      right: left ? null : i * w,
      top: i * h,
      width: w * 2,
      height: h * 2,
      child: ColoredBox(color: RandomColor.getColor()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: OrientationBuilder(
        builder: (BuildContext c, Orientation o) => Flex(
          direction:
              o == Orientation.landscape ? Axis.horizontal : Axis.vertical,
          children: <Widget>[Expanded(child: _part1), Expanded(child: _part2)],
        ),
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
