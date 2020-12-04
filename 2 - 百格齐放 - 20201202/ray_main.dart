import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (_, orientation) {
          List<Widget> children = <Widget>[
            Expanded(
              child: PercentBoxWidget(
                max: 10,
                data: [2, 5, 8, 3, 6, 9, 1, 4, 7],
              ),
            ),
            Expanded(
              child: StackBoxWidget(
                boxCount: 10,
              ),
            ),
          ];
          if (orientation == Orientation.landscape) {
            return Row(
              children: children,
            );
          } else {
            return Column(
              children: children,
            );
          }
        },
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

class PercentBoxWidget extends LeafRenderObjectWidget {
  final int max;
  final List<int> data;

  PercentBoxWidget({
    this.max = 10,
    this.data = const <int>[],
  })  : assert(max != null && max > 1),
        assert(() {
          if (data == null) {
            return false;
          }
          data.forEach((element) {
            assert(element > 0 && element < max);
          });
          return true;
        }());

  @override
  RenderPercentBox createRenderObject(BuildContext context) {
    return RenderPercentBox(max, data);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderPercentBox renderPercentBox) {
    renderPercentBox
      ..data = data
      ..max = max;
  }
}

class RenderPercentBox extends RenderBox {
  int max;
  List<int> data;
  Paint bgPaint;
  TextPainter textPainter;

  RenderPercentBox(this.max, this.data) {
    bgPaint = Paint()..isAntiAlias = true;
    textPainter = TextPainter(textDirection: TextDirection.ltr);
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size.infinite); //填满
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (data.isNotEmpty) {
      Canvas canvas = context.canvas;
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      double width = size.width / data.length;
      for (int i = 0; i < data.length; i++) {
        int value = data[i];
        bgPaint..color = RandomColor.getColor();
        double topHeight = size.height * (value / max);
        var topRect = Rect.fromLTWH(0, 0, width, topHeight);
        canvas.drawRect(topRect, bgPaint);
        textPainter.text = TextSpan(text: value.toString());
        textPainter.layout(maxWidth: width);
        textPainter.paint(
          canvas,
          Offset(
            topRect.center.dx - textPainter.width / 2,
            topRect.center.dy - textPainter.height / 2,
          ),
        );
        var bottomRect =
            Rect.fromLTWH(0, topHeight, width, size.height - topHeight);
        bgPaint..color = RandomColor.getColor();
        canvas.drawRect(bottomRect, bgPaint);
        textPainter.text = TextSpan(text: (max - value).toString());
        textPainter.layout(maxWidth: width);
        textPainter.paint(
          canvas,
          Offset(
            bottomRect.center.dx - textPainter.width / 2,
            bottomRect.center.dy - textPainter.height / 2,
          ),
        );
        canvas.translate(width, 0);
      }
      canvas.restore();
    }
  }
}

///层叠box
class StackBoxWidget extends LeafRenderObjectWidget {
  final int boxCount;

  const StackBoxWidget({this.boxCount = 7})
      : assert(boxCount != null && boxCount > 0);

  @override
  RenderStackBox createRenderObject(BuildContext context) {
    return RenderStackBox(boxCount);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderStackBox renderStackBox) {
    renderStackBox.boxCount = boxCount;
  }
}

class RenderStackBox extends RenderBox {
  int boxCount;
  Paint boxPaint = Paint()..isAntiAlias = true;

  RenderStackBox(this.boxCount);

  @override
  void performLayout() {
    size = constraints.constrain(Size.infinite); //填满
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double width = size.width / ((boxCount + 1) / 2);
    double halfWidth = width / 2;
    Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    double ltrLeft = 0;
    double top = 0;
    double rtlLeft = size.width - width;
    for (int i = 0; i < boxCount; i++) {
      boxPaint.color = RandomColor.getColor();
      canvas.drawRect(Rect.fromLTWH(ltrLeft, top, width, width), boxPaint);
      boxPaint.color = RandomColor.getColor();
      canvas.drawRect(Rect.fromLTWH(rtlLeft, top, width, width), boxPaint);
      ltrLeft += halfWidth;
      rtlLeft -= halfWidth;
      top += halfWidth;
    }
    canvas.restore();
  }
}
