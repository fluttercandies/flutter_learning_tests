import 'dart:math' as math show Random;

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
    return Material(
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return Row(children: [
              list,
              buildStack(true),
            ]);
          }
          return Column(
            children: [list, buildStack(false)],
          );
        },
      ),
    );
  }

  Expanded buildStack(bool isLandscape) {
    final generateChildren = List.generate(7, (index) {
      return FractionallySizedBox(
        widthFactor: 1 / 4,
        heightFactor: 1 / 4,
        alignment: AlignmentTween(
          begin: Alignment(-1, -1),
          end: Alignment(1, 1),
        ).lerp(index / 6),
        child: DecoratedBox(
          decoration: BoxDecoration(color: randomColor),
        ),
      );
    });
    final generateLandscapeChildren = List.generate(7, (index) {
      return FractionallySizedBox(
        widthFactor: 1 / 4,
        heightFactor: 1 / 4,
        alignment: AlignmentTween(
          begin: Alignment(1, -1),
          end: Alignment(-1, 1),
        ).lerp(index / 6),
        child: DecoratedBox(
          decoration: BoxDecoration(color: randomColor),
        ),
      );
    });
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ...generateChildren,
          if (isLandscape) ...generateLandscapeChildren,
        ],
      ),
    );
  }

  Expanded get list {
    return Expanded(
      child: Row(
        children: [2, 5, 8, 3, 6, 9, 1, 4, 7].map((e) {
          return Expanded(
            child: Column(
              children: [
                buildBox(e),
                buildBox(10 - e),
              ],
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
