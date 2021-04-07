import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '活动网格',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the acpplication
        // is not restarted.
        primaryColor: Colors.red,
        primaryColorBrightness: Brightness.dark,
        primaryColorDark: Colors.grey,
        primaryColorLight: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.blue,
            // centerTitle: false,
            // shadowColor: Colors.blue,
            brightness: Brightness.dark),
      ),
      home: HomePage(),
    );
  }
}

//实体
class ItemEntity {
  String name;
  IconData icon;

  ItemEntity(this.name, this.icon);
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridItemPageState();
  }
}

class GridItemPageState extends State<HomePage> {
  var data = <ItemEntity>[];

  //页面高度
  var _pageHeight;

  //页面数
  var pages = -1;

  //每行item数量
  var rowCount = 5;

  //行数
  var columnCount = 2;

  //item size
  var _itemSize;

  var isFirst = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 13; i++) {
      data.add(ItemEntity('测试:${i + 1}', Icons.android));
    }
    //计算页数
    pages = data.length ~/ (rowCount * columnCount) +
        (data.length % (rowCount * columnCount) == 0 ? 0 : 1);
  }

  List<Container> _generateData() {
    //组件list
    var list = <Container>[];

    //生成每页数据
    for (int i = 0; i < pages; i++) {
      list.add(
          //每页的父布局
          Container(
        color: Colors.white,
        width: double.infinity,
        alignment: Alignment.topLeft,
        child: Wrap(
          direction: Axis.horizontal,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: data
              .sublist(
                  rowCount * columnCount * i,
                  (i + 1) * rowCount * columnCount > data.length
                      ? data.length
                      : (i + 1) * rowCount * columnCount)
              .map((e) => GestureDetector(
                    onTap: () {
                      print('点击${e.name}');
                    },
                    child: Container(
                        width: _itemSize,
                        height: _itemSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[Icon(e.icon), Text(e.name)],
                        )),
                  ))
              .toList(),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _itemSize = MediaQuery.of(context).size.width / rowCount;
    if (isFirst) {
      isFirst = false;
      if (pages > 1) {
        _pageHeight = columnCount * _itemSize;
      } else {
        //不够一页的item数量
        var moreItemCount = data.length % (rowCount * columnCount);
        var lineCount =
            moreItemCount ~/ rowCount + moreItemCount % rowCount == 0 ? 0 : 1;
        _pageHeight = lineCount * _itemSize;
      }
    }

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('自定义Grid分页Item'),
      ),
      body: Container(
        width: double.infinity,
        height: _pageHeight,
        child: PageView(
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          onPageChanged: (index) {
            setState(() {
              if ((pages - 1) == index) {
                //不够一页的item数量
                var moreItemCount = data.length % (rowCount * columnCount);
                var lineCount =
                    moreItemCount ~/ rowCount + moreItemCount % rowCount == 0
                        ? 0
                        : 1;
                _pageHeight = lineCount * _itemSize;
                print("if:$_pageHeight");
              } else {
                _pageHeight = columnCount * _itemSize;
              }
            });
          },
          children: _generateData(),
        ),
      ),
    );
  }
}
