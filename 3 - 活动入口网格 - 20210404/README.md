# 活动入口网格 - 2021/04/04

![](https://pic.alexv525.com/2021-04-04-095238.png)

实现一个类似「饿了么」和「美团」首页的活动入口网格布局，要求如下：
* **不能使用 `GridView`**；
* 支持 **左右滑动切换页面**；
* 支持 **自定义横向和纵向的 item 数量**；
* item 支持 **自定义图标和文字**；
* item 支持 **自定义高度**，布局高度依据 item 高度确定；
* item 支持 **点击事件**。

加分项：
* 在底部实现一个页数指示器；
* item 支持 **自定义各自的图标和文字的大小及样式**，同时保证布局高度自适应；
* 布局可以根据不同页面的 item 数量，**在切换时平滑调整高度**；
* item 基于类 (class) 组织内容，布局提供接口用于自定义 `itemBuilder`: `Widget Function(_ItemData item)`；
* 开放实现自定义页数指示器的接口 `PreferredSizeWidget Function(PageController controller, int pageCount)? indicatorBuilder`。

![](https://pic.alexv525.com/2021-04-04-Kapture%202021-04-04%20at%2018.02.20.gif)
