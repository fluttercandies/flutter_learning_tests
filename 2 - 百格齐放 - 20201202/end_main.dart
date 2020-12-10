import 'package:flutter/material.dart';
import 'dart:math' as math;

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

class BaigeWidget extends StatelessWidget {
  final gridList = <int>[2, 5, 8, 3, 6, 9, 1, 4, 7];
  final cubeList = <int>[1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {}

  Widget grid(int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        child: Center(
          child: Text(
            '${flex}',
            textAlign: TextAlign.center,
          )
        ),
        color: RandomColor.getColor(),
      ),
    );
  }

  Widget scaleBar() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: gridList.asMap().keys.map((item) => Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                grid(gridList[item]),
                grid(10 - gridList[item]),
              ]
          )
        )).toList(),
      ),
    );
  }
  Widget cube() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final width = constraints.maxWidth / 8;
          final height = constraints.maxWidth / 8;
          return Stack(
            children: cubeList.asMap().keys.map((item) => Positioned(
              child: Container(
                color: RandomColor.getColor(),
              ),  
              left: item * width,
              right: (6.0 - item) * width,
              top: item * height,
              bottom: (6.0 - item) * height,
            )).toList(),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百格齐放'),
      ),
      body: OrientationBuilder(
        builder: (contet, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                scaleBar(),
                cube(),
              ]
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                scaleBar(),
                cube(),
              ]
            );
          }
        }
      ),
    );
  }
}