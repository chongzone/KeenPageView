//
//  NextVc.swift
//  KeenPageView
//
//  Created by chongzone on 2021/3/13.
//

import UIKit
import KeenPageView

class NextVc: UIViewController {

    var type: Int = 0
    
    private var item: UIButton!
    private var items: [String] = []
    private var pageView: KeenPageView!
    private var titleView: KeenTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == 5 {
            items = ["关注", "推荐", "新体育"]
        }else {
            items = ["关注", "推荐", "新体育", "足球", "篮球", "英超", "西甲", "法甲", "德甲", "意甲", "欧冠"]
        }
        
        var itemY = type == 5 ? 0 : CGFloat.safeAreaNavBarHeight
        var itemW = type == 5 ? CGFloat(items.count) * 80.0 : (type == 4 ? CGFloat.screenWidth - 40 : CGFloat.screenWidth)
        var rect = CGRect(x: 0, y: itemY, width: itemW, height: 44)
        titleView = KeenTitleView(
            frame: rect,
            delegate: self,
            default: 1
        )
        
        if type == 5 {
            navigationItem.titleView = titleView
        }else {
            titleView.addViewTo(view)
        }
        itemY = type == 5 ? CGFloat.safeAreaNavBarHeight : titleView.bottom
        itemW = type == 4 ? CGFloat.screenWidth - 40 : CGFloat.screenWidth
        
        if type == 4 {
            rect = CGRect(x: titleView.right, y: titleView.top, width: 40, height: 44)
            item = UIButton(type: .custom)
                .frame(rect)
                .image(UIImage(named: "icon_more"), .normal, .highlighted)
                .backColor(.white, .normal, .highlighted)
                .addViewTo(view)
            
            item.layer.shadowColor   = UIColor.lightGray.cgColor
            item.layer.shadowOpacity = 0.3
            item.layer.shadowRadius  = 3
            item.layer.shadowOffset  = CGSize(width: -2, height: 0)
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
        }
        
        rect = CGRect(x: 0, y: itemY, width: .screenWidth, height: .screenHeight - itemY)
        pageView = KeenPageView(
            frame: rect,
            delegate: self,
            default: 1
        )
            .addViewTo(view)
    }
    
    @objc func clickItem(_ sender: UIButton) {
        print("点击分段控件...")
    }
}

//MARK: - KeenTitleViewDelegate 代理
extension NextVc: KeenTitleViewDelegate {
 
    func numberOfTitles(in titleView: KeenTitleView) -> Array<String> {
        return items
    }
    
    func titleView(_ titleView: KeenTitleView, didSelectedAt index: Int) {
        pageView.scrollToPage(at: index)
    }
    
    func attributesOfTitles(for titleView: KeenTitleView) -> KeenTitleAttributes {
        var attr = KeenTitleAttributes()
        switch type {
        case 0: attr.style = .default
        case 1: attr.style = .scale
        case 2: attr.style = .cover
        case 3: attr.style = .underline
        default: attr.style = .underline
        }
        attr.layout = type == 5 ? .fixed : .automatic
        attr.viewBackColor = .white
        return attr
    }
}

//MARK: - KeenPageViewDelegate 代理
extension NextVc: KeenPageViewDelegate {
    
    func numberOfPageView(in pageView: KeenPageView) -> Array<UIViewController> {
        var arrs: [UIViewController] = []
        for _ in 0..<items.count {
            let controller = UIViewController()
            controller.view.backgroundColor = .colorRandom
            arrs.append(controller)
        }
        return arrs
    }
    
    func pageView(_ pageView: KeenPageView, from previousIndex: Int, to currentIndex: Int, progress: CGFloat) {
        titleView.scrollDidScroll(from: previousIndex, to: currentIndex, progress: progress)
    }
    
    func pageView(_ pageView: KeenPageView, didEndScrollAt index: Int) {
        titleView.scrollDidEndToIndex(at: index)
    }
}
