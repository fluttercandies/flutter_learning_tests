import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Screens {
  const Screens._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double get width => mediaQuery.size.width;

  static double get height => mediaQuery.size.height;
}

class ItemModel {
  ItemModel({
    IconData icon,
    String name,
  }) {
    _icon = icon;
    _name = name;
  }

  IconData _icon;
  IconData get icon => _icon;
  String _name;
  String get name => _name;
}

class ActivityEnterPage extends StatefulWidget {
  const ActivityEnterPage({
    Key key,
    @required this.items,
    this.rowCount = 4,
    this.columnCount = 2,
    this.itemHeight = 60,
    this.itemBuilder,
    this.itemCallback,
  }) : super(key: key);

  final List<dynamic> items;

  /// 横向item数量 默认为4
  final int rowCount;

  /// 纵向item数量 默认为2
  final int columnCount;

  /// 单个item的高度
  final double itemHeight;

  /// 自定义的item
  final Widget Function(ItemModel model) itemBuilder;

  /// 点击item的回调
  final Function(int index) itemCallback;

  @override
  ActivityEnterPageState createState() => ActivityEnterPageState();
}

class ActivityEnterPageState extends State<ActivityEnterPage> {
  /// 默认页数
  get pageCount =>
      (widget.items.length / (widget.rowCount * widget.columnCount)).ceil();

  /// 当前页码
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  /// 当前页码下实际的column数
  final ValueNotifier<int> currentColumn = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();
    if ((widget.items.length / widget.rowCount).ceil() > widget.columnCount) {
      currentColumn.value = widget.columnCount;
    } else {
      currentColumn.value = (widget.items.length / widget.rowCount).ceil();
    }
  }

  /// 获取当前页上的items数据
  List<dynamic> _currentPageItems(int index) {
    final int _listIndex = widget.rowCount * widget.columnCount * index;
    final int _nextIndex = widget.rowCount * widget.columnCount * (index + 1);
    List<dynamic> _pageItems;
    if (widget.items.length > _nextIndex) {
      _pageItems = widget.items.sublist(_listIndex, _nextIndex);
    } else {
      _pageItems = widget.items.sublist(_listIndex, widget.items.length);
    }
    return _pageItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('activity'),
      ),
      backgroundColor: Colors.blue,
      body: ValueListenableBuilder(
        valueListenable: currentColumn,
        builder: (_, int column, __) {
          return AnimatedContainer(
            color: Colors.white,
            duration: kThemeAnimationDuration,
            height: column * widget.itemHeight + (column * 10) + 20,
            child: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (int index) {
                    final List<dynamic> _items = _currentPageItems(index);
                    currentColumn.value =
                        (_items.length / widget.rowCount).ceil();
                    currentPage.value = index;
                  },
                  itemCount: pageCount,
                  itemBuilder: (BuildContext context, int index) {
                    return _GirdViewItem(
                      items: _currentPageItems(index),
                      row: widget.rowCount,
                      column: widget.columnCount,
                      itemHeight: widget.itemHeight,
                      tapCallback: (int tapIndex) {
                        int _resultIndex = tapIndex;
                        if (index > 0) {
                          final int _listIndex =
                              widget.rowCount * widget.columnCount * index;
                          _resultIndex = _listIndex + _resultIndex;
                        }
                        widget?.itemCallback(_resultIndex);
                      },
                    );
                  },
                ),
                if (pageCount > 1)
                  ValueListenableBuilder(
                    valueListenable: currentPage,
                    builder: (_, int page, __) {
                      return Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pageCount,
                            (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 10,
                                width: 10,
                                color:
                                    index == page ? Colors.blue : Colors.grey,
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GirdViewItem extends StatelessWidget {
  const _GirdViewItem({
    Key key,
    @required this.items,
    @required this.row,
    @required this.column,
    @required this.itemHeight,
    @required this.tapCallback,
    this.itemBuilder,
  }) : super(key: key);

  final List<dynamic> items;
  final int row;
  final int column;
  final double itemHeight;
  final Function(int index) tapCallback;
  final Widget Function(ItemModel model) itemBuilder;
  final double _horizontalMargin = 30;
  final double _verticalMargin = 20;
  final double _spacing = 10;
  final double _runSpacing = 10;

  @override
  Widget build(BuildContext context) {
    final double _width =
        (Screens.width - _horizontalMargin - (row - 1) * _spacing) / row;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _horizontalMargin / 2, vertical: _verticalMargin / 2),
      child: Wrap(
        spacing: _spacing,
        runSpacing: _runSpacing,
        children: List.generate(
          items.length,
          (int index) {
            if (itemBuilder != null)
              return itemBuilder.call(items[index]);
            else
              return _WrapItem(
                index: index,
                itemWidth: _width,
                itemHeight: itemHeight,
                model: items[index],
                tapCallback: tapCallback,
              );
          },
        ),
      ),
    );
  }
}

class _WrapItem extends StatelessWidget {
  const _WrapItem({
    Key key,
    @required this.index,
    @required this.itemWidth,
    @required this.model,
    @required this.itemHeight,
    @required this.tapCallback,
  }) : super(key: key);

  final int index;
  final double itemHeight;
  final double itemWidth;
  final ItemModel model;
  final Function(int index) tapCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        tapCallback(index);
      },
      child: Container(
        width: itemWidth,
        height: itemHeight ?? 50,
        child: Column(
          children: <Widget>[
            Icon(model.icon),
            const Spacer(),
            Text(model.name),
          ],
        ),
      ),
    );
  }
}
