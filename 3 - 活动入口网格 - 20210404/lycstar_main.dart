import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class PageGridItem {
  final String label;
  final dynamic image;

  PageGridItem({this.label, this.image});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TestPage extends StatelessWidget {
  final String title;

  const TestPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title)),
      body: Column(
        children: [
          PageGridView(
            color: Colors.blue,
            mainAxisCount: 3,
            crossAxisCount: 5,
            children: [
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
              PageGridItem(image: Icons.ac_unit, label: "label1"),
              PageGridItem(image: Icons.backup, label: "label2"),
              PageGridItem(image: Icons.calendar_today, label: "label3"),
              PageGridItem(image: Icons.delete_forever, label: "label4"),
            ],
            itemBuilder: (PageGridItem pageGridItem) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print(pageGridItem.label);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(pageGridItem.image),
                    Text(pageGridItem.label),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PageGridView extends StatefulWidget {
  final Color color;

  final List<PageGridItem> children;

  final int mainAxisCount;

  final int crossAxisCount;

  final double itemHeight;

  final Widget Function(PageGridItem item) itemBuilder;

  final Widget Function(double page, int pageCount) indicatorBuilder;

  const PageGridView({
    Key key,
    this.color = Colors.transparent,
    this.children,
    this.mainAxisCount = 2,
    this.crossAxisCount = 4,
    this.itemHeight = 80.0,
    this.itemBuilder,
    this.indicatorBuilder,
  })  : assert(children != null),
        assert(itemBuilder != null),
        super(key: key);

  @override
  _PageGridViewState createState() => _PageGridViewState();
}

class _PageGridViewState extends State<PageGridView> {
  final ValueNotifier<double> _page = ValueNotifier<double>(0);

  int get _pageCount => (widget.children.length / _pageItemCount).ceil();

  int get _pageItemCount => widget.mainAxisCount * widget.crossAxisCount;

  int get _totalItemCount => widget.children.length;

  double get _pageHeight => widget.mainAxisCount * widget.itemHeight;

  bool get _hasAlonePage => (_totalItemCount % _pageItemCount) > 0;

  double get _endPageHeight =>
      ((_totalItemCount % _pageItemCount) / widget.crossAxisCount).ceil() *
      widget.itemHeight;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _page.value = _pageController.page;
    });
  }

  List<PageGridItem> _getCurPageItems(int index) {
    return widget.children.sublist(
      index * _pageItemCount,
      (index + 1) * _pageItemCount > _totalItemCount
          ? _totalItemCount
          : (index + 1) * _pageItemCount,
    );
  }

  Widget buildDefaultIndicator(double page, int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        Color color;
        if (pageCount == 1) {
          color = Colors.red;
        } else if (page.floor() == index) {
          color = Color.lerp(
            Colors.red,
            Colors.white,
            page - page.floor(),
          );
        } else if (page.floor() == index - 1) {
          color = Color.lerp(
            Colors.white,
            Colors.red,
            page - page.floor(),
          );
        } else
          color = Colors.white;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 6.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          width: 12.0,
          height: 12.0,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _page,
      builder: (_, double page, Widget child) {
        return Container(
          color: widget.color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints.tightFor(
                  height: _hasAlonePage
                      ? page.ceil() == _pageCount - 1
                          ? lerpDouble(
                              _pageHeight,
                              _endPageHeight,
                              page - page.floor() == 0
                                  ? 1
                                  : page - page.floor(),
                            )
                          : _pageHeight
                      : _pageHeight,
                ),
                child: child,
              ),
              widget.indicatorBuilder == null
                  ? buildDefaultIndicator(page, _pageCount)
                  : widget.indicatorBuilder(page, _pageCount)
            ],
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              var list = _getCurPageItems(index);
              return Wrap(
                children: list
                    .map(
                      (item) => SizedBox(
                        width: constraints.maxWidth / widget.crossAxisCount,
                        height: widget.itemHeight,
                        child: widget.itemBuilder(item),
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
