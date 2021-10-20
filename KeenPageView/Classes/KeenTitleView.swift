//
//  KeenTitleView.swift
//  KeenViewPager
//
//  Created by chongzone on 2021/3/13.
//

import UIKit

public extension KeenTitleAttributes {
    
    /// 标题样式
    enum Style {
        /// 默认
        case `default`
        /// 缩放
        case scale
        /// 遮盖
        case cover
        /// 下划线
        case underline
    }
    
    /// 布局样式
    enum layoutMode {
        /// 自动(从左到右依次布局)
        case automatic
        /// 固定(大小固定 等分布局)
        case fixed
    }
}

//MARK: - 属性参数
public struct KeenTitleAttributes {
    
    /// 视图背景色 默认 clear
    public var viewBackColor: UIColor = UIColor.clear
    
    /// 样式  默认下划线
    public var style: KeenTitleAttributes.Style = .underline
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
    
    public init() { }
}

//MARK: - 协议
public protocol KeenTitleViewDelegate: AnyObject  {
    
    /// 数据源 即有几个标题
    /// - Parameter titleView: 对象
    func numberOfTitles(in titleView: KeenTitleView) -> Array<String>
    
    /// 标题属性 可选 不设置取默认值
    /// - Parameter titleView: 对象
    func attributesOfTitles(for titleView: KeenTitleView) -> KeenTitleAttributes
    
    /// 点击标题事件
    func titleView(_ titleView: KeenTitleView, didSelectedAt index: Int)
}

public extension KeenTitleViewDelegate {
    
    func attributesOfTitles(for titleView: KeenTitleView) -> KeenTitleAttributes {
        return KeenTitleAttributes()
    }
}

//MARK: - KeenTitleView 类
public class KeenTitleView: UIView {
    
    /// 代理
    public weak var delegate: KeenTitleViewDelegate!
    
    /// 当前位置
    private var currentIndex: Int = 0
    /// 控件集合
    private var titleItems: [UIButton] = [UIButton]()
    /// 正常状态下的 RGB
    private lazy var normalRGB = attributes.titleColor.toRGB()
    /// 选择状态下的 RGB
    private lazy var selectRGB = attributes.titleSelectedColor.toRGB()
    /// 滚动状态下的渐变 RGB
    private lazy var gradientRGB = UIColor.toGradientRGB(lhs: selectRGB, rhs: normalRGB)
    
    /// 标题集合
    private lazy var titles: [String] = {
        return delegate.numberOfTitles(in: self)
    }()
    /// 标题属性
    private lazy var attributes: KeenTitleAttributes = {
        return delegate.attributesOfTitles(for: self)
    }()
    
    /// 下划线 View
    private lazy var underlineView: UIView = {
        return UIView(frame: .zero)
            .backColor(attributes.underlineBackColor)
            .bringFrontViewTo(scrollView)
    }()
    
    /// 遮盖 View
    private lazy var coverView: UIView = {
        return UIView(frame: .zero)
            .backColor(attributes.coverBackColor)
            .bringFrontViewTo(scrollView)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: bounds)
            .backColor(attributes.viewBackColor)
            .showsVerticalScrollIndicator(false)
            .showsHorizontalScrollIndicator(false)
            .isDirectionalLockEnabled(true)
            .scrollsToTop(false)
            .addViewTo(self)
        if #available(iOS 11.0, *) { view.contentInsetAdjustmentBehavior = .never }
        return view
    }()
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - index: 默认选择的下标
    public init(
        frame: CGRect,
        delegate: KeenTitleViewDelegate,
        default index: Int = 0
    ) {
        super.init(frame: frame)
        self.delegate = delegate
        assert(index >= 0 && index <= titles.count - 1, "越界错误, 请检查下标大小值")
        currentIndex = index
        createSubviews()
    }

    /// 滑动渐变
    /// - Parameters:
    ///   - previousIndex: 上一个下标
    ///   - currentIndex: 当前下标
    ///   - progress: 滑动的百分比
    public func scrollDidScroll(
        from previousIndex: Int,
        to currentIndex: Int,
        progress: CGFloat
    ) {
        let previousItem = titleItems[previousIndex]
        let currentItem = titleItems[currentIndex]
        switch attributes.style {
        case .scale:
            let scale = attributes.scale - 1.0
            previousItem.transform = CGAffineTransform(
                scaleX: attributes.scale - progress * scale,
                y: attributes.scale - progress * scale
            )
            currentItem.transform = CGAffineTransform(
                scaleX: 1.0 + progress * scale,
                y: 1.0 + progress * scale
            )
        case .cover:
            let diff = currentItem.width - previousItem.width
            let cdiff = currentItem.centerX - previousItem.centerX
            var coverW = previousItem.width + diff * progress
            if attributes.layout == .automatic {
                coverW = previousItem.width + attributes.coverMargin*2 + diff * progress
            }
            coverView.width = coverW
            coverView.centerX = previousItem.centerX + progress * cdiff
        case .underline:
            let diff = currentItem.width - previousItem.width
            let cdiff = currentItem.centerX - previousItem.centerX
            let padding = attributes.layout == .automatic ? attributes.underlinePadding : 0
            underlineView.width = previousItem.width - padding + progress * diff
            underlineView.centerX = previousItem.centerX + progress * cdiff
        default: break
        }
        let previousColor = UIColor.color(
            r: selectRGB.red - progress * gradientRGB.red,
            g: selectRGB.green - progress * gradientRGB.green,
            b: selectRGB.blue - progress * gradientRGB.blue,
            a: 1.0
        )
        let currentColor = UIColor.color(
            r: normalRGB.red + progress * gradientRGB.red,
            g: normalRGB.green + progress * gradientRGB.green,
            b: normalRGB.blue + progress * gradientRGB.blue,
            a: 1.0
        )
        previousItem.titleColor(previousColor, .normal, .highlighted)
        currentItem.titleColor(currentColor, .normal, .highlighted)
    }
    
    /// 滑动结束
    /// - Parameter index: 下标
    public func scrollDidEndToIndex(at index: Int) {
        let previousItem = titleItems[currentIndex]
        previousItem.font(attributes.titleFont)
            .titleColor(attributes.titleColor, .normal, .highlighted)
            .backColor(attributes.titleBackColor, .normal, .highlighted)
        titlePosition(titleItems[index])
        let currentItem = titleItems[index]
        currentIndex = index
        switch attributes.style {
        case .default:
            previousItem.width = previousItem.currentTitle!.calculateSize(
                font: attributes.titleFont,
                width: .greatestFiniteMagnitude,
                height: frame.height,
                kernSpace: 0,
                lineSpace: 0
            ).width
            currentItem.width = currentItem.currentTitle!.calculateSize(
                font: attributes.titleSelectedFont,
                width: .greatestFiniteMagnitude,
                height: frame.height,
                kernSpace: 0,
                lineSpace: 0
            ).width
        case .scale:
            currentItem.transform = CGAffineTransform(
                scaleX: attributes.scale,
                y: attributes.scale
            )
        case .cover:
            var coverW = currentItem.width
            if attributes.layout == .automatic { coverW += attributes.coverMargin * 2 }
            coverW = min(coverW, currentItem.width + attributes.titleSpacing * 2)
            coverView.width = coverW
            coverView.centerX = currentItem.centerX
        case .underline:
            let padding = attributes.layout == .automatic ? attributes.underlinePadding : 0
            underlineView.width = currentItem.width - padding
            underlineView.centerX = currentItem.centerX
        }
        currentItem.font(attributes.titleSelectedFont)
            .titleColor(attributes.titleSelectedColor, .normal, .highlighted)
            .backColor(attributes.titleSelectedBackColor, .normal, .highlighted)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 布局|配置
private extension KeenTitleView {
    
    /// 布局控件
    func createSubviews() {
        var lastView: UIView?
        var itemX: CGFloat = 0, itemW: CGFloat = 0;
        for (idx, title) in titles.enumerated() {
            let font = idx == currentIndex ? attributes.titleSelectedFont : attributes.titleFont
            let item = UIButton(type: .custom)
                .tag(idx)
                .title(title, .normal, .highlighted)
                .font(font)
                .transform(.identity)
                .titleColor(idx == currentIndex ? attributes.titleSelectedColor : attributes.titleColor, .normal, .highlighted)
                .backColor(idx == currentIndex ? attributes.titleSelectedBackColor : attributes.titleBackColor, .normal, .highlighted)
                .addViewTo(scrollView)
            item.addTarget(
                self,
                action: #selector(clickTitleAction(_:)),
                for: .touchUpInside
            )
            if attributes.layout == .automatic {
                if idx == 0 {
                    itemX = attributes.titleSpacing
                }else {
                    itemX = lastView!.right + attributes.titleSpacing * 2
                }
                itemW = title.calculateSize(
                    font: font,
                    width: .greatestFiniteMagnitude,
                    height: frame.height,
                    kernSpace: 0,
                    lineSpace: 0
                ).width
            }else {
                if idx == 0 {
                    itemW = width / CGFloat(titles.count)
                }else {
                    itemX = lastView!.right
                }
            }
            item.frame = CGRect(x: itemX, y: 0, width: itemW, height: height)
            titleItems.append(item)
            lastView = item
        }
        let item = titleItems[currentIndex]
        switch attributes.style {
        case .scale:
            item.transform = CGAffineTransform(
                scaleX: attributes.scale,
                y: attributes.scale
            )
        case .cover:
            var coverW = item.width
            if attributes.layout == .automatic { coverW += attributes.coverMargin * 2 }
            coverW = min(coverW, item.width + attributes.titleSpacing * 2)
            coverView.size = CGSize(width: coverW, height: attributes.coverHeight)
            if attributes.isExistCoverRadius {
                coverView.corner(attributes.coverHeight * 0.5)
            }
            coverView.center = item.center
        case .underline:
            let padding = attributes.layout == .automatic ? attributes.underlinePadding : 0
            let underlineW = item.width - padding
            underlineView.y = height - attributes.underlineHeight
            underlineView.size = CGSize(width: underlineW, height: attributes.underlineHeight)
            if attributes.isExistUnderlineRadius {
                underlineView.corner(attributes.underlineHeight * 0.5)
            }
            underlineView.centerX = item.centerX
        default: break
        }
        var maxW = width
        if attributes.layout == .automatic {
            maxW = titleItems.last!.right + attributes.titleSpacing
        }
        scrollView.contentSize = CGSize(width: maxW, height: 0)
    }
    
    /// 点击标题
    @objc func clickTitleAction(_ sender: UIButton) {
        let index = sender.tag
        guard index != currentIndex else { return }
        delegate?.titleView(self, didSelectedAt: index)
        
        let currentItem = titleItems[index]
        let previousItem = titleItems[currentIndex]
        
        previousItem.font(attributes.titleFont)
            .titleColor(attributes.titleColor, .normal, .highlighted)
            .backColor(attributes.titleBackColor, .normal, .highlighted)
        currentItem.font(attributes.titleSelectedFont)
            .titleColor(attributes.titleSelectedColor, .normal, .highlighted)
            .backColor(attributes.titleSelectedBackColor, .normal, .highlighted)
        
        currentIndex = index
        titlePosition(currentItem)
        
        switch attributes.style {
        case .default:
            previousItem.width = previousItem.currentTitle!.calculateSize(
                font: attributes.titleFont,
                width: .greatestFiniteMagnitude,
                height: frame.height,
                kernSpace: 0,
                lineSpace: 0
            ).width
            currentItem.width = currentItem.currentTitle!.calculateSize(
                font: attributes.titleSelectedFont,
                width: .greatestFiniteMagnitude,
                height: frame.height,
                kernSpace: 0,
                lineSpace: 0
            ).width
        case .scale:
            titleTranslation {
                previousItem.transform(.identity)
                currentItem.transform = CGAffineTransform(
                    scaleX: self.attributes.scale,
                    y: self.attributes.scale
                )
            }
        case .cover:
            titleTranslation {
                var coverW = currentItem.width
                if self.attributes.layout == .automatic {
                    coverW += self.attributes.coverMargin * 2
                }
                coverW = min(coverW, currentItem.width + self.attributes.titleSpacing*2)
                self.coverView.width = coverW
                self.coverView.centerX = currentItem.centerX
            }
        case .underline:
            titleTranslation {
                let padding = self.attributes.layout == .automatic ? self.attributes.underlinePadding : 0
                self.underlineView.width = currentItem.width - padding
                self.underlineView.centerX = currentItem.centerX
            }
        }
    }
    
    func titleTranslation(_ animations: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 15,
            options: .curveLinear,
            animations: animations
        )
    }
    
    /// 以滚动控件中心为基准 即大于其宽度一半允许标题滚动
    func titlePosition(_ targetItem: UIButton, animated: Bool = true) {
        if attributes.layout == .automatic,
           scrollView.contentSize.width > scrollView.width {
            var offsetX = max(0, targetItem.centerX - width * 0.5)
            offsetX = min(offsetX, scrollView.contentSize.width - scrollView.width)
            scrollView.setContentOffset(x: offsetX, y: 0, animated: animated)
        }
    }
}
