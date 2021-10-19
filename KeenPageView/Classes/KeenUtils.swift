//
//  KeenUtils.swift
//  KeenViewPager
//
//  Created by chongzone on 2021/3/13.
//

import UIKit

// 更多控件的扩展可参考地址 https://github.com/chongzone/KeenExtension.git
extension NSObject {
    
    /// 类名
    public var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".").last!
        }else {
            return name
        }
    }
    
    /// 类名
    public static var className: String {
        return String(describing: self)
    }
}

extension String {
    
    /// 计算字符串宽高
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 设定的宽度
    ///   - height: 设定的高度
    ///   - kernSpace: 字符间距
    ///   - lineSpace: 行间距
    /// - Returns: CGSize 值
    public func calculateSize(
        font: UIFont,
        width: CGFloat = CGFloat.greatestFiniteMagnitude,
        height: CGFloat = CGFloat.greatestFiniteMagnitude,
        kernSpace: CGFloat = 0,
        lineSpace: CGFloat = 0
    ) -> CGSize {
        if kernSpace == 0, lineSpace == 0 {
            let rect = self.boundingRect(
                with: CGSize(width: width, height: height),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )
            return CGSize(width: ceil(rect.width), height: ceil(rect.height))
        }else {
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            let label = UILabel(frame: rect)
            label.numberOfLines = 0
            label.font = font
            label.text = self
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            let attr = NSMutableAttributedString(
                string: self,
                attributes: [.kern : kernSpace]
            )
            attr.addAttribute(
                .paragraphStyle,
                value: style,
                range: NSMakeRange(0, self.count)
            )
            label.attributedText = attr
            return label.sizeThatFits(rect.size)
        }
    }
}

extension CGFloat {
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    /// 屏幕高度
    public static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window: UIWindow? = UIApplication.shared.windows.first
            return (window?.windowScene?.statusBarManager?.statusBarFrame.height)!
        }else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// 安全区域导航栏高度
    public static var safeAreaNavBarHeight: CGFloat { statusBarHeight + 44.0 }
}

extension UIColor {
    
    /// 改变透明度 不会影响子视图透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 对应的 Color
    public func toColor(of alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
    
    /// 转 rgb 数据
    public func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0;
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (CGFloat(r * 255.0), CGFloat(g * 255.0), CGFloat(b * 255.0))
    }
    
    /// 由 rgb 转渐变的 rgb 数据
    /// - Parameters:
    ///   - lhs:  第一个 rgb
    ///   - rhs: 第二个 rgb
    /// - Returns: 渐变的 rgb
    public static func toGradientRGB(
        lhs: (CGFloat, CGFloat, CGFloat),
        rhs: (CGFloat, CGFloat, CGFloat)
    ) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return (lhs.0 - rhs.0, lhs.1 - rhs.1, lhs.2 - rhs.2)
    }
    
    /// 由 RGBA 生成 Color 透明度默认 1.0
    /// - Parameters:
    ///   - r: 红色
    ///   - g: 绿色
    ///   - b: 蓝色
    ///   - a: 透明度
    /// - Returns: 对应的 Color
    public static func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    /// 随机色 用于调试等
    public static var colorRandom: UIColor {
        let red   = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue  = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIView {
    
    public var x: CGFloat {
        get {
            return frame.origin.x
        } set(value) {
            frame = CGRect(x: value, y: y, width: width, height: height)
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        } set(value) {
            frame = CGRect(x: x, y: value, width: width, height: height)
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: height)
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: width, height: value)
        }
    }
    
    public var origin: CGPoint {
        get {
            return frame.origin
        } set(value) {
            frame = CGRect(origin: value, size: frame.size)
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        } set(value) {
            frame = CGRect(origin: frame.origin, size: value)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return center.x
        } set(value) {
            center = CGPoint(x: value, y: centerY)
        }
    }
    
    public var centerY: CGFloat {
        get {
            return center.y
        } set(value) {
            center = CGPoint(x: centerX, y: value)
        }
    }
    
    public var top: CGFloat {
        get {
            return y
        } set(value) {
            y = value
        }
    }
    
    public var left: CGFloat {
        get {
            return x
        } set(value) {
            x = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return y + height
        } set(value) {
            y = value - height
        }
    }

    public var right: CGFloat {
        get {
            return x + width
        } set(value) {
            x = value - width
        }
    }
}

extension UIView {
    
    /// frame
    /// - Parameter frame: frame
    /// - Returns: 自身
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    /// 背景色
    /// - Parameter color: 颜色
    /// - Returns: 自身
    @discardableResult
    public func backColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }
    
    /// tag 值
    /// - Parameter tag: tag 值
    /// - Returns: 自身
    @discardableResult
    public func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    /// 是否支持响应 label & imageView 默认 false
    /// - Parameter enabled: 是否支持响应
    /// - Returns: 自身
    @discardableResult
    public func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    /// 圆角
    /// - Parameter radius: 圆角
    /// - Returns: 自身
    @discardableResult
    public func corner(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    /// 平移|缩放|旋转 等 transform 动画
    /// - Parameter form: 平移|缩放|旋转
    /// 1. CGAffineTransform 是一个 3*3 的仿射矩阵
    /// - Returns: 自身
    @discardableResult
    public func transform(_ form: CGAffineTransform) -> Self {
        transform = form
        return self
    }
    
    /// 添加到父视图
    /// - Parameter superView: 父视图
    /// - Returns: 自身
    @discardableResult
    public func addViewTo(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    
    /// 将某个视图移到前面
    /// - Parameter superView: 父视图
    /// - Returns: 自身
    @discardableResult
    public func bringFrontViewTo(_ superView: UIView) -> Self {
        superView.addSubview(self)
        superView.bringSubviewToFront(self)
        return self
    }
}

extension UIButton {
    
    /// 按钮文字 状态默认 normal
    /// - Parameters:
    ///   - title: 文案
    ///   - state: 状态
    /// - Returns: 自身
    @discardableResult
    public func title(_ title: String?, _ state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    /// 按钮文字
    /// - Parameters:
    ///   - title: 文案
    ///   - state1: 状态 1
    ///   - state2: 状态 2
    /// - Returns: 自身
    @discardableResult
    public func title(_ title: String?, _ state1: UIControl.State, _ state2: UIControl.State) -> Self {
        setTitle(title, for: state1)
        setTitle(title, for: state2)
        return self
    }
    
    /// 按钮字体
    /// - Parameter font: 字体
    /// - Returns: 自身
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    /// 按钮文字颜色 状态默认 normal
    /// - Parameters:
    ///   - color: 文案颜色
    ///   - state: 状态
    /// - Returns: 自身
    @discardableResult
    public func titleColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    /// 按钮文字颜色
    /// - Parameters:
    ///   - color: 文案颜色
    ///   - state1: 状态 1
    ///   - state2: 状态 2
    /// - Returns: 自身
    @discardableResult
    public func titleColor(_ color: UIColor, _ state1: UIControl.State, _ state2: UIControl.State) -> Self {
        setTitleColor(color, for: state1)
        setTitleColor(color, for: state2)
        return self
    }
    
    /// 按钮图片 状态默认 normal
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: 自身
    @discardableResult
    public func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    /// 按钮图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state1: 状态 1
    ///   - state2: 状态 2
    /// - Returns: 自身
    @discardableResult
    public func image(_ image: UIImage?, _ state1: UIControl.State, _ state2: UIControl.State) -> Self {
        setImage(image, for: state1)
        setImage(image, for: state2)
        return self
    }
    
    /// 按钮背景色 状态默认 normal
    /// - Parameters:
    ///   - color: 背景色
    ///   - state: 状态
    /// - Returns: 自身
    @discardableResult
    public func backColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(UIImage.image(color: color), for: state)
        return self
    }
    
    /// 按钮背景色
    /// - Parameters:
    ///   - color: 背景色
    ///   - state1: 状态 1
    ///   - state2: 状态 2
    /// - Returns: 自身
    @discardableResult
    public func backColor(_ color: UIColor, _ state1: UIControl.State, _ state2: UIControl.State) -> Self {
        setBackgroundImage(UIImage.image(color: color), for: state1)
        setBackgroundImage(UIImage.image(color: color), for: state2)
        return self
    }
}

extension UIImage {
    
    /// 由颜色生成图片
    /// - Parameter color: 颜色
    /// - Returns: 图片
    public static func image(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        guard let ctx = context else {
            UIGraphicsEndImageContext()
            return nil
        }
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIScrollView {
    
    /// 代理
    /// - Parameter delegate: 代理
    /// - Returns: 自身
    @discardableResult
    public func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// 是否有弹性效果 默认是 true
    /// - Parameter bounces: 是否有弹性
    /// - Returns: 自身
    @discardableResult
    public func bounces(_ bounces: Bool = true) -> Self {
        self.bounces = bounces
        return self
    }
    
    /// 是否允许滚动 默认 true
    /// - Parameter enabled: 是否滚动
    /// - Returns: 自身
    @discardableResult
    public func isScrollEnabled(_ enabled: Bool = true) -> Self {
        isScrollEnabled = enabled
        return self
    }
    
    /// 是否滚动分页 默认 false
    /// - Parameter enabled: 是否滚动分页
    /// - Returns: 自身
    @discardableResult
    public func isPagingEnabled(_ enabled: Bool = false) -> Self {
        isPagingEnabled = enabled
        return self
    }
    
    /// 点击状态栏时是否允许其自动滚动到顶部 默认 true
    /// - Parameter enableTop: 是否允许滚动到顶部
    /// - Returns: 自身
    @discardableResult
    public func scrollsToTop(_ enableTop: Bool = true) -> Self {
        scrollsToTop = enableTop
        return self
    }
    
    /// 是否显示水平方向滑动条 默认 true
    /// - Parameter show: 是否显示水平方向滑动条
    /// - Returns: 自身
    @discardableResult
    public func showsHorizontalScrollIndicator(_ show: Bool = true) -> Self {
        showsHorizontalScrollIndicator = show
        return self
    }
    
    /// 是否显示垂直方向滑动条 默认 true
    /// - Parameter show: 是否显示垂直方向滑动条
    /// - Returns: 自身
    @discardableResult
    public func showsVerticalScrollIndicator(_ show: Bool = true) -> Self {
        showsVerticalScrollIndicator = show
        return self
    }
    
    /// 滑动时是否锁住另外方向的滑动 默认  false(不锁定)
    /// - Parameter enabled: 是否锁住 默认 false
    /// - Returns: 自身
    @discardableResult
    public func isDirectionalLockEnabled(_ enabled: Bool = false) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }
    
    /// 滚动的偏移量  默认动画
    /// - Parameters:
    ///   - x: x 偏移量
    ///   - y: y 偏移量
    ///   - animated: 是否有动画 默认 true
    /// - Returns: 自身
    @discardableResult
    public func setContentOffset(x: CGFloat, y: CGFloat, animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: x, y: y), animated: animated)
        return self
    }
}

extension UICollectionView {
    
    /// 代理
    /// - Parameter delegate: 代理
    /// - Returns: 自身
    @discardableResult
    public func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// 数据源
    /// - Parameter dataSource: 数据源
    /// - Returns: 自身
    @discardableResult
    public func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    /// 注册 cell
    /// - Parameter cellClass: cell 类
    /// - Parameter identifier: 复用标识符
    /// - Returns: 自身
    @discardableResult
    public func register(_ cellClass: AnyClass?, identifier: String) -> Self {
        register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
}
