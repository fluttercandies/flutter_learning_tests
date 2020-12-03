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
    final dataList = [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8, 9],
      [1, 2, 3],
    ];
    return Material(
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return Row(children: [
              buildList(dataList),
              buildStack(true, 8),
            ]);
          }
          return Column(
            children: [buildList(dataList), buildStack(false, 7)],
          );
        },
      ),
    );
  }

  Expanded buildStack(bool isLandscape, int n) {
    final factor = 1 / ((n + 1) / 2);
    final children = <Widget>[];
    for (var index = 0; index < n; ++index) {
      children.add(buildFractionallySizedBox(
        factor,
        Alignment(-1, -1),
        Alignment(1, 1),
        index,
        n,
      ));
      if (isLandscape) {
        children.add(buildFractionallySizedBox(
          factor,
          Alignment(1, -1),
          Alignment(-1, 1),
          index,
          n,
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

  FractionallySizedBox buildFractionallySizedBox(
      double factor, Alignment begin, Alignment end, int index, int n) {
    return FractionallySizedBox(
      widthFactor: factor,
      heightFactor: factor,
      alignment: AlignmentTween(
        begin: begin,
        end: end,
      ).lerp(index / (n - 1)),
      child: DecoratedBox(
        decoration: BoxDecoration(color: randomColor),
      ),
    );
  }

  Expanded buildList(List<List<int>> data) {
    assert((() {
      return data.length >= 2 &&
          data.expand((element) => element).fold<int>(
                  0,
                  (previousValue, element) =>
                      math.max(previousValue, element)) >=
              2;
    })());
    return Expanded(
      child: Row(
        children: data.map((e) {
          return Expanded(
            child: Column(
              children: e.map((e) => buildBox(e)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

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
