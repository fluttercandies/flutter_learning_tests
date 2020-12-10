import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final int _totalRatio = 10;
  final List<int> _stripRatios = <int>[2, 5, 8, 3, 6, 9, 1, 4, 7];

  final int _gridCount = 7;

  Widget _buildStrip(int ratio) => Expanded(
        flex: ratio,
        child: Container(
          color: RandomColor.getColor(),
          child: Center(child: Text('$ratio')),
        ),
      );

  Widget get _firstPart => Row(
        children: _stripRatios
            .map(
              (int e) => Expanded(
                child: Column(
                  children: <Widget>[
                    _buildStrip(e),
                    _buildStrip(_totalRatio - e)
                  ],
                ),
              ),
            )
            .toList(),
      );

  Widget get _secondPart => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final List<Widget> grids = <Widget>[];
          final List<Widget> mirrorGrids = <Widget>[];

          final double maxWidth = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight;
          final double width = (maxWidth / (_gridCount + 1)) * 2;
          final double height = (maxHeight / (_gridCount + 1)) * 2;

          for (int i = 0; i < _gridCount; i++) {
            final double offsetX = i * width / 2;
            final double offsetY = i * height / 2;

            final Widget grid = _buildGrid(
              width,
              height,
              offsetX,
              offsetY,
            );
            grids.add(grid);

            final Widget mirrorGrid = _buildGrid(
              width,
              height,
              maxWidth - offsetX - width,
              offsetY,
            );
            mirrorGrids.add(mirrorGrid);
          }

          return Stack(children: <Widget>[...grids, ...mirrorGrids]);
        },
      );

  Widget _buildGrid(
    double width,
    double height,
    double left,
    double top,
  ) =>
      Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: ColoredBox(color: RandomColor.getColor()),
      );

  @override
  Widget build(BuildContext context) => Material(
        child: OrientationBuilder(
          builder: (_, Orientation orientation) {
            final List<Widget> children = <Widget>[
              Expanded(child: _firstPart),
              Expanded(child: _secondPart),
            ];

            Axis direction;
            if (orientation == Orientation.portrait) {
              direction = Axis.vertical;
            } else {
              direction = Axis.horizontal;
            }

            return Flex(
              direction: direction,
              children: children,
            );
          },
        ),
      );
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
