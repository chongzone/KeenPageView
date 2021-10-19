//
//  KeenPageView.swift
//  KeenPageView
//
//  Created by chongzone on 2021/3/13.
//

import UIKit

//MARK: - 协议
public protocol KeenPageViewDelegate: AnyObject  {
    
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
}

//MARK: - KeenPageView 类
public class KeenPageView: UIView {
    
    /// 代理
    public weak var delegate: KeenPageViewDelegate!
    
    /// 当前位置
    private var currentIndex: Int = 0
    /// 是否开始拖拽
    private var beginDragging: Bool = false
    /// 记录拖拽开始时的偏移量
    private var beginDraggingOffsetX: CGFloat = 0
    /// 页面数据
    private lazy var childVcs: [UIViewController] = {
        return delegate.numberOfPageView(in: self)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = frame.size
        layout.invalidateLayout()
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
            .showsHorizontalScrollIndicator(false)
            .isPagingEnabled(true)
            .scrollsToTop(false)
            .dataSource(self)
            .delegate(self)
            .bounces(false)
            .backColor(.white)
            .isScrollEnabled(true)
            .register(UICollectionViewCell.self, identifier: self.className)
            .addViewTo(self)
        if #available(iOS 11.0, *) { view.contentInsetAdjustmentBehavior = .never }
        return view
    }()
    
    /// 初始化 默认选择第一个页面
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - index: 默认选择的页面下标
    public init(
        frame: CGRect,
        delegate: KeenPageViewDelegate,
        default index: Int = 0
    ) {
        super.init(frame: frame)
        self.delegate = delegate
        assert(index >= 0 && index <= childVcs.count - 1, "越界错误, 请检查下标大小值")
        currentIndex = index
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: CGFloat(index) * width, y: 0)
    }
    
    /// 滚动到指定页面 默认无动画
    /// - Parameters:
    ///   - index: 页面下标
    ///   - scrollPosition: 滚动方向
    ///   - animation: 是否动画
    public func scrollToPage(
        at index: Int,
        at scrollPosition: UICollectionView.ScrollPosition = .left,
        animation: Bool = false
    ) {
        currentIndex = index
        beginDragging = false
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: scrollPosition,
            animated: animation
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource 数据源
extension KeenPageView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.className, for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        if childVcs.count > 0 {
            let vc = childVcs[indexPath.item]
            vc.view.frame(cell.contentView.bounds).addViewTo(cell.contentView)
        }
        return cell
    }
}

//MARK: - UIScrollViewDelegate 代理
extension KeenPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        progress(in: self, scrollView: scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginDraggingOffsetX = scrollView.contentOffset.x
        beginDragging = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            index(in: self, scrollView: scrollView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        index(in: self, scrollView: scrollView)
    }
}

//MARK: - 滚动事件
private extension KeenPageView {
    
    /// 页面下标
    func index(in pageView: KeenPageView, scrollView: UIScrollView) {
        currentIndex = Int((scrollView.contentOffset.x / scrollView.width))
        delegate.pageView(self, didEndScrollAt: currentIndex)
    }
    
    /// 滚动的百分比
    func progress(in pageView: KeenPageView, scrollView: UIScrollView) {
        guard beginDragging == true else {
            return
        }
        var progress: CGFloat = 0, currentIndex: Int = 0, previousIndex: Int = 0;
        
        let offsetX = scrollView.contentOffset.x
        let remainder = offsetX.truncatingRemainder(dividingBy: scrollView.width)
        guard (remainder / scrollView.width) > 0,
              !(remainder / scrollView.width).isNaN
        else { return }
        
        progress = remainder / scrollView.width
        let index = Int(offsetX / scrollView.width)
        if offsetX > beginDraggingOffsetX {
            previousIndex = index
            currentIndex = index + 1
            guard currentIndex <= childVcs.count - 1 else { return }
        }else {
            previousIndex = index + 1
            currentIndex = index
            progress = 1 - progress
            guard currentIndex >= 0  else { return }
        }
        if progress > 0.9 { progress = 1 }
        
        delegate.pageView(self, from: previousIndex, to: currentIndex, progress: progress)
    }
}
