import 'dart:math' as math show Random, max;

import 'package:flutter/material.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  Color get randomColor => RandomColor.getColor();

  @override
  Widget build(BuildContext context) {
    /// m = 5, n = 2 or 3 的数据列表
    final dataList = [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8, 9],
      [1, 2, 3],
    ];
    return Material(
      /// 监听屏幕方向
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return Row(children: [buildList(dataList), buildStack(true, 8)]);
          }
          return Column(
            children: [buildList(dataList), buildStack(false, 7)],
          );
        },
      ),
    );
  }

  /// 构建单个小方块
  Expanded buildStack(bool isLandscape, int x) {
    final children = <Widget>[];
    for (var index = 0; index < x; ++index) {
      children.add(buildFractionallySizedBox(
        Alignment(-1, -1),
        Alignment(1, 1),
        index,
        x,
      ));
      if (isLandscape) {
        children.add(buildFractionallySizedBox(
          Alignment(1, -1),
          Alignment(-1, 1),
          index,
          x,
        ));
      }
    }

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: children,
      ),
    );
  }

  /// 构建单个小方块
  FractionallySizedBox buildFractionallySizedBox(
    Alignment begin,
    Alignment end,
    int index,
    int x,
  ) {
    /// 计算单个小方块占据父组件宽高的比例
    final factor = 1 / ((x + 1) / 2);
    return FractionallySizedBox(
      widthFactor: factor,
      heightFactor: factor,
      /// 计算小方块所在位置
      alignment: AlignmentTween(
        begin: begin,
        end: end,
      ).lerp(index / (x - 1)),
      child: DecoratedBox(
        decoration: BoxDecoration(color: randomColor),
      ),
    );
  }

  /// 根据dataList构建所有比例条
  Expanded buildList(List<List<int>> data) {
    return Expanded(
      child: Row(
        children: data.map((e) {
          return Expanded(
            child: Column(children: e.map(buildBox).toList()),
          );
        }).toList(),
      ),
    );
  }

  /// 构建比例条的单个小方块
  Expanded buildBox(int e) {
    return Expanded(
      flex: e,
      child: DecoratedBox(
        decoration: BoxDecoration(color: randomColor),
        child: Center(child: Text(e.toString())),
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
