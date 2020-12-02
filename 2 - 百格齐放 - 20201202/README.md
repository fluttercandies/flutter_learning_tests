# 百格齐放 - 2020/12/02

![](http://pic.alexv525.com/2020-12-02-123329.png?)

实现两种布局，要求如下：
* 上下 **各占一半** 的应用布局空间；
* 上半部分：
  * 横向显示 **9** 个比例条，比例条的 **每一个部分** 的 **中间** 显示该部分的比例；
  * 每一条的总比例为 **10**，上部分比例分别为：`<int>[2, 5, 8, 3, 6, 9, 1, 4, 7]`，下部分比例为剩余数。
* 下半部分：
  * 从 **左上** 至 **右下** 依次层叠 **7** 个方块；
  * 下一个方块的 **左上角顶点** 为上一个方块的 **中心点**；
  * 最后一个方块的右下角与区域右下角 **顶点重合**。
* 每个部分显示随机颜色。
* 不能使用 `SizedBox`、`Container` 的 `width` 或 `height`、`ConstrainedBox`。

生成随机颜色的代码：

```dart
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
```

加分项：

* 当 **横屏** 时，区域显示为 **左右** 两块；**竖屏** 时，显示为 **上下** 两块；
* 上半部分：
  * 支持总比例为 **n**，区域数为 **m** 的比例条；
* 下半部分：
  * 支持总数为 **n** 个方块的层叠；
  * 在原有基础上，从 **右上** 至 **左下** 以同样的方式再层叠一组方块。

![](http://pic.alexv525.com/2020-12-02-2C4E536FE41DEDD98371A665E86F26A7.jpg)
