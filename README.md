![KeenPageView](https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/KeenPageViewLogo.png)

![CI Status](https://img.shields.io/travis/chongzone/KeenPageView.svg?style=flat)
![](https://img.shields.io/badge/swift-5.0%2B-orange.svg?style=flat)
![](https://img.shields.io/badge/pod-v1.0.1-brightgreen.svg?style=flat)
![](https://img.shields.io/badge/platform-iOS-orange.svg?style=flat)
![](https://img.shields.io/badge/license-MIT-blue.svg)

## 效果样式 

样式说明 | Gif 图 |
----|------|
默认样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_01.gif" width="320" height="95"> |
缩放样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_02.gif" width="320" height="95"> |
遮罩样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_03.gif" width="320" height="95"> |
下划线样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_04.gif" width="320" height="95"> |
其他样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_05.gif" width="320" height="95"> |
其他样式 |  <img src="https://raw.githubusercontent.com/chongzone/KeenPageView/master/Resources/Keenpage_06.gif" width="320" height="95"> |

## API 说明

- [x] 标题视图面向 `pop` 开发，支持自定义多种属性
- [x] 标题视图和列表页面无耦合关系，满足多种视觉需求效果 

标题支持的选中样式
```ruby
enum style {
    /// 默认
    case `default`
    /// 缩放
    case scale
    /// 遮盖
    case cover
    /// 下划线
    case underline
}
```

标题支持的布局样式
```ruby
enum layoutMode {
    /// 自动(从左到右依次布局)
    case automatic
    /// 固定(大小固定 等分布局)
    case fixed
}
```

在标题属性对象 `KeenTitleAttributes` 中可查看支持定制的参数属性
```ruby
/// 视图背景色 默认 clear
public var viewBackColor: UIColor = UIColor.clear

/// 样式  默认下划线
public var style: KeenTitleAttributes.style = .underline
/// 布局样式 默认自动
public var layout: KeenTitleAttributes.layoutMode = .automatic

/// 标题间隔 默认 5pt
public var titleSpacing: CGFloat = 5
/// 标题字体 默认系统常规 15pt
public var titleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
/// 标题 选中字体 默认系统常规 15pt
public var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
/// 标题颜色 默认 black
public var titleColor: UIColor = UIColor.black
/// 标题选中时颜色 默认 blue
public var titleSelectedColor: UIColor = UIColor.blue
/// 标题背景色 默认 white
public var titleBackColor: UIColor = UIColor.white
/// 标题选中时背景色  默认 white
public var titleSelectedBackColor: UIColor = UIColor.white

/// 缩放比例 默认 1.25
public var scale: CGFloat = 1.25

/// 下划线是否圆角 默认 true
public var isExistUnderlineRadius: Bool = true
/// 下划线高度 默认 2pt
public var underlineHeight: CGFloat = 2
/// 下划线内边距 默认 0 pt
public var underlinePadding: CGFloat = 0
/// 下划线背景色 默认 blue
public var underlineBackColor: UIColor = UIColor.blue

/// 遮罩是否圆角 默认 true
public var isExistCoverRadius: Bool = true
/// 遮罩高度 默认 25pt
public var coverHeight: CGFloat = 25
/// 遮罩外边距 默认 5pt
public var coverMargin: CGFloat = 5
/// 遮罩背景色 默认 black 透明 40%
public var coverBackColor: UIColor = UIColor.black.toColor(of: 0.4)
```

## 使用介绍 

### `KeenTitleView` 示例

```ruby
var rect = CGRect(x: 0, y: .safeAreaNavBarHeight, width: .screenWidth, height: 44)
titleView = KeenTitleView(
    frame: rect,
    delegate: self,
    default: 1
)
.addViewTo(view)
```

### `KeenPageView` 示例

```ruby
let rect = CGRect(x: 0, y: titleView.bottom, width: .screenWidth, height: .screenHeight - titleView.bottom)
let pageView = KeenPageView(
    frame: rect,
    delegate: self,
    default: 1
)
.addViewTo(view)
```

### `KeenTitleViewDelegate` 代理

```ruby
/// 数据源 即有几个标题
/// - Parameter titleView: 对象
func numberOfTitles(in titleView: KeenTitleView) -> Array<String>

/// 标题属性 可选函数 不设置取默认值
/// - Parameter titleView: 对象
func attributesOfTitles(for titleView: KeenTitleView) -> KeenTitleAttributes

/// 点击标题事件
func titleView(_ titleView: KeenTitleView, didSelectedAt index: Int)
```

### `KeenPageViewDelegate` 代理

```ruby
/// 数据源 即有几个页面
/// - Parameter pageView: 对象
func numberOfPageView(in pageView: KeenPageView) -> Array<UIViewController>

/// 滚动事件
/// - Parameters:
///   - pageView: 对象
///   - previousIndex: 上一个页面位置
///   - currentIndex: 当前页面位置
///   - progress: 滚动的百分比
func pageView(_ pageView: KeenPageView, from previousIndex: Int, to currentIndex: Int, progress: CGFloat)

/// 结束滚动事件
/// - Parameters:
///   - pageView: 对象
///   - index: 结束时页面位置
func pageView(_ pageView: KeenPageView, didEndScrollAt index: Int)
```
> 具体可下载查看源码实现 

## 安装方式 

### CocoaPods

```ruby
platform :ios, '9.0'
use_frameworks!

target 'TargetName' do

pod 'KeenPageView'

end
```
> `iOS` 版本要求 `9.0+`
> `Swift` 版本要求 `5.0+`

## Contact Me

QQ: 2209868966
邮箱: chongzone@163.com

## License

KeenPageView is available under the MIT license. [See the LICENSE](https://github.com/chongzone/KeenPageView/blob/main/LICENSE) file for more info.
